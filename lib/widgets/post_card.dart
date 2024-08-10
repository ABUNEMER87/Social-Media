import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:social_media/Model/user.dart';
import 'package:social_media/Providers/user_provider.dart';
import 'package:social_media/colors/app_color.dart';
import 'package:social_media/screens/comment_screen.dart';
import 'package:social_media/services/cloud.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> data;

  const PostCard({super.key, required this.data});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late int likeCount;
  late int commentCount;

  @override
  void initState() {
    super.initState();
    likeCount = widget.data['likesCount'] ?? 0;
    commentCount = widget.data['commentsCount'] ?? 0;
    getCommentCount();
  }

  Future<void> getCommentCount() async {
    try {
      QuerySnapshot commentSnapshot = await FirebaseFirestore.instance
          .collection('post')
          .doc(widget.data['postId'])
          .collection('comments')
          .get();
      setState(() {
        commentCount = commentSnapshot.docs.length;
      });
    } catch (e) {
      print('Error fetching comment count: $e');
    }
  }

  void toggleLike(UserModel userData) async {
    try {
      await CloudMethods()
          .likePost(widget.data['postId'], userData.uid, widget.data['like']);
      setState(() {
        if (widget.data['like'].contains(userData.uid)) {
          widget.data['like'].remove(userData.uid);
        } else {
          widget.data['like'].add(userData.uid);
        }
        likeCount = widget.data['like'].length;
      });
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel userData = Provider.of<UserProvider>(context).userModel!;
    var post = widget.data;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: kWhiteColor,
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                post['profilePic'] == null || post['profilePic'] == ""
                    ? const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/man.png'),
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(post['profilePic']),
                      ),
                const Gap(8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['displayName'] ?? 'No Display Name',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('@' + (post['userName'] ?? 'No Username')),
                  ],
                ),
                const Spacer(),
                Text(
                  DateFormat('E - d').format(
                    (post['date'] as Timestamp).toDate(),
                  ),
                ),
              ],
            ),
            const Gap(12),
            if (post['postImage'] != null && post['postImage'] != "")
              Container(
                height: 300,
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(post['postImage']),
                  ),
                ),
              ),
            const Gap(12),
            Text(
              post['description'] ?? 'No Description',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const Gap(12),
            Row(
              children: [
                IconButton(
                  onPressed: () => toggleLike(userData),
                  icon: widget.data['like'].contains(userData.uid)
                      ? const Icon(LineIcons.heart, color: Colors.red)
                      : const Icon(LineIcons.heart),
                ),
                const Gap(10),
                Text('$likeCount'),
                const Gap(20),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CommentScreen(postId: widget.data['postId']),
                      ),
                    ).then((_) => getCommentCount());
                  },
                  icon: const Icon(LineIcons.comment),
                ),
                const Gap(10),
                Text('$commentCount'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
