import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef CommonGestureTapCallback = void Function(CommonItem item);

// 最常用的
class CommonItem {
  /// 构造函数
  CommonItem(
      {this.icon,
      this.title = "",
      this.subtitle = "",
      this.tapHighlight = true,
      this.onTap});

  /// icon
  final String icon;

  /// 主标题 default is ‘’
  final String title;

  /// 次标题 default is '', 这个可以修改
  String subtitle;

  /// 点击高亮 default is true
  final bool tapHighlight;

  /// 点击方法
  final CommonGestureTapCallback onTap;
}

// 插件
class CommonPluginItem extends CommonItem {
  /// 构造函数
  CommonPluginItem({String title}) : super(title: title);
}

class CommonCenterItem extends CommonItem {
  /// 构造函数
  CommonCenterItem({String title}) : super(title: title);
}

/// 没有箭头的item
class CommonTextItem extends CommonItem {
  /// 构造函数
  CommonTextItem({String icon, String title, String subtitle})
      : super(
            icon: icon, title: title, subtitle: subtitle, tapHighlight: false);
}

/// 账号与安全 手机号
class CommonSecurityPhoneItem extends CommonItem {
  /// 构造函数
  CommonSecurityPhoneItem({String title, String subtitle, this.binded = true})
      : super(title: title, subtitle: subtitle);

  /// 是否绑定手机号
  bool binded;
}

class CommonSwitchItem extends CommonItem {
  /// 构造函数
  CommonSwitchItem({String title, String icon, @required this.cacheKey})
      : assert((cacheKey != null && cacheKey.length != 0),
            'You Must Set cacheKey'),
        super(icon: icon, title: title, tapHighlight: false);

  /// 缓存key
  final String cacheKey;

  /// 取值
  Future<bool> getOn() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool value = sp.getBool(cacheKey);
    return null == value ? false : value;
  }

  /// 存值
  void setOn(bool value) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool(cacheKey, value);
  }
}

/// 单选 item
class CommonRadioItem extends CommonItem {
  /// 构造函数
  CommonRadioItem(
      {String title, this.value = false, CommonGestureTapCallback onTap})
      : super(title: title, onTap: onTap);

  /// 是否选中 默认是不选中中
  bool value;
}
