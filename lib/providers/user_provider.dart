import 'dart:core';

import 'package:dmw/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;
  bool get isLoggedIn => _user != null;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _selectedGender;
  String? get gender => _selectedGender;

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

  void selectedGender(String gender){
    _selectedGender = gender;
    notifyListeners();
  }

  void setIsLoading(bool isLoading){
    _isLoading = isLoading;
    notifyListeners();
  }

  void clear() {
    _selectedGender = null;
    _isLoading = false;
    notifyListeners();
  }
}