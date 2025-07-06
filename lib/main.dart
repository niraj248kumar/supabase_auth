import 'package:auth_supa/phone_auth/phone_auth.dart'
    show PhoneAuth, PhoneAuthPage, PhoneAuthUI;
import 'package:auth_supa/phone_auth/phone_auth2.dart';
import 'package:auth_supa/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'Notes/ui_view/note_page.dart' show HomePage, HomePageScreen, NotePage, NotesScreen;
import 'auth/sing_up.dart';
import 'google_auth/google_auth.dart';

const databaseUrl = 'https://maqyuvmmlmuhvwzivbis.supabase.co';
const databaseAnnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1hcXl1dm1tbG11aHZ3eml2YmlzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTEwMTMyNTMsImV4cCI6MjA2NjU4OTI1M30.i_T9fdbIS30wuYT7YDvpcWCE1UNHRPFKN6B8magM0fk';

void main() async {
  await Supabase.initialize(
      url: databaseUrl,
      anonKey: databaseAnnonKey,
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotesScreen(),
    );
  }
}
