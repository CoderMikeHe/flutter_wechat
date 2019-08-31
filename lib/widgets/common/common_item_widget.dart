import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' as prefix0;
import 'package:flutter/material.dart';

import 'package:flutter_wechat/utils/util.dart';
import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';

import 'package:flutter_wechat/model/common/common_item.dart';

// 最常用的 cell
class CommonItemWidget extends StatefulWidget {
  const CommonItemWidget({Key key, this.item}) : super(key: key);
  // item
  final CommonItem item;

  _CommonItemWidgetState createState() => _CommonItemWidgetState();
}

class _CommonItemWidgetState extends State<CommonItemWidget> {
  /// 是否允许点击高亮
  bool _highlight = false;

  /// 开关控件 状态
  bool _lights = false;

  /// 构建child
  Widget _buildChildWidget() {
    // 取出item
    final item = widget.item;

    /// child
    Widget child;
    // Fixed Bug: is判断类型， 父类和子类的场景，应该先判断子类，再去判断父类，反之，则永远走判断父类的方法
    // 错误案例👇 永远只打印 '父类'
    // if (item is CommonItem) {
    //   print('父类');
    // } else if (item is CommonCenterItem) {
    //   print('子类');
    // }

    // 方案一：
    // print('${item.runtimeType == CommonCenterItem}   yyy ${item.title}');

    // 方案二 先子后父
    if (item is CommonCenterItem) {
      child = _buildCenterItem(item);
    } else if (item is CommonSwitchItem) {
      child = _buildSwitchItem(item);
    } else if (item is CommonRadioItem) {
      child = _buildRadioItem(item);
    } else if (item is CommonPluginItem) {
      child = _buildPluginItem(item);
    } else if (item is CommonTextItem) {
      child = _buildTextItem(item);
    } else if (item is CommonSecurityPhoneItem) {
      child = _buildSecurityPhonetem(item);
    } else if (item is CommonItem) {
      child = _buildItem(item);
    }

    return Container(
      padding: EdgeInsets.all(Constant.pEdgeInset),
      child: child,
    );
  }

  @override
  void initState() {
    super.initState();

    // 这里设置数据
    if (widget.item is CommonSwitchItem) {
      (widget.item as CommonSwitchItem).getOn().then((bool off) {
        setState(() {
          _lights = off;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final CommonItem item = widget.item;
    return GestureDetector(
      onTapDown: item.tapHighlight
          ? _handleTapDown
          : null, // Handle the tap events in the order that
      onTapUp: item.tapHighlight
          ? _handleTapUp
          : null, // they occur: down, up, tap, cancel
      onTap: _handleTap,
      onTapCancel: item.tapHighlight ? _handleTapCancel : null,
      child: Container(
        color: _highlight ? Color(0xFFE5E5E5) : Color(0xFFFFFFFF),
        child: _buildChildWidget(),
      ),
    );
  }

  /// 点击状态事件 they occur: down, up, tap, cancel
  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _highlight = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _highlight = false;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _highlight = false;
    });
  }

  /// 点击事件
  void _handleTap() {
    // 事件回调
    if (widget.item.onTap != null && widget.item.onTap is Function) {
      widget.item.onTap(widget.item);
    }
  }

  /// 返回 item
  Widget _buildItem(CommonItem item) {
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
        padding: EdgeInsets.only(right: Constant.pEdgeInset),
        child: Text(
          item.title,
          style: TextStyle(fontSize: 17.0),
        ),
      ),
    );

    Widget subtitleWidget = Offstage(
      offstage: Util.isEmptyString(item.subtitle),
      child: Padding(
        padding: EdgeInsets.only(right: 10.0),
        child: Text(
          item.subtitle,
          style: TextStyle(fontSize: 17.0, color: Color(0xFF7F7F7F)),
        ),
      ),
    );

    Widget arrowWidget = Image.asset(
      'assets/images/tableview_arrow_8x13.png',
      width: 8.0,
      height: 13.0,
    );

    return Row(
      children: [iconWidget, titleWidget, subtitleWidget, arrowWidget],
    );
  }

