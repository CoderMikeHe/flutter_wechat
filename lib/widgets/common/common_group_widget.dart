import 'package:flutter/material.dart';

import 'package:flutter_wechat/utils/util.dart';

import 'package:flutter_wechat/model/common/common_group.dart';
import 'package:flutter_wechat/model/common/common_item.dart';
import 'package:flutter_wechat/model/common/common_header.dart';
import 'package:flutter_wechat/model/common/common_footer.dart';

import 'package:flutter_wechat/widgets/common/common_header_widget.dart';
import 'package:flutter_wechat/widgets/common/common_item_widget.dart';
import 'package:flutter_wechat/widgets/common/common_footer_widget.dart';

// hearder + items + footer

class CommonGroupWidget extends StatefulWidget {
  CommonGroupWidget({Key key, this.group}) : super(key: key);
  final CommonGroup group;
  _CommonGroupWidgetState createState() => _CommonGroupWidgetState();
}

class _CommonGroupWidgetState extends State<CommonGroupWidget> {
  // 生成身体小部件
  Widget _itemBuilder(List items) {
    // 装饰容器
    final boxDecoration = BoxDecoration(
      color: Colors.white,
      border: Border(
        top: BorderSide(color: Color(0xFFD8D8D8), width: 0.5),
        bottom: BorderSide(color: Color(0xFFD8D8D8), width: 0.5),
      ),
    );

    final int count = items.length;
    var children = <Widget>[];
    for (var i = 0; i < count; i++) {
      final CommonItem item = items[i];
      bool offstageIcon = Util.isEmptyString(item.icon);
      double indent = offstageIcon ? 16.0 : 16.0 + 30 + 16.0;

      Widget child = CommonItemWidget(
        item: item,
      );

      // 添加一条分割线
      if (i != 0 && count > 1) {
        children.add(Divider(
          height: 0.5,
          color: Color(0xFFD8D8D8),
          indent: indent,
        ));
      }

      children.add(child);
    }
    // 数据
    return Container(
      decoration: boxDecoration,
      child: Column(
        children: children,
      ),
    );
  }

  // 生成头部小部件
  Widget _headerBuilder(CommonHeader header) {
    return null == header
        ? SizedBox(
            width: double.maxFinite,
            height: widget.group.headerHeight,
          )
        : CommonHeaderWidget(
            header: header,
          );
  }

  // 生成尾部小部件
  Widget _footerBuilder(CommonFooter footer) {
    return null == footer
        ? SizedBox(
            width: double.maxFinite,
            height: widget.group.footerHeight,
          )
        : CommonFooterWidget(
            footer: footer,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // 组头
        _headerBuilder(widget.group.header),
        // 身体
        _itemBuilder(widget.group.items),
        // 组尾
        _footerBuilder(widget.group.footer),
      ],
    );
  }
}
