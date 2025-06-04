import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../view_model/signup_view_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpViewModel(),
      child: Consumer<SignUpViewModel>(
        builder: (context, viewModel, _) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.blueAccent),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Form(
              key: viewModel.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sign Up",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Create your Study Mates account with COMSATS email",
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: viewModel.fullNameController,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      prefixIcon: const Icon(Icons.person, color: Colors.blueAccent),
                      labelStyle: GoogleFonts.poppins(fontSize: 16),
                    ),
                    validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: viewModel.emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "e.g., fa22-bcs-039@students.cuisahiwal.edu.pk",
                      prefixIcon: const Icon(Icons.email, color: Colors.blueAccent),
                      labelStyle: GoogleFonts.poppins(fontSize: 16),
                    ),
                    validator: viewModel.validateEmail,
                  ),
                  const SizedBox(height: 25),
                  DropdownButtonFormField<String>(
                    value: viewModel.selectedDepartment,
                    items: viewModel.departments
                        .map((dept) => DropdownMenuItem(value: dept, child: Text(dept)))
                        .toList(),
                    onChanged: viewModel.updateDepartment,
                    decoration: InputDecoration(
                      labelText: "Department",
                      prefixIcon: const Icon(Icons.school, color: Colors.blueAccent),
                      labelStyle: GoogleFonts.poppins(fontSize: 16),
                    ),
                    validator: (value) => value == null ? 'Please select a department' : null,
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: viewModel.passwordController,
                    obscureText: viewModel.obscurePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock, color: Colors.blueAccent),
                      suffixIcon: IconButton(
                        icon: Icon(
                          viewModel.obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.blueAccent,
                        ),
                        onPressed: viewModel.togglePasswordVisibility,
                      ),
                      labelStyle: GoogleFonts.poppins(fontSize: 16),
                    ),
                    validator: viewModel.validatePassword,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: viewModel.agreeToTerms,
                        onChanged: viewModel.toggleAgreeToTerms,
                        activeColor: Colors.blueAccent,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Show terms
                          },
                          child: Text(
                            "I agree to the Terms & Conditions",
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => viewModel.signUp(context),
                      child: Text(
                        "Sign Up",
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
                      onPressed: () => viewModel.signUpWithGoogle(context),
                      icon: const Icon(Icons.g_translate, color: Colors.red),
                      label: Text("Sign up with Google", style: GoogleFonts.poppins()),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?", style: GoogleFonts.poppins(fontSize: 14)),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        child: Text(
                          "Sign In",
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
      ),
    );
  }

  @override
  void dispose() {
    Provider.of<SignUpViewModel>(context, listen: false).disposeControllers();
    super.dispose();
  }
}