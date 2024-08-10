import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:social_media/Model/user.dart';
import 'package:social_media/Providers/user_provider.dart';
import 'package:social_media/Utilities/picker.dart';
import 'package:social_media/services/cloud.dart';
import '../colors/app_color.dart';

class EditUserScreen extends StatefulWidget {
  final VoidCallback onProfileUpdated;

  const EditUserScreen({super.key, required this.onProfileUpdated});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  Uint8List? file;
  late TextEditingController updateDisplaynameController;
  late TextEditingController updateNewNameController;
  late TextEditingController updateBioController;

  @override
  void initState() {
    super.initState();
    UserModel? userData =
        Provider.of<UserProvider>(context, listen: false).userModel;
    updateDisplaynameController =
        TextEditingController(text: userData?.displayName);
    updateNewNameController = TextEditingController(text: userData?.userName);
    updateBioController = TextEditingController(text: userData?.bio);
  }

  @override
  void dispose() {
    updateDisplaynameController.dispose();
    updateNewNameController.dispose();
    updateBioController.dispose();
    super.dispose();
  }

  Future<void> updateProfile() async {
    UserModel? userData =
        Provider.of<UserProvider>(context, listen: false).userModel;
    if (userData == null) return;
    try {
      String response = await CloudMethods().updateProfile(
        uid: userData.uid,
        displayName: updateDisplaynameController.text,
        userName: updateNewNameController.text,
        file: file,
        bio: updateBioController.text,
      );
      if (response == 'Success') {
        widget.onProfileUpdated();
        Navigator.pop(context);
      }
    } catch (e) {
      // TODO: Add proper error handling
    }
    Provider.of<UserProvider>(context, listen: false).getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Gap(20),
              Center(
                child: Stack(
                  children: [
                    file == null
                        ? const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/man.png'),
                            radius: 65,
                          )
                        : CircleAvatar(
                            radius: 65,
                            backgroundImage: MemoryImage(file!),
                          ),
                    Positioned(
                      bottom: -5,
                      right: -2,
                      child: IconButton(
                        onPressed: () async {
                          Uint8List? pickedFile = await pickImage();
                          if (pickedFile != null) {
                            setState(() {
                              file = pickedFile;
                            });
                          }
                        },
                        icon: const Icon(Icons.edit),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(40),
              TextField(
                controller: updateDisplaynameController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kSocunderyColor,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  labelText: 'Display Name  ',
                  hintText: 'User',
                  prefixIcon: const Icon(LineIcons.user),
                ),
              ),
              const Gap(20),
              TextField(
                controller: updateNewNameController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kSocunderyColor,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  labelText: 'User Name  ',
                  hintText: 'New Name',
                  prefixIcon: const Icon(LineIcons.at),
                ),
              ),
              const Gap(20),
              TextField(
                controller: updateBioController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kSocunderyColor,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  labelText: 'Bio  ',
                  hintText: 'bio',
                  prefixIcon: const Icon(LineIcons.infoCircle),
                ),
              ),
              const Gap(30),
              Row(
                children: [
                  Expanded(
                    child: FloatingActionButton(
                      backgroundColor: kPrimaryColor,
                      foregroundColor: kWhiteColor,
                      onPressed: () {
                        updateProfile();
                      },
                      child: const Text(
                        'Update',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
