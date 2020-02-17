import 'package:flutter/material.dart';

/// 用于控制TabBar 的显示和隐藏
class TabBarProvider with ChangeNotifier {
  // 显示or隐藏
  bool _hidden = false;
  bool get hidden => _hidden;

  void setHidden(bool hidden) {
    _hidden = hidden;
    notifyListeners();
  }
}
