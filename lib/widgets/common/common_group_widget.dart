import 'package:flutter/material.dart';

import 'package:flutter_wechat/utils/util.dart';

import 'package:flutter_wechat/model/common/common_group.dart';
import 'package:flutter_wechat/model/common/common_item.dart';

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
  // 生成身体元素
  Widget _itemBuilder(List items) {
    // 装饰容器
    var boxDecoration = BoxDecoration(
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

  @override
  Widget build(BuildContext context) {
    return Column(
      // 组头

      // 身体
      // 组尾
      children: <Widget>[
        SizedBox(
          height: 0.0,
        ),
        _itemBuilder(widget.group.items),
        SizedBox(
          height: 8.0,
        ),
      ],
    );
  }
}
