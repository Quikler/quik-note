import 'package:flutter/material.dart';

enum AppBarMode { initial, select }

class AppBarModel extends ChangeNotifier {
  AppBarMode mode = AppBarMode.initial;

  void toggleMode(AppBarMode newMode) {
    mode = newMode;
    notifyListeners();
  }
}
