import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:auth_supa/Notes/model/user_model.dart';

import '../../main.dart';

class NotaDatabase {
  final database = Supabase.instance.client.from("phones");

  Future<List<UserModel>> getUserTable() async {
    try {
      final data = await supabase.from('phones').select();
      var result = data.map((e) => UserModel.fromMap(e)).toList();
      return result;
    } catch (e) {
      print(e);
      return <UserModel>[];
    }
  }

  // Stream Notes
  Stream<List<UserModel>> getNotesStream() {
    return database
        .stream(primaryKey: ["id"])
        .map((data) => data.map((note) => UserModel.fromMap(note)).toList());
  }

  Future<void> updateNote({
    required int id,
    String? name,
    String? description,
    int? price,
  }) async {
    try {
      await database
          .update({'name': name, 'description': description, 'price': price})
          .eq('id', id);
    } catch (e) {
      print("Update Error: $e");
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await database.delete().eq('id', id);
    } catch (e) {
      print("Delete Error: $e");
    }
  }
}
