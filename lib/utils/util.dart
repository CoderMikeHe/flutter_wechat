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
  static bool pureDigitCharacters(String input) {
    final String regex = "^[0-9]*\$";
    return matches(regex, input);
  }

  // 🔥是否为正确的QQ号码、微信号、QQ邮箱
  // - [微信号正则校验，qq正则，邮箱正则,英文名正则](https://blog.csdn.net/qq_29091239/article/details/80075981)
  // - [微信号正则校验](https://blog.csdn.net/unknowna/article/details/50524529)
  static bool validQQ(String input) {
    final String regex = '^[1-9][0-9]{4,9}\$';
    return matches(regex, input);
  }

  static bool validWeChatId(String input) {
    final String regex = '^[a-zA-Z]{1}[-_a-zA-Z0-9]{5,19}\$';
    return matches(regex, input);
  }

  static bool validQQMail(String input) {
    final String regex = '^[1-9][0-9]{4,9}@qq\.com\$';
    return matches(regex, input);
  }

  /// 匹配
  static bool matches(String regex, String input) {
    if (input == null || input.isEmpty) return false;
    return new RegExp(regex).hasMatch(input);
  }
}
