import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/firestore_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _firestoreService = FirestoreService();
  final _auth = FirebaseAuth.instance;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;

  // Controllers for editable fields
  final _nameController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  // User data
  String _email = '';
  String _department = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthAndLoadData();
  }

  Future<void> _checkAuthAndLoadData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        Fluttertoast.showToast(
          msg: 'Please sign in to access settings.',
          backgroundColor: Colors.red,
          toastLength: Toast.LENGTH_LONG,
        );
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      final userData = await _firestoreService.getUserByEmail(user.email!);
      if (userData != null) {
        setState(() {
          _nameController.text = userData['fullName'] ?? '';
          _email = user.email!;
          _department = userData['department'] ?? '';
          _isLoading = false;
        });
      } else {
        Fluttertoast.showToast(
          msg: 'User data not found in database.',
          backgroundColor: Colors.red,
          toastLength: Toast.LENGTH_LONG,
        );
        setState(() => _isLoading = false);
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error loading user data: $e',
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  // Custom input decoration
  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
    bool enabled = true,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blueAccent, size: 20),
      ),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      filled: true,
      fillColor: enabled ? Colors.grey.shade50 : Colors.grey.shade100,
      labelStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: enabled ? Colors.grey.shade700 : Colors.grey.shade500,
        fontWeight: FontWeight.w500,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: Colors.blueAccent,
          strokeWidth: 3,
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enhanced Profile Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueAccent.withOpacity(0.1),
                      Colors.blueAccent.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.blueAccent.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blueAccent,
                                Colors.blueAccent.withOpacity(0.7),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueAccent.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 45,
                            color: Colors.white,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _nameController.text.isNotEmpty
                          ? _nameController.text
                          : 'User Name',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _department.isNotEmpty ? _department : 'Department',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Form Section Title
              Text(
                'Account Information',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 16),

              // Full Name Field
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _nameController,
                  decoration: _buildInputDecoration(
                    label: 'Full Name',
                    icon: Icons.person_outline,
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Email Field (Read-only)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  initialValue: _email,
                  enabled: false,
                  decoration: _buildInputDecoration(
                    label: 'Email Address',
                    icon: Icons.email_outlined,
                    enabled: false,
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Department Field (Read-only)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  initialValue: _department,
                  enabled: false,
                  decoration: _buildInputDecoration(
                    label: 'Department',
                    icon: Icons.school_outlined,
                    enabled: false,
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Security Section Title
              Text(
                'Security Settings',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 16),

              // Current Password Field
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _currentPasswordController,
                  obscureText: _obscureCurrentPassword,
                  decoration: _buildInputDecoration(
                    label: 'Current Password',
                    icon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureCurrentPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () {
                        setState(() => _obscureCurrentPassword = !_obscureCurrentPassword);
                      },
                    ),
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),

              // New Password Field
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscureNewPassword,
                  decoration: _buildInputDecoration(
                    label: 'New Password (Optional)',
                    icon: Icons.lock_reset_outlined,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNewPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () {
                        setState(() => _obscureNewPassword = !_obscureNewPassword);
                      },
                    ),
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*]).{6,}$')
                          .hasMatch(value)) {
                        return 'Include letter, digit, and special character';
                      }
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 40),

              // Save Button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.save_outlined, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Save Changes',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Logout Button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: OutlinedButton(
                  onPressed: _logout,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    side: BorderSide(color: Colors.red.shade400, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: Colors.red.shade50,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_outlined, color: Colors.red.shade600, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.red.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);
      try {
        final user = _auth.currentUser;
        if (user == null) {
          Fluttertoast.showToast(
            msg: 'No user is signed in.',
            backgroundColor: Colors.red,
            toastLength: Toast.LENGTH_LONG,
          );
          Navigator.pushReplacementNamed(context, '/login');
          setState(() => _isLoading = false);
          return;
        }

        // Re-authenticate user
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _currentPasswordController.text.trim(),
        );
        await user.reauthenticateWithCredential(credential);

        // Update full name in Firestore
        await _firestoreService.updateUserName(
          uid: user.uid,
          fullName: _nameController.text.trim(),
        );

        // Update password if provided
        if (_newPasswordController.text.isNotEmpty) {
          await user.updatePassword(_newPasswordController.text.trim());
        }

        Fluttertoast.showToast(
          msg: 'Changes saved successfully',
          backgroundColor: Colors.green,
          toastLength: Toast.LENGTH_LONG,
        );

        setState(() => _isLoading = false);
        if (mounted) Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        Fluttertoast.showToast(
          msg: 'Error: ${e.message}',
          backgroundColor: Colors.red,
          toastLength: Toast.LENGTH_LONG,
        );
        setState(() => _isLoading = false);
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Error saving changes: $e',
          backgroundColor: Colors.red,
          toastLength: Toast.LENGTH_LONG,
        );
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _logout() async {
    setState(() => _isLoading = true);
    try {
      await _auth.signOut();
      Fluttertoast.showToast(
        msg: 'Logged out successfully',
        backgroundColor: Colors.green,
        toastLength: Toast.LENGTH_LONG,
      );
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error logging out: $e',
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}