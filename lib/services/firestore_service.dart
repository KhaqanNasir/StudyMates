import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'dart:convert';
import '../model/study_group_model.dart';
import '../model/discussion_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore get firestore => _firestore;

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
    } catch (e) {
      throw Exception('Failed to save user: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      if (email.isEmpty) {
        throw Exception('Email cannot be empty');
      }

      if (!isAuthenticated) {
        throw Exception('User must be authenticated to fetch user data');
      }

      final normalizedEmail = email.toLowerCase().trim();
      final snapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: normalizedEmail)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data();
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch user by email: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserByUid(String uid) async {
    try {
      if (uid.isEmpty) {
        throw Exception('UID cannot be empty');
      }

      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
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
      throw Exception('Failed to get current user data: $e');
    }
  }

  Future<bool> userDocumentExists(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  Future<bool> emailExistsInAuth(String email) async {
    try {
      final methods = await _auth.fetchSignInMethodsForEmail(email.toLowerCase().trim());
      return methods.isNotEmpty;
    } catch (e) {
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
    } catch (e) {
      throw Exception('Failed to update user name: $e');
    }
  }

  Future<String> getIpAddress() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.ipify.org'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      return response.statusCode == 200 ? response.body.trim() : 'Unknown';
    } catch (e) {
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

      await _firestore.collection('otp_codes').doc(codeId).set({
        'email': normalizedEmail,
        'otp': otp,
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt': Timestamp.fromDate(expiryTime),
        'used': false,
      });

      await _sendOtpEmail(normalizedEmail, otp);
      await _cleanupOldOtps(normalizedEmail);
      return otp;
    } catch (e) {
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
    } catch (e) {
      throw Exception('Failed to send OTP email: $e');
    }
  }

  Future<bool> verifyOtpCode(String email, String otp) async {
    try {
      final normalizedEmail = email.toLowerCase().trim();
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
        return true;
      }
      return false;
    } catch (e) {
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
    } catch (e) {
      throw Exception('Failed to update password: $e');
    }
  }

  Future<List<StudyGroup>> getStudyGroups(String? department) async {
    try {
      Query query = _firestore.collection('study_groups').orderBy('createdAt', descending: true);
      if (department != null && department != 'All Departments') {
        query = query.where('department', isEqualTo: department);
      }

      final snapshot = await query.get();
      final userSnapshot = await _firestore
          .collection('user_groups')
          .where('userId', isEqualTo: currentUserId)
          .get();

      final joinedGroupIds = userSnapshot.docs.map((doc) => doc['groupId'] as String).toList();

      return snapshot.docs.map((doc) {
        return StudyGroup.fromFirestore(doc, joinedGroupIds.contains(doc.id));
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch study groups: $e');
    }
  }

  Future<void> joinGroup(String groupId) async {
    try {
      if (!isAuthenticated) throw Exception('User must be authenticated');

      final userData = await getCurrentUserData();
      if (userData == null) throw Exception('User data not found');

      await _firestore.collection('user_groups').add({
        'userId': currentUserId,
        'groupId': groupId,
        'joinedAt': FieldValue.serverTimestamp(),
      });

      await _firestore.collection('study_groups').doc(groupId).update({
        'memberCount': FieldValue.increment(1),
        'participants': FieldValue.arrayUnion([userData['fullName']]),
      });
    } catch (e) {
      throw Exception('Failed to join group: $e');
    }
  }

  Future<void> leaveGroup(String groupId) async {
    try {
      if (!isAuthenticated) throw Exception('User must be authenticated');

      final userData = await getCurrentUserData();
      if (userData == null) throw Exception('User data not found');

      final snapshot = await _firestore
          .collection('user_groups')
          .where('userId', isEqualTo: currentUserId)
          .where('groupId', isEqualTo: groupId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.delete();

        await _firestore.collection('study_groups').doc(groupId).update({
          'memberCount': FieldValue.increment(-1),
          'participants': FieldValue.arrayRemove([userData['fullName']]),
        });
      }
    } catch (e) {
      throw Exception('Failed to leave group: $e');
    }
  }

  Future<void> sendMessage(String groupId, String content, String senderName) async {
    try {
      if (!isAuthenticated) throw Exception('User must be authenticated');

      await _firestore.collection('messages').add({
        'groupId': groupId,
        'senderId': currentUserId,
        'senderName': senderName,
        'content': content,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Stream<List<Message>> getMessages(String groupId) {
    return _firestore
        .collection('messages')
        .where('groupId', isEqualTo: groupId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList());
  }

  Future<void> updateMessage(String messageId, String newContent) async {
    try {
      if (!isAuthenticated) throw Exception('User must be authenticated');

      await _firestore.collection('messages').doc(messageId).update({
        'content': newContent,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update message: $e');
    }
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      if (!isAuthenticated) throw Exception('User must be authenticated');

      await _firestore.collection('messages').doc(messageId).delete();
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }

  Stream<List<DocumentSnapshot>> getThreadsStream(String category, String searchQuery) {
    Query query = _firestore.collection('threads').orderBy('timestamp', descending: true);
    if (category != 'All') {
      query = query.where('category', isEqualTo: category);
    }
    if (searchQuery.isNotEmpty) {
      query = query.where('title', isGreaterThanOrEqualTo: searchQuery.toLowerCase());
    }
    return query.snapshots().map((snapshot) => snapshot.docs);
  }

  Future<void> addThread(DiscussionThread thread) async {
    try {
      if (!isAuthenticated) throw Exception('User must be authenticated');

      await _firestore.collection('threads').doc(thread.id).set(thread.toFirestore());
    } catch (e) {
      throw Exception('Failed to add thread: $e');
    }
  }

  Stream<List<ThreadComment>> getCommentsStream(String threadId) {
    return _firestore
        .collection('threads')
        .doc(threadId)
        .collection('thread_comments')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ThreadComment.fromFirestore(doc)).toList());
  }

  Future<void> addComment(String threadId, ThreadComment comment) async {
    try {
      if (!isAuthenticated) throw Exception('User must be authenticated');

      await _firestore
          .collection('threads')
          .doc(threadId)
          .collection('thread_comments')
          .doc(comment.id)
          .set(comment.toFirestore());
      await _firestore.collection('threads').doc(threadId).update({
        'replies': FieldValue.increment(1),
      }).catchError((e) {
        print('Failed to update replies count: $e');
      });
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  Future<void> toggleUpvote(String threadId, String userId) async {
    try {
      if (!isAuthenticated) throw Exception('User must be authenticated');

      final threadRef = _firestore.collection('threads').doc(threadId);
      final doc = await threadRef.get();
      final thread = DiscussionThread.fromFirestore(doc, userId);
      final isUpvoted = thread.upvotedBy.contains(userId);

      if (isUpvoted) {
        await threadRef.update({
          'upvotes': FieldValue.increment(-1),
          'upvotedBy': FieldValue.arrayRemove([userId]),
        });
      } else {
        await threadRef.update({
          'upvotes': FieldValue.increment(1),
          'upvotedBy': FieldValue.arrayUnion([userId]),
        });
      }
    } catch (e) {
      throw Exception('Failed to toggle upvote: $e');
    }
  }
}