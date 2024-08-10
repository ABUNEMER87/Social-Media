import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String? email;
  String displayName;
  String userName;
  String? bio;
  String profilePic;
  List? followers;
  List? follwing;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.userName,
    required this.bio,
    required this.profilePic,
    required this.followers,
    required this.follwing,
  });

  factory UserModel.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      uid: snapshot['uid'],
      email: snapshot['email'],
      displayName: snapshot['displayName'],
      userName: snapshot['userName'],
      bio: snapshot['bio'],
      profilePic: snapshot['profilePic'],
      followers: snapshot['followers'],
      follwing: snapshot['follwing'],
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'userName': userName,
        'bio': bio,
        'profilePic': profilePic,
        'followers': followers,
        'follwing': follwing,
      };
}
