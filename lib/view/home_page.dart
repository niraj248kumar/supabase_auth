import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Declare the TextEditingController here
  final TextEditingController titleController = TextEditingController();

  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void dispose() {
    // Dispose of the controller when the widget is removed
    titleController.dispose();
    super.dispose();
  }

  void logoutUser(BuildContext context) async {
    try {
      await supabase.auth.signOut();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Logged out successfully')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Logout failed: $e')));
    }
  }

  Future<void> insertTodo(String title, String userId) async {
    try {
      await supabase.from('todos').insert({'title': title, 'user_id': userId});
      print('Data inserted successfully!');
      // Optionally clear the text field after successful insertion
      titleController.clear();
      // Optionally show a confirmation message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Todo added!')));
    } catch (e) {
      print('Error inserting data: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error adding todo: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(child: Text('Home Page')),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logoutUser(context),
          ),
        ],
      ),
      body:Column(
        children: [

        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showAlertDialog,
        label: Row(
          children: [Text("Add"), SizedBox(width: 5), Icon(Icons.add)],
        ),
      ),
    );
  }

  Future showAlertDialog() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Are you sure you want to continue Insert?"),
          actions: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Name..",
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed:() {
                String title = titleController.text.trim();
                // Check if the user is authenticated before inserting data
                if (supabase.auth.currentUser != null) {
                  String userId = supabase.auth.currentUser!.id;
                  insertTodo(title, userId);
                } else {
                  // Handle the case where the user is not authenticated
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User not authenticated')),
                  );
                }
              },
              child: Text("Insert"),
            ),
          ],
        );
      },
    );
  }
}
