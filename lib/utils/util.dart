import 'package:flutter/material.dart';

class Util {
  // 是否是空字符串
  static bool isEmptyString(String str) {
    if (str == null || str.isEmpty) {
      return true;
    }
    return false;
  }

  // 是否不是空字符串
  static bool isNotEmptyString(String str) {
    if (str != null && str.isNotEmpty) {
      return true;
    }
    return false;
  }
}
