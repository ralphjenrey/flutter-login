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
  int _selectedTileIndex = -1; // Initialize with an invalid index

  int get selectedTileIndex => _selectedTileIndex;

  set selectedTileIndex(int index) {
    _selectedTileIndex = index;
    notifyListeners();
  }
}
