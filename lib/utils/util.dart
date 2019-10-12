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

  // 🔥格式化手机号为344
  static String formatMobile344(String mobile) {
    if (isEmptyString(mobile)) return '';
    mobile = mobile?.replaceAllMapped(new RegExp(r"(^\d{3}|\d{4}\B)"),
        (Match match) {
      return '${match.group(0)} ';
    });
    if (mobile != null && mobile.endsWith(' ')) {
      mobile = mobile.substring(0, mobile.length - 1);
    }
    return mobile;
  }

  /// 纯数字 ^[0-9]*$
  static bool pureDigitCharacters(str) {
    final String regex = "^[0-9]*\$";
    return matches(regex, str);
  }

  /// 匹配
  static bool matches(String regex, String input) {
    if (input == null || input.isEmpty) return false;
    return new RegExp(regex).hasMatch(input);
  }
}
