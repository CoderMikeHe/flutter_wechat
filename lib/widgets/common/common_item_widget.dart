import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    } else if (item is CommonImageItem) {
      child = _buildImageItem(item);
    } else if (item is CommonItem) {
      child = _buildItem(item);
    }
    return ConstrainedBox(
      constraints: BoxConstraints(
        // 宽度尽可能大
        minWidth: double.infinity,
        // 最小高度为56像素
        minHeight: ScreenUtil().setHeight(168.0),
      ),
      child: Container(
        padding: item.padding,
        child: child,
      ),
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

  /// ---------------------------构建Item部件-----------------------------
  /// 返回 item
  Widget _buildItem(CommonItem item) {
    bool offstageIcon = Util.isEmptyString(item.icon);
    Widget iconWidget = Offstage(
      offstage: offstageIcon,
      child: Padding(
        padding: EdgeInsets.only(right: ScreenUtil().setWidth(48.0)),
        // Fixed Bug: 这里icon 没值就别去渲染了,直接为null,否则报错
        child: _buildCommonIconWidget(item.icon, iconColor: item.iconColor),
      ),
    );

    Widget titleWidget = Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: ScreenUtil().setWidth(48.0)),
        child: _buildCommonTextWidget(
          item.title,
          fontSize: ScreenUtil().setSp(51.0),
          textColor: widget.item.titleColor,
        ),
      ),
    );

    Widget subtitleWidget = Offstage(
      offstage: Util.isEmptyString(item.subtitle),
      child: Padding(
        padding: EdgeInsets.only(right: ScreenUtil().setWidth(30.0)),
        child: _buildCommonTextWidget(
          item.subtitle,
          fontSize: ScreenUtil().setSp(51.0),
          textColor: Color(0xFF7F7F7F),
        ),
      ),
    );

    Widget arrowWidget = _buildCommonRightArrowWidget();

    return Row(
        children: [iconWidget, titleWidget, subtitleWidget, arrowWidget]);
  }

  /// 返回 text item
  Widget _buildTextItem(CommonTextItem item) {
    bool offstageIcon = Util.isEmptyString(item.icon);
    Widget iconWidget = Offstage(
      offstage: offstageIcon,
      child: Padding(
        padding: EdgeInsets.only(right: ScreenUtil().setWidth(48.0)),
        // Fixed Bug: 这里icon 没值就别去渲染了,直接为null,否则报错
        child: _buildCommonIconWidget(item.icon, iconColor: item.iconColor),
      ),
    );

    Widget titleWidget = Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: ScreenUtil().setWidth(48.0)),
        child: _buildCommonTextWidget(
          item.title,
          fontSize: ScreenUtil().setSp(51.0),
        ),
      ),
    );

    Widget subtitleWidget = Offstage(
      offstage: Util.isEmptyString(item.subtitle),
      child: Padding(
        padding: EdgeInsets.only(right: 0.0),
        child: _buildCommonTextWidget(
          item.subtitle,
          fontSize: ScreenUtil().setSp(51.0),
          textColor: Color(0xFF7F7F7F),
        ),
      ),
    );

    return Row(children: [iconWidget, titleWidget, subtitleWidget]);
  }

  /// 返回 item
  Widget _buildSecurityPhonetem(CommonSecurityPhoneItem item) {
    Widget titleWidget = Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: ScreenUtil().setWidth(48.0)),
        child: _buildCommonTextWidget(
          item.title,
          fontSize: ScreenUtil().setSp(51.0),
        ),
      ),
    );

    Widget subtitleWidget = Offstage(
      offstage: Util.isEmptyString(item.subtitle),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30.0)),
        child: _buildCommonTextWidget(
          item.subtitle,
          fontSize: ScreenUtil().setSp(51.0),
          textColor: Color(0xFF7F7F7F),
        ),
      ),
    );

    Widget lockWidget = Image.asset(
      Constant.assetsImagesProfile +
          (item.binded
              ? 'ProfileLockOn_17x17.png'
              : 'ProfileLockOff_17x17.png'),
      width: ScreenUtil().setWidth(51.0),
      height: ScreenUtil().setWidth(51.0),
    );

    Widget rowWidget = Row(children: <Widget>[lockWidget, subtitleWidget]);
    // 右箭头
    Widget arrowWidget = _buildCommonRightArrowWidget();

    return Row(children: [titleWidget, rowWidget, arrowWidget]);
  }

  /// 返回 plugin item
  Widget _buildPluginItem(CommonPluginItem item) {
    Widget titleWidget = Padding(
      padding: EdgeInsets.only(right: ScreenUtil().setWidth(48.0)),
      child: _buildCommonTextWidget(
        item.title,
        fontSize: ScreenUtil().setSp(51.0),
      ),
    );

    Widget iconWidget = Expanded(
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(right: ScreenUtil().setWidth(48.0)),
        // Fixed Bug: 这里icon 没值就别去渲染��,直接为null,否则报错
        child: Image.asset(
          Constant.assetsImagesProfile + 'WeChat_Lab_Logo_small_15x17.png',
          width: ScreenUtil().setWidth(45.0),
          height: ScreenUtil().setHeight(51.0),
        ),
      ),
    );

    Widget subtitleWidget = Offstage(
      offstage: Util.isEmptyString(item.subtitle),
      child: Padding(
        padding: EdgeInsets.only(right: ScreenUtil().setWidth(30.0)),
        child: _buildCommonTextWidget(
          item.subtitle,
          fontSize: ScreenUtil().setSp(51.0),
          textColor: Color(0xFF7F7F7F),
        ),
      ),
    );

    Widget arrowWidget = _buildCommonRightArrowWidget();

    return Row(
        children: [titleWidget, iconWidget, subtitleWidget, arrowWidget]);
  }

  /// 返回 center item
  Widget _buildCenterItem(CommonItem item) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _buildCommonTextWidget(
            item.title,
            fontSize: ScreenUtil().setSp(51.0),
            textColor: item.titleColor,
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
        padding: EdgeInsets.only(right: ScreenUtil().setWidth(48.0)),
        // Fixed Bug: 这里icon 没值就别去渲染了,直接为null,否则报错
        child: _buildCommonIconWidget(item.icon, iconColor: item.iconColor),
      ),
    );

    Widget titleWidget = Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: ScreenUtil().setWidth(48.0)),
        child: _buildCommonTextWidget(
          item.title,
          fontSize: ScreenUtil().setSp(51.0),
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
    return Row(children: <Widget>[iconWidget, titleWidget, switchWidget]);
  }

  /// 返回 单选 item
  Widget _buildRadioItem(CommonRadioItem item) {
    // title 小部件
    Widget titleWidget = Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: ScreenUtil().setWidth(48.0)),
        child: _buildCommonTextWidget(
          item.title,
          fontSize: ScreenUtil().setSp(51.0),
        ),
      ),
    );

    // 选中图标小部件
    bool offstageIcon = !item.value;
    Widget iconWidget = Offstage(
      offstage: offstageIcon,
      child: Padding(
        padding: EdgeInsets.only(right: 0.0),
        child: _buildCommonIconWidget(
            Constant.assetsImagesRadio + 'icon_selected_20x20.png',
            width: ScreenUtil().setWidth(60.0),
            height: ScreenUtil().setWidth(60.0)),
      ),
    );

    return Row(children: <Widget>[titleWidget, iconWidget]);
  }

  /// 返回 图片 item
  Widget _buildImageItem(CommonImageItem item) {
    Widget titleWidget = Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: ScreenUtil().setWidth(48.0)),
        child: _buildCommonTextWidget(
          item.title,
          fontSize: ScreenUtil().setSp(51.0),
        ),
      ),
    );

    Widget arrowWidget = _buildCommonRightArrowWidget();

    // 图片
    bool offstageIcon = Util.isEmptyString(item.imageUrl);
    Widget iconWidget = Offstage(
      offstage: offstageIcon,
      child: Padding(
        padding: EdgeInsets.only(right: ScreenUtil().setWidth(30.0)),
        // Fixed Bug: 这里icon 没值就别去渲染了,直接为null,否则报错
        child: _buildCommonIconWidget(
          item.imageUrl,
          width: item.width,
          height: item.height,
        ),
      ),
    );

    return Row(children: [titleWidget, iconWidget, arrowWidget]);
  }

  // ---------------------------------通用小部件-----------------------------------
  /// 构建iconWidget
  Widget _buildCommonIconWidget(
    String url, {
    Color iconColor,
    double width = 24.0,
    double height = 24.0,
  }) {
    // 容错处理
    final isEmpty = Util.isEmptyString(url);
    if (isEmpty) return null;
    // 简单判断图片类型
    // 网络图片 http/https 开头
    // 本地图片(.png/.jpg、.svg)
    final isNetwork = url.startsWith(RegExp(r'^http'));
    Widget iconWidget;
    if (isNetwork) {
      iconWidget = CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, url) {
          return Image.asset(
            Constant.assetsImagesDefault + 'DefaultHead_48x48.png',
            width: width,
            height: height,
          );
        },
        errorWidget: (context, url, error) {
          return Image.asset(
            Constant.assetsImagesDefault + 'DefaultHead_48x48.png',
            width: width,
            height: height,
          );
        },
      );
    } else {
      // 是否是本地svg
      final isSvg = url.endsWith('.svg');
      // judge
      if (isSvg) {
        iconWidget = SvgPicture.asset(
          url,
          width: width,
          height: height,
          color: iconColor,
        );
      } else {
        iconWidget = Image.asset(
          url,
          width: width,
          height: height,
        );
      }
    }
    return iconWidget;
  }

  /// 构建文本部件
  Widget _buildCommonTextWidget(
    String text, {
    double fontSize = 17.0,
    Color textColor = Style.pTextColor,
    TextAlign textAlign = TextAlign.left,
  }) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize, color: textColor),
      textAlign: textAlign,
    );
  }

  /// 构建rightArrowWidget
  Widget _buildCommonRightArrowWidget() {
    return Image.asset(
      Constant.assetsImagesArrow + 'tableview_arrow_8x13.png',
      width: ScreenUtil().setWidth(24.0),
      height: ScreenUtil().setHeight(39.0),
    );
  }
}
// 528
