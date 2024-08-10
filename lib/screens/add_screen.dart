import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:social_media/Utilities/picker.dart';
import 'package:social_media/colors/app_color.dart';
import 'package:social_media/services/cloud.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController descriptionController = TextEditingController();
  Uint8List? file;
  bool isLoading = false;

  Future<void> uploadPost() async {
    if (file == null || descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please provide an image and a description')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String res = await CloudMethods().uploadPost(
        description: descriptionController.text,
        uid: _auth.currentUser!.uid,
        displayName: _auth.currentUser!.displayName ?? 'Anonymous',
        userName: _auth.currentUser!.displayName ?? 'Anonymous',
        file: file!,
        profilePic: ' ', // Use actual profile picture URL if available
      );

      if (res == 'Success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post uploaded successfully!')),
        );
        // Clear the inputs after successful upload
        setState(() {
          descriptionController.clear();
          file = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $res')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: const Text('Add Post'),
        actions: [
          TextButton(
            onPressed: uploadPost,
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Post'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/man.png'),
                ),
                const Gap(20),
                Expanded(
                  child: TextField(
                    controller: descriptionController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type here...',
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: file == null
                  ? Container()
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: MemoryImage(file!),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
            ),
            const Gap(40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(15),
                backgroundColor: kSocunderyColor,
                shape: const CircleBorder(),
              ),
              onPressed: () async {
                Uint8List myFile = await pickImage();
                setState(() {
                  file = myFile;
                });
              },
              child: Icon(
                Icons.camera_enhance,
                size: 40,
                color: kWhiteColor,
              ),
            ),
            const Gap(80),
          ],
        ),
      ),
    );
  }
}
