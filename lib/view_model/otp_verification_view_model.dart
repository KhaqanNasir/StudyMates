import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/firestore_service.dart';

class OtpVerificationViewModel {
  final List<TextEditingController> otpControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());
  String? recoveryEmail;
  final FirestoreService _firestoreService = FirestoreService();

  void setRecoveryEmail(String email) {
    recoveryEmail = email;
  }

  String get otpCode => otpControllers.map((c) => c.text.trim()).join();

  void handleOtpInput(int index, String value, VoidCallback onComplete) {
    if (value.length > 1) {
      otpControllers[index].text = value[0]; // Allow only first digit
    }

    if (value.isNotEmpty && index < focusNodes.length - 1) {
      focusNodes[index + 1].requestFocus();
    } else if (index == focusNodes.length - 1) {
      focusNodes[index].unfocus();
      if (otpCode.length == 4) {
        onComplete();
      }
    }
  }

  String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter OTP';
    }
    if (!RegExp(r'^\d$').hasMatch(value)) {
      return 'Only digits allowed';
    }
    return null;
  }

  Future<void> verifyOtp(BuildContext context) async {
    if (otpCode.length != 4) {
      Fluttertoast.showToast(msg: 'Please enter a 4-digit OTP');
      return;
    }

    if (recoveryEmail == null) {
      Fluttertoast.showToast(msg: 'Recovery email is missing');
      return;
    }

    try {
      final isValid = await _firestoreService.verifyOtpCode(recoveryEmail!, otpCode);
      if (isValid) {
        Fluttertoast.showToast(msg: 'OTP verified successfully');
        Navigator.pushNamed(context, '/reset-password', arguments: recoveryEmail);
      } else {
        Fluttertoast.showToast(msg: 'Invalid or expired OTP. Try again.');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Verification error: $e');
    }
  }

  Future<void> resendOtpCode(BuildContext context) async {
    if (recoveryEmail == null) {
      Fluttertoast.showToast(msg: 'No recovery email found.');
      return;
    }

    try {
      await _firestoreService.saveOtpCode(recoveryEmail!);
      Fluttertoast.showToast(msg: 'New OTP sent to $recoveryEmail');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to resend OTP: $e');
    }
  }

  void dispose() {
    for (final controller in otpControllers) {
      controller.dispose();
    }
    for (final node in focusNodes) {
      node.dispose();
    }
  }
}