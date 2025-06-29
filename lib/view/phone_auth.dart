import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart'; // jahan supabase global client banaya

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  Future<void> sendOtp() async {
    final phone = '+91' + phoneController.text.trim();

    try {
      await supabase.auth.signInWithOtp(phone: phone);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP sent to $phone')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> verifyOtp() async {
    final phone = '+91' + phoneController.text.trim();
    final otp = otpController.text.trim();

    try {
      await supabase.auth.verifyOTP(
        type: OtpType.sms,
        phone: phone,
        token: otp,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP Verified! Login Successful')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP Verification Failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Phone Auth")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Phone (e.g., 96083xxxxx)'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: otpController,
              decoration: InputDecoration(labelText: 'Enter OTP'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: sendOtp, child: Text("Send OTP")),
            SizedBox(height: 10),
            ElevatedButton(onPressed: verifyOtp, child: Text("Verify OTP")),
          ],
        ),
      ),
    );
  }
}