  /// 返回 text item
  Widget _buildTextItem(CommonTextItem item) {
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
        padding: EdgeInsets.only(right: Constant.pEdgeInset),
        child: Text(
          item.title,
          style: TextStyle(fontSize: 17.0),
        ),
      ),
    );

    Widget subtitleWidget = Offstage(
      offstage: Util.isEmptyString(item.subtitle),
      child: Padding(
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          item.subtitle,
          style: TextStyle(fontSize: 17.0, color: Color(0xFF7F7F7F)),
        ),
      ),
    );

    return Row(
      children: [iconWidget, titleWidget, subtitleWidget],
    );
  }

  /// 返回 item
  Widget _buildSecurityPhonetem(CommonSecurityPhoneItem item) {
    Widget titleWidget = Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: Constant.pEdgeInset),
        child: Text(
          item.title,
          style: TextStyle(fontSize: 17.0),
        ),
      ),
    );

    Widget subtitleWidget = Offstage(
      offstage: Util.isEmptyString(item.subtitle),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Text(
          item.subtitle,
          style: TextStyle(fontSize: 17.0, color: Color(0xFF7F7F7F)),
        ),
      ),
    );

    Widget lockWidget = Image.asset(
      'assets/images/' +
          (item.binded
              ? 'ProfileLockOn_17x17.png'
              : 'ProfileLockOff_17x17.png'),
      width: 17.0,
      height: 17.0,
    );

    Widget rowWidget = Row(
      children: <Widget>[lockWidget, subtitleWidget],
    );

    Widget arrowWidget = Image.asset(
      'assets/images/tableview_arrow_8x13.png',
      width: 8.0,
      height: 13.0,
    );

    return Row(
      children: [titleWidget, rowWidget, arrowWidget],
    );
  }

  /// 返回 plugin item
  Widget _buildPluginItem(CommonPluginItem item) {
    Widget titleWidget = Padding(
      padding: EdgeInsets.only(right: Constant.pEdgeInset),
      child: Text(
        item.title,
        style: TextStyle(fontSize: 17.0),
      ),
    );

    Widget iconWidget = Expanded(
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(right: 16.0),
        // Fixed Bug: 这里icon 没值就别去渲染了,直接为null,否则报错
        child: Image.asset(
          'assets/images/WeChat_Lab_Logo_small_15x17.png',
          width: 15.0,
          height: 17.0,
        ),
      ),
    );

    Widget subtitleWidget = Offstage(
      offstage: Util.isEmptyString(item.subtitle),
      child: Padding(
        padding: EdgeInsets.only(right: 10.0),
        child: Text(
          item.subtitle,
          style: TextStyle(fontSize: 17.0, color: Color(0xFF7F7F7F)),
        ),
      ),
    );

    Widget arrowWidget = Image.asset(
      'assets/images/tableview_arrow_8x13.png',
      width: 8.0,
      height: 13.0,
    );

    return Row(
      children: [titleWidget, iconWidget, subtitleWidget, arrowWidget],
    );
  }

  /// 返回 center item
  Widget _buildCenterItem(CommonItem item) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            item.title,
            style: TextStyle(fontSize: 17.0),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  /// 返回 switch item
  Widget _buildSwitchItem(CommonSwitchItem item) {
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

    Widget switchWidget = CupertinoSwitch(
      value: _lights,
      activeColor: Color(0xFF57be6a),
      onChanged: (bool value) {
        // 设置数据
        item.setOn(value);
        // 更新UI
        setState(() {
          _lights = value;
        });
      },
    );
    return Row(
      children: <Widget>[iconWidget, titleWidget, switchWidget],
    );
  }

  /// 返回 单选 item
  Widget _buildRadioItem(CommonRadioItem item) {
    // title 小部件
    Widget titleWidget = Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 16.0),
        child: Text(
          item.title,
          style: TextStyle(fontSize: 17.0),
        ),
      ),
    );

    // 选中图标小部件
    bool offstageIcon = !item.value;
    Widget iconWidget = Offstage(
      offstage: offstageIcon,
      child: Padding(
        padding: EdgeInsets.only(right: 16.0),
        child: offstageIcon
            ? null
            : Image.asset(
                'assets/images/icon_selected_20x20.png',
                width: 20.0,
                height: 20.0,
              ),
      ),
    );

    return Row(
      children: <Widget>[
        titleWidget,
        iconWidget,
      ],
    );
  }
}
