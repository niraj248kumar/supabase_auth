import 'package:auth_supa/auth/sing_up.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/login_page.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkUserLoggedIn();
  }

  void checkUserLoggedIn() async {
    await Future.delayed(const Duration(seconds: 2)); // Splash delay

    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      // ✅ User is already logged in
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      // ❌ User is not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignUpPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
