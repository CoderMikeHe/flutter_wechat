import 'package:flutter_wechat/model/common/common_item.dart';

class CommonGroup {
  CommonGroup({
    this.header,
    this.headerHeight = double.minPositive,
    this.footer,
    this.footerHeight = double.minPositive,
    this.items = const <CommonItem>[],
  });
  // 组头
  final String header;
  // 组头高度
  final double headerHeight;
  // 组尾
  final String footer;
  // 组尾高度
  final double footerHeight;
  // items
  final List<CommonItem> items;
}