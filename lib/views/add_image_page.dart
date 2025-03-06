import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddImagePage extends StatefulWidget {
  final String userId; // Get user ID from previous page

  const AddImagePage({super.key, required this.userId});

  @override
  State<AddImagePage> createState() => _AddImagePageState();
}

class _AddImagePageState extends State<AddImagePage> {
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  Future<void> requestPermission() async {
    var status = await Permission.photos.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      print("Permission Denied. Request manually in settings.");
    }
  }

  Future<void> uploadToImgBB() async {
    await requestPermission();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      isLoading = true;
    });

    File imageFile = File(pickedFile.path);
    String apiKey = 'de8b60254a69fe8b9be4141dd2e99e88';

    var request = http.MultipartRequest(
        'POST', Uri.parse('https://api.imgbb.com/1/upload?key=$apiKey'));
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var json = jsonDecode(responseData);
      String imageUrl = json['data']['url'];

      try {
        var docRef = await FirebaseFirestore.instance.collection('images').add({
          'userId': widget.userId,
          'imageUrl': imageUrl,
          'timestamp': FieldValue.serverTimestamp(), // Firestore timestamp
        });

        print("✅ Firestore Document Created: ${docRef.id}");

        setState(() {
          isLoading = false;
        });
      } catch (e) {
        print("❌ Firestore Write Failed: $e");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print('❌ Image Upload Failed');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteImage(String docId) async {
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Image"),
        content: const Text("Are you sure you want to delete this image?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      await FirebaseFirestore.instance.collection('images').doc(docId).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Image", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.cyan,
          actions: [
            IconButton(
              onPressed: uploadToImgBB,
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
        ),
        body: Column(children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('images')
                .where('userId', isEqualTo: widget.userId)
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No images uploaded yet."));
              }

              var imageDocs = snapshot.data!.docs;

              return ListView.builder(
                itemCount: imageDocs.length,
                itemBuilder: (context, index) {
                  var imageData =
                      imageDocs[index].data() as Map<String, dynamic>;
                  String? imageUrl = imageData['imageUrl'];
                  String docId = imageDocs[index].id;

                  // 🔴 Fix: Ensure Firestore timestamp exists before displaying
                  if (imageUrl == null ||
                      imageUrl.isEmpty ||
                      imageData['timestamp'] == null) {
                    return const SizedBox.shrink();
                  }

                  return GestureDetector(
                    onLongPress: () => deleteImage(docId),
                    child: Card(
                      child: Image.network(
                        imageUrl,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                              child: Text("Image failed to load"));
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ))
        ]));
  }
}
