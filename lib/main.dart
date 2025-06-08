import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'view/login_screen.dart';
import 'view/signup_screen.dart';
import 'view/forget_screen.dart';
import 'view/otp_screen.dart';
import 'view/reset_password_screen.dart';
import 'home.dart';
import 'view/past_paper_screen.dart';
import 'learn_more.dart';
import 'study_materials.dart';
import 'discussion.dart';
import 'study_groups.dart';
import 'splash_screen.dart';
import 'setting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyDSXHCTgBmMWRcky2iO7PUksrz6xNc1hCs",
          authDomain: "study-mates-6f666.firebaseapp.com",
          projectId: "study-mates-6f666",
          storageBucket: "study-mates-6f666.firebasestorage.app",
          messagingSenderId: "96286627682",
          appId: "1:96286627682:web:4f2bbd1df6bc91f0607e3b",
          measurementId: "G-219M0NWBBK",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    print('Firebase initialization failed: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Study Mates - COMSATS",
      initialRoute: '/',
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.blueAccent[100]),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            textStyle: const TextStyle(fontSize: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          bodyLarge: TextStyle(fontSize: 18),
          bodyMedium: TextStyle(fontSize: 16),
          labelLarge: TextStyle(fontSize: 18),
        ),
      ),
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => AuthGuard(child: const HomeScreen()),
        '/past-papers': (context) => AuthGuard(child: const PastPapersScreen()),
        '/learn-more': (context) => AuthGuard(child: const LearnMorePage()),
        '/study-materials': (context) => AuthGuard(child: const StudyMaterialsScreen()),
        '/discussion': (context) => AuthGuard(child: const DiscussionScreen()),
        '/study-groups': (context) => AuthGuard(child: const StudyGroupsScreen()),
        '/forget-password': (context) => const ForgotPasswordPage(),
        '/otp-verification': (context) => const OtpVerificationPage(),
        '/reset-password': (context) => const ResetPasswordScreen(),
        '/settings': (context) => AuthGuard(child: const SettingsPage()),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(
            builder: (context) => StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SplashScreen();
                }
                if (snapshot.hasData) {
                  return const HomeScreen();
                }
                return const LoginPage();
              },
            ),
          );
        }
        return null;
      },
    );
  }
}

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return child;
        }
        return const LoginPage();
      },
    );
  }
}