import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'dart:convert';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool get isAuthenticated => _auth.currentUser != null;
  String? get currentUserId => _auth.currentUser?.uid;
  String? get currentUserEmail => _auth.currentUser?.email;

  Future<void> saveUser({
    required String uid,
    required String fullName,
    required String email,
    required String department,
    required String ipAddress,
  }) async {
    try {
      if (!isAuthenticated) {
        throw Exception('User must be authenticated to save data');
      }

      final normalizedEmail = email.toLowerCase().trim();
      await _firestore.collection('users').doc(uid).set({
        'uniqueId': const Uuid().v4(),
        'fullName': fullName,
        'email': normalizedEmail,
        'department': department,
        'ipAddress': ipAddress,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('User saved successfully: $normalizedEmail');
    } catch (e) {
      print('Error saving user: $e');
      throw Exception('Failed to save user: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      if (email.isEmpty) {
        throw Exception('Email cannot be empty');
      }

      if (!isAuthenticated) {
        print('No authenticated user found. Current user: ${_auth.currentUser?.email}');
        throw Exception('User must be authenticated to fetch user data');
      }

      final normalizedEmail = email.toLowerCase().trim();
      print('Authenticated user: ${currentUserEmail}, UID: ${currentUserId}');
      print('Searching for user with email: $normalizedEmail');

      final snapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: normalizedEmail)
          .limit(1)
          .get();

      print('Query executed. Found ${snapshot.docs.length} documents');

      if (snapshot.docs.isNotEmpty) {
        final userData = snapshot.docs.first.data();
        print('User found: ${userData['fullName']} (UID: ${snapshot.docs.first.id})');
        return userData;
      }

      print('No user found with email: $normalizedEmail');
      return null;
    } catch (e) {
      print('Error in getUserByEmail: $e');
      if (e.toString().contains('permission-denied') || e.toString().contains('PERMISSION_DENIED')) {
        throw Exception('Permission denied. Ensure Firestore rules allow authenticated users to query by email.');
      }
      throw Exception('Failed to fetch user by email: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserByUid(String uid) async {
    try {
      if (uid.isEmpty) {
        throw Exception('UID cannot be empty');
      }

      if (!isAuthenticated) {
        throw Exception('User must be authenticated to access data');
      }

      print('Fetching user data for UID: $uid');

      final doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        final userData = doc.data();
        print('User data retrieved successfully');
        return userData;
      }

      print('No user document found for UID: $uid');
      return null;
    } catch (e) {
      print('Error in getUserByUid: $e');
      throw Exception('Failed to fetch user by UID: $e');
    }
  }

  Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      if (!isAuthenticated) {
        throw Exception('No authenticated user found');
      }

      return await getUserByUid(currentUserId!);
    } catch (e) {
      print('Error in getCurrentUserData: $e');
      throw Exception('Failed to get current user data: $e');
    }
  }

  Future<bool> userDocumentExists(String uid) async {
    try {
      if (!isAuthenticated) {
        return false;
      }

      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.exists;
    } catch (e) {
      print('Error checking if user document exists: $e');
      return false;
    }
  }

  Future<bool> emailExistsInAuth(String email) async {
    try {
      final methods = await _auth.fetchSignInMethodsForEmail(email.toLowerCase().trim());
      return methods.isNotEmpty;
    } catch (e) {
      print('Error checking email in auth: $e');
      return false;
    }
  }

  Future<void> updateUserName({
    required String uid,
    required String fullName,
  }) async {
    try {
      if (!isAuthenticated) {
        throw Exception('User must be authenticated to update data');
      }

      await _firestore.collection('users').doc(uid).update({
        'fullName': fullName,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('User name updated successfully');
    } catch (e) {
      print('Error updating user name: $e');
      throw Exception('Failed to update user name: $e');
    }
  }

  Future<String> getIpAddress() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.ipify.org'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return response.body.trim();
      }
      return 'Unknown';
    } catch (e) {
      print('Error getting IP address: $e');
      return 'Unknown';
    }
  }

  Future<String> saveOtpCode(String email) async {
    try {
      final normalizedEmail = email.toLowerCase().trim();

      final otp = (1000 + (DateTime.now().millisecondsSinceEpoch % 9000))
          .toString()
          .padLeft(4, '0');
      final codeId = const Uuid().v4();
      final expiryTime = DateTime.now().add(const Duration(minutes: 5));

      print('Saving OTP for email: $normalizedEmail');

      await _firestore.collection('otp_codes').doc(codeId).set({
        'email': normalizedEmail,
        'otp': otp,
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt': Timestamp.fromDate(expiryTime),
        'used': false,
      });

      print('OTP saved successfully, sending email...');
      await _sendOtpEmail(normalizedEmail, otp);

      await _cleanupOldOtps(normalizedEmail);

      return otp;
    } catch (e) {
      print('Error saving OTP: $e');
      throw Exception('Failed to save OTP: $e');
    }
  }

  Future<void> _sendOtpEmail(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('https://us-central1-study-mates-6f666.cloudfunctions.net/sendOtpEmail'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'otp': otp,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception('Failed to send OTP email: ${response.body}');
      }

      print('OTP email sent successfully');
    } catch (e) {
      print('Error sending OTP email: $e');
      throw Exception('Failed to send OTP email: $e');
    }
  }

  Future<bool> verifyOtpCode(String email, String otp) async {
    try {
      final normalizedEmail = email.toLowerCase().trim();

      print('Verifying OTP for email: $normalizedEmail');

      final snapshot = await _firestore
          .collection('otp_codes')
          .where('email', isEqualTo: normalizedEmail)
          .where('otp', isEqualTo: otp)
          .where('expiresAt', isGreaterThan: Timestamp.now())
          .where('used', isEqualTo: false)
          .orderBy('expiresAt', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await _firestore.collection('otp_codes').doc(snapshot.docs.first.id).update({
          'used': true,
          'usedAt': FieldValue.serverTimestamp(),
        });

        print('OTP verified successfully');
        return true;
      }

      print('OTP verification failed - invalid or expired');
      return false;
    } catch (e) {
      print('Error verifying OTP: $e');
      throw Exception('Failed to verify OTP: $e');
    }
  }

  Future<void> _cleanupOldOtps(String email) async {
    try {
      final normalizedEmail = email.toLowerCase().trim();

      final snapshot = await _firestore
          .collection('otp_codes')
          .where('email', isEqualTo: normalizedEmail)
          .where('expiresAt', isLessThanOrEqualTo: Timestamp.now())
          .get();

      final batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      if (snapshot.docs.isNotEmpty) {
        await batch.commit();
        print('Cleaned up ${snapshot.docs.length} expired OTPs');
      }
    } catch (e) {
      print('Failed to clean up old OTPs: $e');
    }
  }

  Future<void> updateUserPassword(String email, String newPassword) async {
    try {
      final normalizedEmail = email.toLowerCase().trim();

      final response = await http.post(
        Uri.parse('https://us-central1-study-mates-6f666.cloudfunctions.net/updatePassword'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': normalizedEmail,
          'newPassword': newPassword,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception('Failed to update password: ${response.body}');
      }

      print('Password updated successfully');
    } catch (e) {
      print('Error updating password: $e');
      throw Exception('Failed to update password: $e');
    }
  }

  Future<void> testFirestoreConnection() async {
    try {
      if (!isAuthenticated) {
        print('❌ User not authenticated');
        return;
      }

      print('✅ User authenticated: ${currentUserEmail}');

      final userData = await getCurrentUserData();
      if (userData != null) {
        print('✅ Can read user data: ${userData['fullName']}');
      } else {
        print('⚠️ User document not found');
      }

      final otpQuery = await _firestore
          .collection('otp_codes')
          .limit(1)
          .get();
      print('✅ Can access OTP collection');

      print('🎉 Firestore connection test completed successfully');
    } catch (e) {
      print('❌ Firestore connection test failed: $e');
    }
  }
}