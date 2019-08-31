import 'package:flutter_wechat/model/common/common_item.dart';
import 'package:flutter_wechat/model/common/common_header.dart';
import 'package:flutter_wechat/model/common/common_footer.dart';

class CommonGroup {
  /// 构造函数
  CommonGroup({
    this.header,
    this.headerHeight = 0.0,
    this.footer,
    this.footerHeight = 8.0,
    this.items = const <CommonItem>[],
  });

  /// 组头
  final CommonHeader header;

  /// 组头高度 只有 header == null 生效，主要用来做分割线 default is 0.0
  final double headerHeight;

  /// 组尾
  final CommonFooter footer;

  /// 组尾高度 只有 footer == null 生效，主要用来做分割线 default is 8.0
  final double footerHeight;

  /// items
  final List<CommonItem> items;
}
