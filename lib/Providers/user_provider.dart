import 'package:flutter/material.dart';
import 'package:social_media/Model/user.dart';
import 'package:social_media/services/auth.dart';

class UserProvider with ChangeNotifier {
  UserModel? userModel;
  bool isLoad = true;

  UserProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    // Use a post-frame callback to ensure build phase completion before state update
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getDetails();
    });
  }

  Future<void> getDetails() async {
    if (userModel == null) {
      userModel = await AuthMethods().getUsersDetails();
      isLoad = false;
      notifyListeners();
    }
  }
}
