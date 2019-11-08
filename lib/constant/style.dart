import 'package:flutter/material.dart';

// 本 app 颜色
class Style {
  /// 主要 Primary 次要 secondary 不重要 minor
  static const Color pTintColor = Color(0xFF07C160);

  /// 次要
  static const Color sTintColor = Color(0xFF06AD56);

  /// 主要 分割线 0xFFD8D8D8
  static const Color pDividerColor = Color.fromRGBO(0, 0, 0, 0.1);

  // ---- 文字相关
  /// 主要 文字颜色
  static const Color pTextColor = Color.fromRGBO(0, 0, 0, 0.9);

  /// 次要 文字颜色
  static const Color sTextColor = Color.fromRGBO(0, 0, 0, 0.5);

  /// 不重要 文字颜色
  static const Color mTextColor = Color.fromRGBO(0, 0, 0, 0.3);

  /// 主要背景色
  static const Color pBackgroundColor = Color(0xFFEDEDED);

  /// 警告色
  static const Color pTextWarnColor = Color(0xFFFA5151);
}
