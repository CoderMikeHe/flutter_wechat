import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'
    as FlutterScreenUtil;

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';

class MomentsProfileWidget extends StatefulWidget {
  MomentsProfileWidget({Key key}) : super(key: key);

  _MomentsProfileWidgetState createState() => _MomentsProfileWidgetState();
}

class _MomentsProfileWidgetState extends State<MomentsProfileWidget> {
  /// 未读数
  int _unread = 10;

  /// ✨✨✨✨✨✨✨ Override ✨✨✨✨✨✨✨
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          _buildContentWidget(),
          Positioned(
            right: 20,
            top: FlutterScreenUtil.ScreenUtil.screenWidthDp,
            child: Container(
              width: 40,
              height: 40,
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }

  /// ✨✨✨✨✨✨✨ UI ✨✨✨✨✨✨✨
  Widget _buildContentWidget() {
    final List<Widget> children = [];

    // 封面 // 高度=屏幕宽度
    final Widget cover = Image.asset(
      Constant.assetsImagesMoments + 'kris_wu.png',
      fit: BoxFit.contain,
    );

    children.add(cover);

    // 高度为 126/3 空盒子
    final Widget tempBox126 = SizedBox(
      height: FlutterScreenUtil.ScreenUtil().setHeight(126),
    );

    children.add(tempBox126);

    // 有未读数 显示
    if (_unread > 0) {
      // 高度为27的空盒子
      final Widget tempBox27 = SizedBox(
        height: FlutterScreenUtil.ScreenUtil().setHeight(27),
      );

      children.add(tempBox27);

      // 消息提示
      final Widget messageTips = Container(
        padding: EdgeInsets.symmetric(
          vertical: FlutterScreenUtil.ScreenUtil().setHeight(45),
        ),
        child: Row(
          children: <Widget>[
            // 头像
            CachedNetworkImage(
              imageUrl:
                  'https://game.gtimg.cn/images/yxzj/img201606/heroimg/121/121.jpg',
              width: FlutterScreenUtil.ScreenUtil().setWidth(90.0),
              height: FlutterScreenUtil.ScreenUtil().setWidth(90.0),
            ),

            // 提示
            Expanded(
              child: Text(
                '$_unread条新消息',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: FlutterScreenUtil.ScreenUtil().setSp(42.0),
                ),
              ),
            ),

            // 右箭头
            Image.asset(
              Constant.assetsImagesMoments + 'AlbumTimeLineTipArrow_15x15.png',
              width: FlutterScreenUtil.ScreenUtil().setWidth(15.0 * 3.0),
              height: FlutterScreenUtil.ScreenUtil().setWidth(15.0 * 3.0),
            )
          ],
        ),
      );

      children.add(messageTips);
    }
    return Column(
      children: children,
    );
  }
}
