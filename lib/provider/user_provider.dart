import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? _username;

  String? get username => _username;

  void setUser(String username) {
    _username = username;
    notifyListeners();
  }

  void clearUser() {
    _username = null;
    notifyListeners();
  }
}
