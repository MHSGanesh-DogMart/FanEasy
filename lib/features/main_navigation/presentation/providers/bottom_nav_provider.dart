import 'package:flutter/foundation.dart';

/// Tracks the currently selected tab in the main bottom navigation bar.
class BottomNavProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int value) {
    if (value == _currentIndex) return;
    _currentIndex = value;
    notifyListeners();
  }
}
