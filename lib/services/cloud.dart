import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_media/Model/post.dart';
import 'package:social_media/services/storge.dart';
import 'package:uuid/uuid.dart';

class CloudMethods {
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('post');
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<String> uploadPost({
    required String description,
    required String uid,
    required String displayName,
    required String userName,
    required Uint8List file,
    required String profilePic,
  }) async {
    String response = 'Something went wrong';
    try {
      String postImage =
          await StorgeMethods().upLoadImageToStorge(file, 'post', true);
      String postId = const Uuid().v1();
      PostModel postModel = PostModel(
        uid: uid,
        displayName: displayName,
        userName: userName,
        profilePic: profilePic,
        description: description,
        postId: postId,
        postImage: postImage,
        date: DateTime.now(),
        like: [],
      );
      await posts.doc(postId).set(postModel.toJson());
      response = 'Success';
    } catch (e) {
      response = e.toString();
    }
    return response;
  }

  Future<String> updateProfile({
    required String uid,
    required String displayName,
    required String userName,
    Uint8List? file,
    String bio = '',
    String profilePic = '',
  }) async {
    String response = 'Something went wrong';
    try {
      if (file != null) {
        profilePic =
            await StorgeMethods().upLoadImageToStorge(file, 'users', false);
      }
      if (displayName.isNotEmpty && userName.isNotEmpty) {
        await users.doc(uid).update({
          'displayName': displayName,
          'userName': userName,
          'bio': bio,
          'profilePic': profilePic,
        });
        response = 'Success';
      }
    } catch (e) {
      response = e.toString();
    }
    return response;
  }

  Future<String> commentToPost({
    required String postId,
    required String uid,
    required String commentText,
    required String profilePic,
    required String displayName,
    required String userName,
  }) async {
    String response = 'Something went wrong';
    try {
      if (commentText.isNotEmpty) {
        String commentId = const Uuid().v1();
        await posts.doc(postId).collection('comments').doc(commentId).set({
          'postId': postId,
          'uid': uid,
          'commentText': commentText,
          'commentId': commentId,
          'profilePic': profilePic,
          'displayName': displayName,
          'userName': userName,
          'date': DateTime.now(),
        });
        response = 'Success';
      }
    } catch (e) {
      response = e.toString();
    }
    return response;
  }

  Future<void> likePost(String postId, String uid, List<dynamic> like) async {
    try {
      if (like.contains(uid)) {
        await posts.doc(postId).update({
          'like': FieldValue.arrayRemove([uid])
        });
      } else {
        await posts.doc(postId).update({
          'like': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print('Error liking post: $e');
    }
  }
}
