import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/firestore_service.dart';

class LoginViewModel {
  bool obscurePassword = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@students\.cuisahiwal\.edu\.pk$').hasMatch(value)) {
      return 'Enter a valid COMSATS email (e.g., fa22-bcs-039@students.cuisahiwal.edu.pk)';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  Future<void> signIn(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (validateEmail(email) == null && validatePassword(password) == null) {
      try {
        // Authenticate with Firebase first
        await _auth.signInWithEmailAndPassword(email: email, password: password);

        // Check Firestore for user data
        final firestoreUser = await _firestoreService.getUserByEmail(email);
        if (firestoreUser == null) {
          await _auth.signOut();
          Fluttertoast.showToast(msg: 'User not found in Firestore. Please complete registration.');
          Navigator.pushNamed(context, '/signup', arguments: {'email': email});
          return;
        }

        Fluttertoast.showToast(msg: 'Login successful');
        Navigator.pushReplacementNamed(context, '/home');
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'user-not-found':
            message = 'This email is not registered. Please sign up first.';
            break;
          case 'wrong-password':
            message = 'Incorrect password. Please try again.';
            break;
          case 'invalid-email':
            message = 'Invalid email format.';
            break;
          case 'user-disabled':
            message = 'This user account has been disabled.';
            break;
          default:
            message = 'Login failed. ${e.message}';
        }
        Fluttertoast.showToast(msg: message);
      } catch (e) {
        Fluttertoast.showToast(msg: 'Unexpected error: $e');
      }
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        Fluttertoast.showToast(msg: 'Google Sign-In cancelled');
        return;
      }
      if (!googleUser.email.endsWith('@students.cuisahiwal.edu.pk')) {
        await googleSignIn.signOut();
        Fluttertoast.showToast(msg: 'Only COMSATS emails allowed');
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Authenticate with Firebase
      await _auth.signInWithCredential(credential);

      // Check Firestore
      final firestoreUser = await _firestoreService.getUserByEmail(googleUser.email);
      if (firestoreUser == null) {
        await _auth.signOut();
        await googleSignIn.signOut();
        Fluttertoast.showToast(msg: 'User not found in Firestore. Please complete registration.');
        Navigator.pushNamed(context, '/signup', arguments: {'email': googleUser.email});
        return;
      }

      Fluttertoast.showToast(msg: 'Google Sign-In successful');
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Google Sign-In error: $e');
      await _auth.signOut();
      await GoogleSignIn().signOut();
    }
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}