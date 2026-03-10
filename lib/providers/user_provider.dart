import 'package:car_wash/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;
  bool get isLoggedIn => _user != null;

  void updateUser(User updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }

  void login(User loggedInUser) {
    _user = loggedInUser;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}