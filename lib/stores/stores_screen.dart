import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'item_show.dart';

class StoresScreen extends StatefulWidget {
  const StoresScreen({super.key});

  @override
  State<StoresScreen> createState() => _StoresScreenState();
}

class _StoresScreenState extends State<StoresScreen> {
  File? _imageUpload;

  Future pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageUpload = File(image.path);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image select Successful...")),);
      });
    }
  }

  Future uploadImage() async {
    if (_imageUpload == null) return;
     // Generate unique file name
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = "uploads/$fileName";
    await Supabase.instance.client.storage
        .from("images")
        .upload(path, _imageUpload!);
    Fluttertoast.showToast(msg: "Image Upload Successful...");
    Navigator.push(context, MaterialPageRoute(builder: (context) => SupabaseImagesScreen(),));

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Stores"))),
      body: Center(
        child: Column(

          children: [
            _imageUpload != null
                ? Image.file(_imageUpload!)
                : Text("No image selected"),

            ElevatedButton(onPressed: pickImage, child: Text("Gallery")),

            ElevatedButton(onPressed: uploadImage, child: Text("Upload")),
          ],
        ),
      ),
    );
  }
}
