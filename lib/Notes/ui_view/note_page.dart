import 'package:auth_supa/Notes/database_service/database_service.dart';
import 'package:flutter/material.dart';
import 'package:auth_supa/Notes/model/user_model.dart';
import '../../main.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final NotaDatabase db = NotaDatabase();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  void _addNote() async {
    await supabase.from("phones").insert({
      "name": _titleController.text.trim(),
      "price": int.tryParse(_priceController.text.trim()),
      "description": _contentController.text.trim()
    });

    _titleController.clear();
    _priceController.clear();
    _contentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Notes")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: "Price",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addNote,
                  child: const Text("Add Note"),
                ),
              ],
            ),
          ),

          // ✅ Realtime StreamBuilder
          Expanded(
            child: StreamBuilder<List<UserModel>>(
              stream: db.getNotesStream(), // realtime stream
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No notes found"));
                }

                final notes = snapshot.data!;
                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Column(
                          children: [
                            Row(
                              children: [
                                Text(note.name ?? ''),
                                const SizedBox(width: 10),
                                Text(note.description ?? ''),
                                SizedBox(width: 5,),
                                Text("${note.price}" ?? ''),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    showUpdateDialog(context, note);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => db.deleteNote(note.id!),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void showUpdateDialog(BuildContext context, UserModel note) {
    final nameController = TextEditingController(text: note.name);
    final descController = TextEditingController(text: note.description);
    final priceController =
    TextEditingController(text: note.price?.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Note"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await db.updateNote(
                id: note.id!,
                name: nameController.text,
                description: descController.text,
                price: int.tryParse(priceController.text),
              );
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }
}
