import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/firestore_service.dart';

class SignUpViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  bool agreeToTerms = false;
  bool obscurePassword = true;
  String? selectedDepartment;
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<String> departments = [
    'Computer Science',
    'Software Engineering',
    'Electrical Engineering',
    'Civil Engineering',
    'Mechanical Engineering',
    'Business Administration',
    'Mathematics',
    'Food Sciences & Nutrition',
  ];

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void toggleAgreeToTerms(bool? value) {
    agreeToTerms = value ?? false;
    notifyListeners();
  }

  void updateDepartment(String? value) {
    selectedDepartment = value;
    notifyListeners();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@students\.cuisahiwal\.edu\.pk$').hasMatch(value)) {
      return 'Please enter a valid COMSATS email (e.g., fa22-bcs-039@students.cuisahiwal.edu.pk)';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    final pattern = r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*]).{6,}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(value) ? null : 'Include letter, digit & special character';
  }

  bool validateAndSaveForm() {
    return formKey.currentState?.validate() == true && agreeToTerms && selectedDepartment != null;
  }

  Future<void> signUp(BuildContext context) async {
    if (validateAndSaveForm()) {
      try {
        final ipAddress = await _firestoreService.getIpAddress();
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        await _firestoreService.saveUser(
          uid: userCredential.user!.uid,
          fullName: fullNameController.text.trim(),
          email: emailController.text.trim(),
          department: selectedDepartment!,
          ipAddress: ipAddress,
        );
        Fluttertoast.showToast(msg: 'Sign up successful');
        Navigator.pushReplacementNamed(context, '/login');
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'email-already-in-use':
            message = 'This email is already registered. Please log in.';
            break;
          case 'invalid-email':
            message = 'Invalid email format.';
            break;
          case 'operation-not-allowed':
            message = 'Email/password accounts are not enabled.';
            break;
          case 'weak-password':
            message = 'Your password is too weak.';
            break;
          default:
            message = 'Sign up failed. ${e.message}';
        }
        Fluttertoast.showToast(msg: message);
      }
    } else if (!agreeToTerms) {
      Fluttertoast.showToast(msg: 'Please agree to the terms & conditions');
    } else if (selectedDepartment == null) {
      Fluttertoast.showToast(msg: 'Please select a department');
    }
  }

  Future<void> signUpWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        Fluttertoast.showToast(msg: 'Google Sign-Up cancelled');
        return;
      }
      if (!googleUser.email.endsWith('@students.cuisahiwal.edu.pk')) {
        await googleSignIn.signOut();
        Fluttertoast.showToast(msg: 'Only COMSATS emails allowed (e.g., fa22-bcs-039@students.cuisahiwal.edu.pk)');
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      final ipAddress = await _firestoreService.getIpAddress();
      await _firestoreService.saveUser(
        uid: userCredential.user!.uid,
        fullName: googleUser.displayName ?? 'Unknown',
        email: googleUser.email,
        department: selectedDepartment ?? 'Unknown',
        ipAddress: ipAddress,
      );
      Fluttertoast.showToast(msg: 'Google Sign-Up successful');
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Google Sign-Up error: $e');
    }
  }

  void disposeControllers() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
