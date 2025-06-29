
import 'package:auth_supa/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../view/home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUpUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    try {
      final res = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      if (res.session != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign up successful! Please verify email.')),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign up failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: signUpUser,
              child: const Text("Sign Up"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(),)); // back to login
              },
              child: const Text("Already have an account? Login"),
            )
          ],
        ),
      ),
    );
  }
}
