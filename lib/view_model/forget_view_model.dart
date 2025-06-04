import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/firestore_service.dart';

class ForgetViewModel {
  final TextEditingController emailController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@students\.cuisahiwal\.edu\.pk$').hasMatch(value)) {
      return 'Please enter a valid COMSATS email (e.g., fa22-bcs-039@students.cuisahiwal.edu.pk)';
    }
    return null;
  }

  Future<void> sendResetCode(BuildContext context) async {
    final email = emailController.text.trim();
    final validationError = validateEmail(email);

    if (validationError != null) {
      Fluttertoast.showToast(msg: validationError);
      return;
    }

    try {
      // Check if email exists in Firebase Authentication
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      if (methods.isEmpty) {
        Fluttertoast.showToast(msg: 'No user found with this email.');
        return;
      }

      // Check if email exists in Firestore
      final userData = await _firestoreService.getUserByEmail(email);
      if (userData == null) {
        Fluttertoast.showToast(msg: 'User data not found in database.');
        return;
      }

      // Generate and send OTP
      await _firestoreService.saveOtpCode(email);

      Fluttertoast.showToast(msg: 'OTP sent to $email');

      Navigator.pushNamed(context, '/otp-verification', arguments: email);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error sending reset code: $e');
    }
  }

  void dispose() {
    emailController.dispose();
  }
}