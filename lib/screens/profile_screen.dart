import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gap/gap.dart';
import 'package:line_icons/line_icons.dart';
import 'package:social_media/screens/authentication/login_screen.dart';
import 'package:social_media/screens/edit_user_screen.dart';
import 'package:social_media/widgets/followers_card.dart';
import 'package:social_media/widgets/post_card.dart';
import '../Providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  String? uid;
  ProfileScreen({super.key, this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  var infoUser = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    widget.uid = widget.uid ?? FirebaseAuth.instance.currentUser!.uid;
    _tabController = TabController(length: 2, vsync: this);
    Provider.of<UserProvider>(context, listen: false).getDetails();
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      var userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      setState(() {
        infoUser = userData.data()!;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle the error by showing a Snackbar or similar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user data: $e')),
      );
    }
  }

  void refreshProfile() {
    Provider.of<UserProvider>(context, listen: false).getDetails();
  }

  Widget _buildTabContent(String uid, String type) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: uid)
          .where('type', isEqualTo: type)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('An error occurred.'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No items found.'));
        } else {
          if (type == 'photo') {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var post =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(post['postImage']),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              },
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var post =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return PostCard(data: post);
              },
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userModel = userProvider.userModel;
    final isUserProviderLoading = userProvider.isLoad;

    if (isUserProviderLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userModel == null) {
      // Handle case where userModel is not available
      return const Scaffold(
        body: Center(child: Text('User data not available.')),
      );
    }

    return isLoading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    // Implement chat functionality
                  },
                  icon: Icon(
                    LineIcons.facebookMessenger,
                    size: 40,
                    color: Colors.amber[900],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditUserScreen(
                          onProfileUpdated: refreshProfile,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(LineIcons.userCog),
                ),
                IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(LineIcons.alternateSignOut),
                ),
              ],
              title: Text.rich(TextSpan(children: [
                TextSpan(
                  text: ' 06',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: '16',
                  style: TextStyle(
                      fontSize: 26,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ])),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundImage: userModel.profilePic.isEmpty
                            ? const AssetImage('assets/images/man.png')
                            : NetworkImage(userModel.profilePic)
                                as ImageProvider,
                      ),
                      const Spacer(),
                      FollowersCard(
                        content: 'Followers',
                        count: userModel.followers!.length,
                      ),
                      const Gap(20),
                      FollowersCard(
                        content: 'Following',
                        count: userModel.follwing!.length,
                      ),
                    ],
                  ),
                  const Gap(20),
                  Row(
                    children: [
                      Text(
                        infoUser['displayName'],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                    ],
                  ),
                  const Gap(10),
                  Text(
                    userModel.userName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const Gap(10),
                  Text(
                    userModel.bio!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const Gap(20),
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.black,
                    tabs: const [
                      Tab(icon: Icon(LineIcons.image)),
                      Tab(icon: Icon(LineIcons.play)),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildTabContent(userModel.uid, 'photo'),
                        _buildTabContent(userModel.uid, 'post'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
