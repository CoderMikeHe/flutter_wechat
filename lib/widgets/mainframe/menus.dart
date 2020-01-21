import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:flutter_wechat/constant/style.dart';
import 'package:flutter_wechat/constant/constant.dart';

class Menus extends StatefulWidget {
  Menus({Key key, this.show = false}) : super(key: key);

  final bool show;

  _MenusState createState() => _MenusState();
}

class _MenusState extends State<Menus> with SingleTickerProviderStateMixin {
  // 那个高亮的索引
  int _selectedIndex = -1;

  // 当前是否显示
  bool _isLoad = false;
  // 是否动画完成
  bool _isCompleted = true;

  // 动画控制器
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 200));

    _controller.addStatusListener((AnimationStatus status) {
      print('kkkk----object $status ');
      if (status == AnimationStatus.completed) {
        // 正向结束, 重置到当前
        _controller.reset();
        _isCompleted = true;
        setState(() {});
      }
    });

    print('iniTSate 。。。');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
        'object ------- ${widget.show} hhh--- ${_controller.isAnimating}  ${_controller.isCompleted}  ${_controller.isDismissed}');

    if (!_controller.isAnimating) {
      // if (!_controller.isCompleted && !widget.show && _isLoad) {
      //   // 1.0 -> 0.0
      //   _controller.forward();
      //   _isCompleted = false;
      // }
    }

    _isLoad = true;

    return Offstage(
      offstage: !widget.show,
      child: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.transparent,
        child: AnimatedOpacity(
          opacity: widget.show ? 1.0 : 0.0,
          duration: Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                right: 16,
                child: Image.asset(
                  Constant.assetsImagesMainframe + 'menu_up_arrow.png',
                  width: ScreenUtil().setWidth(45.0),
                  height: ScreenUtil().setHeight(15.0),
                ),
              ),
              Positioned(
                top: ScreenUtil().setHeight(15.0),
                right: ScreenUtil().setWidth(30.0),
                width: ScreenUtil().setWidth(480.0),
                child: ScaleTransition(
                  scale: new Tween(begin: 1.0, end: 1.0).animate(_controller),
                  alignment: Alignment.topRight,
                  child: _buildMenuWidget(),
                ),
                // child: _buildMenuWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 构建menu部件
  Widget _buildMenuWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(ScreenUtil().setWidth(18.0)),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF4C4C4C),
        ),
        child: Column(
          children: <Widget>[
            _buildMenuItemWidget(
              icon: Constant.assetsImagesContacts + 'icons_filled_chats.svg',
              name: '发起群聊',
              index: 0,
            ),
            Divider(
              color: Colors.white30,
              height: 1,
              indent: ScreenUtil().setWidth(168.0),
            ),
            _buildMenuItemWidget(
              icon: Constant.assetsImagesContacts +
                  'icons_filled_add-friends.svg',
              name: '添加朋友',
              index: 1,
            ),
            Divider(
              color: Colors.white30,
              height: 1,
              indent: ScreenUtil().setWidth(168.0),
            ),
            _buildMenuItemWidget(
              icon: Constant.assetsImagesDiscover + 'icons_filled_scan.svg',
              name: '扫一扫',
              index: 2,
            ),
            Divider(
              color: Colors.white30,
              height: 1,
              indent: ScreenUtil().setWidth(168.0),
            ),
            _buildMenuItemWidget(
              icon: Constant.assetsImagesMainframe + 'icons_filled_pay.svg',
              name: '收付款',
              index: 3,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建menu子部件
  Widget _buildMenuItemWidget({String icon, String name = '', int index}) {
    return InkWell(
      onTap: () {
        // 回调数据
      },
      onHighlightChanged: (bool highlight) {
        _selectedIndex = highlight ? index : -1;
        setState(() {});
      },
      child: Container(
        constraints: BoxConstraints(minHeight: ScreenUtil().setHeight(168.0)),
        padding: EdgeInsets.only(left: ScreenUtil().setWidth(75.0)),
        color: _selectedIndex == index ? Colors.black26 : Color(0xFF4C4C4C),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new SvgPicture.asset(
              icon,
              width: ScreenUtil().setWidth(60),
              height: ScreenUtil().setWidth(60),
              color: Color(0xFFFFFFFF),
            ),
            SizedBox(width: ScreenUtil().setWidth(30.0)),
            Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(48.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
