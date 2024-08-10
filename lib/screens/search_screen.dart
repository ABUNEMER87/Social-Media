import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:social_media/colors/app_color.dart';
import 'package:social_media/screens/profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  final searchSubject = PublishSubject<String>();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      searchSubject.add(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Find Users ...'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchBar(
              controller: searchController,
              hintText: 'Search by user name ....',
              trailing: [
                Icon(
                  Icons.search,
                  color: kPrimaryColor,
                ),
              ],
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.white),
              elevation: MaterialStateProperty.resolveWith((states) => 0),
              shape: MaterialStateProperty.resolveWith((states) =>
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: kPrimaryColor.withOpacity(0.5)))),
            ),
            Expanded(
              child: StreamBuilder<String>(
                stream: searchSubject
                    .debounceTime(const Duration(milliseconds: 300)),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Start typing to search for users...'),
                    );
                  }
                  return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .where('userName', isEqualTo: snapshot.data!)
                        .get(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> searchSnapshot) {
                      if (searchSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (searchSnapshot.hasError) {
                        return const Center(
                          child: Text('An error occurred.'),
                        );
                      } else if (!searchSnapshot.hasData ||
                          searchSnapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text('No users found.'),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: searchSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            dynamic item = searchSnapshot.data!.docs[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileScreen(uid: item['uid']),
                                    ));
                              },
                              child: ListTile(
                                leading: item['profilePic'] == ""
                                    ? const CircleAvatar(
                                        backgroundImage:
                                            AssetImage('assets/images/man.png'),
                                      )
                                    : CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(item['profilePic']),
                                      ),
                                title: Text(item['displayName']),
                                subtitle: Text('@' + item['userName']),
                              ),
                            );
                          },
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
