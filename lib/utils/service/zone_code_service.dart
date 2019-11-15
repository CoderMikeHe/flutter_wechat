import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:azlistview/azlistview.dart';
import 'package:lpinyin/lpinyin.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/model/zone_code/zone_code.dart';

// 处理全球地区手机区号编码的逻辑
class ZoneCodeService {
  // 如果一个函数的构造方法并不总是返回一个新的对象的时候，可以使用factory，
  // 比如从缓存中获取一个实例并返回或者返回一个子类型的实例

  // 工厂方法构造函数
  factory ZoneCodeService() => _getInstance();

  // instance的getter方法，通过ZoneCodeService.instance获取对象
  static ZoneCodeService get sharedInstance => _getInstance();

  // 静态变量_instance，存储唯一对象
  static ZoneCodeService _instance;

  // 私有的命名式构造方法，通过它可以实现一个类可以有多个构造函数，
  // 子类不能继承internal不是关键字，可定义其他名字
  ZoneCodeService._internal() {
    // 异步初始化
    _initAsync();
    // 同步初始化
    _init();
  }

  // 获取对象
  static ZoneCodeService _getInstance() {
    if (_instance == null) {
      // 使用私有的构造方法来创建对象
      _instance = new ZoneCodeService._internal();
    }
    return _instance;
  }

  /// 异步初始化
  Future _initAsync() async {
    // 请求数据
    fetchZoneCode();
  }

  // 获取联系人列表
  Future fetchZoneCode() async {
    // 先清除掉数据
    _zoneCodeList.clear();
    _zoneCodeMap.clear();

    // 获取用户信息列表
    final jsonStr =
        await rootBundle.loadString(Constant.mockData + 'world_zone_code.json');

    // zoneCodeJson
    final List zoneCodeJson = json.decode(jsonStr);

    // 遍历
    zoneCodeJson.forEach((json) {
      final ZoneCode zoneCode = ZoneCode.fromJson(json);
      _zoneCodeList.add(zoneCode);
      _zoneCodeMap[zoneCode.tel] = zoneCode;
    });

    for (int i = 0, length = _zoneCodeList.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(_zoneCodeList[i].name);
      String tag = pinyin.substring(0, 1).toUpperCase();
      _zoneCodeList[i].namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        _zoneCodeList[i].tagIndex = tag;
      } else {
        _zoneCodeList[i].tagIndex = "#";
      }
    }
    // 根据A-Z排序
    SuspensionUtil.sortListBySuspensionTag(_zoneCodeList);

    // 返回数据
    return _zoneCodeList;
  }

  /// 同步初始化
  void _init() {}

  /// 通讯录列表
  List<ZoneCode> _zoneCodeList = List();

  /// 通讯录Map
  Map<String, ZoneCode> _zoneCodeMap = Map();
  List<ZoneCode> get zoneCodeList => _zoneCodeList;
  Map<String, ZoneCode> get zoneCodeMap => _zoneCodeMap;
}
