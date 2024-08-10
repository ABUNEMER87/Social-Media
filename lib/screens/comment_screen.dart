import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:social_media/Model/user.dart';
import 'package:social_media/Providers/user_provider.dart';
import 'package:social_media/colors/app_color.dart';
import 'package:social_media/services/cloud.dart';

class CommentScreen extends StatefulWidget {
  final postId;
  const CommentScreen({super.key, required this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController commentController = TextEditingController();
  postComment(String uid, String commentText, String profilePic,
      String displayName, String userName) async {
    String response = await CloudMethods().commentToPost(
      postId: widget.postId,
      uid: uid,
      commentText: commentController.text,
      profilePic: profilePic,
      displayName: displayName,
      userName: userName,
    );

    if (response == 'Success') {
      setState(() {
        commentController.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel userData = Provider.of<UserProvider>(context).userModel!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('post')
                      .doc(widget.postId)
                      .collection('comments')
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        dynamic data = snapshot.data.docs[index];
                        return Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: kWhiteColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                        backgroundImage:
                                            data['profilePic'] == null
                                                ? const AssetImage(
                                                    'assets/images/man.png')
                                                : NetworkImage(
                                                        UserModel.fromSnap(data)
                                                            .profilePic)
                                                    as ImageProvider),
                                    const Gap(10),
                                    Text(data['displayName']),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(data['commentText']),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
            const Gap(10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(99)),
                    child: TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          border: InputBorder.none,
                          hintText: 'Type Your Comment here ...'),
                    ),
                  ),
                ),
                const Gap(10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      shape: const CircleBorder(),
                      backgroundColor: Colors.grey.withOpacity(0.5),
                      foregroundColor: Colors.white),
                  onPressed: () {
                    postComment(
                      userData.uid,
                      commentController.text,
                      userData.profilePic,
                      userData.displayName,
                      userData.userName,
                    );
                  },
                  child: const Icon(Icons.refresh),
                ),
              ],
            ),
            const Gap(10),
          ],
        ),
      ),
    );
  }
}
