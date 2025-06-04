import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../view_model/login_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final LoginViewModel _viewModel = LoginViewModel();
  bool _isLoading = false;

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blueAccent),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sign In",
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Please login with your COMSATS email",
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _viewModel.emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "e.g., fa22-bcs-039@students.cuisahiwal.edu.pk",
                    labelStyle: GoogleFonts.poppins(),
                    prefixIcon: const Icon(Icons.email, color: Colors.blueAccent),
                  ),
                  validator: _viewModel.validateEmail,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 25),
                TextFormField(
                  controller: _viewModel.passwordController,
                  obscureText: _viewModel.obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: GoogleFonts.poppins(),
                    prefixIcon: const Icon(Icons.lock, color: Colors.blueAccent),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _viewModel.obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () {
                        setState(() => _viewModel.togglePasswordVisibility());
                      },
                    ),
                  ),
                  validator: _viewModel.validatePassword,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pushNamed(context, '/forget-password'),
                    child: Text(
                      "Forgot Password?",
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.blueAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                      if (_formKey.currentState!.validate()) {
                        _setLoading(true);
                        await _viewModel.signIn(context);
                        _setLoading(false);
                      }
                    },
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                      "Sign In",
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Row(
                  children: [
                    Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("OR"),
                    ),
                    Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _isLoading
                        ? null
                        : () async {
                      _setLoading(true);
                      await _viewModel.signInWithGoogle(context);
                      _setLoading(false);
                    },
                    icon: const Icon(Icons.g_translate, color: Colors.red),
                    label: Text("Sign in with Google", style: GoogleFonts.poppins()),
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.grey)),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?", style: GoogleFonts.poppins()),
                    TextButton(
                      onPressed: _isLoading ? null : () => Navigator.pushNamed(context, '/signup'),
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}