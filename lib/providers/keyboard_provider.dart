import 'package:flutter/material.dart';

/// 用于控制Keyboard 高度监听
class KeyboardProvider with ChangeNotifier {
  // 显示or隐藏
  double _keyboardHeight = 0.0;
  double get keyboardHeight => _keyboardHeight;

  void setKeyboardHeight(double h) {
    if (_keyboardHeight != h) {
      print('🔥 键盘高度通知 👉 $h');
      _keyboardHeight = h;
      notifyListeners();
    }
  }
}
