import 'package:flutter/material.dart';

/// Shared bottom-nav tab index so screens outside the tab bar (e.g. tapping
/// a category tile on the Categories tab) can switch MainShell back to Home.
class NavIndexProvider extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void setIndex(int index) {
    if (_index == index) return;
    _index = index;
    notifyListeners();
  }
}
