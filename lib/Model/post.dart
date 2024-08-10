import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String uid;
  String displayName;
  String userName;
  String profilePic;
  String description;
  String postId;
  String postImage;
  DateTime date;
  dynamic like;

  PostModel({
    required this.uid,
    required this.displayName,
    required this.userName,
    required this.profilePic,
    required this.description,
    required this.postId,
    required this.postImage,
    required this.date,
    required this.like,
  });

  factory PostModel.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return PostModel(
      uid: snapshot['uid'],
      displayName: snapshot['displayName'],
      userName: snapshot['userName'],
      profilePic: snapshot['profilePic'],
      description: snapshot['description'],
      postId: snapshot['postId'],
      postImage: snapshot['postImage'],
      date: snapshot['date'],
      like: snapshot['like'],
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'displayName': displayName,
        'userName': userName,
        'profilePic': profilePic,
        'description': description,
        'postId': postId,
        'postImage': postImage,
        'date': date,
        'like': like,
      };
}
