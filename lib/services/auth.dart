import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media/Model/user.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<UserModel?> getUsersDetails() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot documentSnapshot =
            await users.doc(currentUser.uid).get();
        return UserModel.fromSnap(documentSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting user details: $e');
      return null;
    }
  }

  // Register Users
  Future<String> signUp({
    required String email,
    required String password,
    required String userName,
    required String displayName,
  }) async {
    String response = 'Something went wrong';
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          userName.isNotEmpty &&
          displayName.isNotEmpty) {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        UserModel userModel = UserModel(
          uid: userCredential.user!.uid,
          email: email,
          displayName: displayName,
          userName: userName,
          bio: '',
          profilePic: 'profilePic',
          followers: [],
          follwing: [],
        );
        await users.doc(userCredential.user!.uid).set(userModel.toJson());
        response = 'Success';
      } else {
        response = 'Please fill all fields';
      }
    } on FirebaseAuthException catch (e) {
      response = 'Firebase Auth Error: ${e.message}';
    } catch (e) {
      response = 'Error: ${e.toString()}';
    }
    return response;
  }

  // Sign In
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    String response = 'Something went wrong';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        response = 'Success';
      } else {
        response = 'Please enter your email and password';
      }
    } on FirebaseAuthException catch (e) {
      response = 'Firebase Auth Error: ${e.message}';
    } catch (e) {
      response = 'Error: ${e.toString()}';
    }
    return response;
  }
}
