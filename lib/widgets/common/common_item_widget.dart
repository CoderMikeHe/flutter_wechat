import 'package:flutter/material.dart';

import 'package:flutter_wechat/utils/util.dart';

import 'package:flutter_wechat/model/common/common_item.dart';

class CommonItemWidget extends StatelessWidget {
  const CommonItemWidget({Key key, this.item}) : super(key: key);
  final CommonItem item;
  @override
  Widget build(BuildContext context) {
    bool offstageIcon = Util.isEmptyString(item.icon);

    Widget iconWidget = Offstage(
      offstage: offstageIcon,
      child: Padding(
        padding: EdgeInsets.only(right: 16.0),
        // Fixed Bug: 这里icon 没值就别去渲染了,直接为null,否则报错
        child: offstageIcon
            ? null
            : Image.asset(
                item.icon,
                width: 30.0,
                height: 30.0,
              ),
      ),
    );

    Widget titleWidget = Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 16.0),
        child: Text(
          item.title,
          style: TextStyle(fontSize: 17.0),
        ),
      ),
    );

    Widget arrowWidget = Image.asset(
      'assets/images/tableview_arrow_8x13.png',
      width: 8.0,
      height: 13.0,
    );

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [iconWidget, titleWidget, arrowWidget],
      ),
    );
  }
}
