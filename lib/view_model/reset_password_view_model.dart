import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/firestore_service.dart';

class ResetPasswordViewModel with ChangeNotifier {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  String? recoveryEmail;

  void setRecoveryEmail(String email) {
    recoveryEmail = email;
  }

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword = !obscureConfirmPassword;
    notifyListeners();
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    final pattern = r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*]).{6,}$';
    if (!RegExp(pattern).hasMatch(value)) {
      return 'Include letter, digit, and special character';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> resetPassword(BuildContext context) async {
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    final passwordError = validatePassword(password);
    final confirmPasswordError = validateConfirmPassword(confirmPassword);

    if (passwordError != null) {
      Fluttertoast.showToast(msg: passwordError);
      return;
    }
    if (confirmPasswordError != null) {
      Fluttertoast.showToast(msg: confirmPasswordError);
      return;
    }

    if (recoveryEmail == null) {
      Fluttertoast.showToast(msg: 'Recovery email is missing');
      return;
    }

    try {
      // Update password via FirestoreService
      await _firestoreService.updateUserPassword(recoveryEmail!, password);
      Fluttertoast.showToast(msg: 'Password reset successfully. Please log in.');
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Reset failed: $e');
    }
  }

  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}