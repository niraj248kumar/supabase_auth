import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseImagesScreen extends StatefulWidget {
  const SupabaseImagesScreen({super.key});

  @override
  State<SupabaseImagesScreen> createState() => _SupabaseImagesScreenState();
}

class _SupabaseImagesScreenState extends State<SupabaseImagesScreen> {
  List<String> imageUrls = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchImagesFromSupabase();
  }

  Future<void> fetchImagesFromSupabase() async {
    setState(() {
      isLoading = true;
    });

    try {
      final files = await Supabase.instance.client.storage
          .from('images') // ✅ Bucket name
          .list(path: 'uploads'); // ✅ Folder name (uploads)

      final urls = files.map((file) {
        return Supabase.instance.client.storage
            .from('images')
            .getPublicUrl('uploads/${file.name}');
      }).toList();

      setState(() {
        imageUrls = urls;
      });
    } catch (e) {
      print("Error fetching images: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Uploaded Images')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : imageUrls.isEmpty
          ? Center(child: Text("No images found"))
          : ListView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(imageUrls[index]),
          );
        },
      ),
    );
  }
}
