import 'package:auth_supa/stores/stores_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
      url: "https://maqyuvmmlmuhvwzivbis.supabase.co",
      anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1hcXl1dm1tbG11aHZ3eml2YmlzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTEwMTMyNTMsImV4cCI6MjA2NjU4OTI1M30.i_T9fdbIS30wuYT7YDvpcWCE1UNHRPFKN6B8magM0fk",
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
      home: StoresScreen(),
    );
  }
}
