import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';

import 'package:flutter_wechat/model/user/user.dart';
import 'package:flutter_wechat/model/mainframe/message.dart';

import 'package:flutter_wechat/components/list_tile/mh_list_tile.dart';
import 'package:flutter_wechat/components/search_bar/search_bar.dart';
import 'package:flutter_wechat/widgets/mainframe/avatars.dart';
import 'package:flutter_wechat/widgets/mainframe/bouncy_balls.dart';
import 'package:flutter_wechat/widgets/mainframe/applet.dart';

class MainframePage extends StatefulWidget {
  MainframePage({Key key}) : super(key: key);

  @override
  _MainframePageState createState() => _MainframePageState();
}

class _MainframePageState extends State<MainframePage> {
  /// 数据源
  List<Message> _dataSource = [];

  /// 侧滑controller
  SlidableController _slidableController;

  /// 是否展开
  bool _slideIsOpen = false;

  /// 滚动
  ScrollController _controller = new ScrollController();

  // 偏移量
  double _offset = 0.0;

  // 焦点状态
  bool _focusState = false;
  set _focus(bool focus) {
    _focusState = focus;
  }

  /// ✨✨✨✨✨✨✨ Override ✨✨✨✨✨✨✨
  @override
  void initState() {
    super.initState();

    // 获取数据
    _fetchRemoteData();

    // 配制数字居
    _slidableController = SlidableController(
      onSlideAnimationChanged: _handleSlideAnimationChanged,
      onSlideIsOpenChanged: _handleSlideIsOpenChanged,
    );

    // 监听滚动事件，打印滚动位置
    // 后面改成 NotificationListener 来监听滚动
    // 通过NotificationListener监听滚动事件和通过ScrollController有两个主要的不同：
    // - 通过NotificationListener可以在从可滚动组件到widget树根之间任意位置都能监听。而ScrollController只能和具体的可滚动组件关联后才可以。
    // - 收到滚动事件后获得的信息不同；NotificationListener在收到滚动事件时，通知中会携带当前滚动位置和ViewPort的一些信息，而ScrollController只能获取当前滚动位置
    // _controller.addListener(() {
    //   final offset = _controller.offset;
    //   if (offset <= 0.0) {
    //     // 计算
    //     _offset = offset * -1.0;
    //   } else if (_offset != 0.0) {
    //     _offset = 0.0;
    //   }
    //   // 处理偏移量
    //   _handlerOffset(_offset);
    // });
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _controller.dispose();
    super.dispose();
  }

  /// ✨✨✨✨✨✨✨ Network ✨✨✨✨✨✨✨
  /// 数据请求
  void _fetchRemoteData() async {
    //加载消息列表
    rootBundle.loadString('mock/mainframe.json').then((jsonStr) {
      final List mainframeJson = json.decode(jsonStr);
      // 遍历
      mainframeJson.forEach((json) {
        final Message m = Message.fromJson(json);
        _dataSource.add(m);
      });
      setState(() {});
    });
  }

  /// ✨✨✨✨✨✨✨ 事件 ✨✨✨✨✨✨✨
  /// // 监听事件
  void _handleSlideAnimationChanged(Animation<double> slideAnimation) {}
  void _handleSlideIsOpenChanged(bool isOpen) {
    setState(() {
      _slideIsOpen = isOpen;
    });
  }

  /// 关闭slidable
  void _closeSlidable() {
    // 容错处理
    if (!_slideIsOpen) return;

    // 方案三：
    _slidableController.activeState?.close();
  }

  // 处理偏移逻辑
  _handlerOffset(double offset) {
    // 计算
    if (offset <= 0.0) {
      _offset = offset * -1;
    } else if (_offset != 0.0) {
      _offset = 0.0;
    }

    // 这里需要

    setState(() {});
  }

  /// ✨✨✨✨✨✨✨ UI ✨✨✨✨✨✨✨
  /// 构建子部件
  Widget _buildChildWidget() {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            top: kToolbarHeight + ScreenUtil.statusBarHeight,
            left: 0,
            right: 0,
            height: ScreenUtil.screenHeightDp -
                kToolbarHeight -
                ScreenUtil.statusBarHeight -
                kBottomNavigationBarHeight,
            child: Container(
              child: _buildContentWidget(),
              height: ScreenUtil.screenHeightDp -
                  kToolbarHeight -
                  ScreenUtil.statusBarHeight -
                  kBottomNavigationBarHeight,
            ),
          ),

          // 小程序
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Applet(
              offset: _offset,
              dragging: _focusState,
            ),
          ),

          // 三个点部件
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: BouncyBalls(
              offset: _offset,
              dragging: _focusState,
            ),
          ),

          // 要放在其内容后面
          Positioned(
            top: _offset,
            left: 0,
            right: 0,
            height: kToolbarHeight + ScreenUtil.statusBarHeight,
            child: Container(
              height: kToolbarHeight + ScreenUtil.statusBarHeight,
              alignment: Alignment.bottomCenter,
              color: Colors.transparent,
              child: Text('微信'),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建内容部件
  Widget _buildContentWidget() {
    return Scrollbar(
        child: NotificationListener(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          if (notification.dragDetails != null) {
            _focus = true;
          }

          // print('start_focus 👉 $_focusState  ${notification.metrics.pixels}');
        } else if (notification is ScrollUpdateNotification) {
          if (_focusState && notification.dragDetails == null) _focus = false;

          // print('Update_focus 👉 $_focusState  ${notification.metrics.pixels}');
        } else if (notification is ScrollEndNotification) {
          if (_focusState) _focus = false;

          // print('End_focus 👉 $_focusState  ${notification.metrics.pixels}');
        }

        // 处理
        _handlerOffset(notification.metrics.pixels);

        return false;
      },
      child: CustomScrollView(
        controller: _controller,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: SearchBar(),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(_buildListItemWidget,
                childCount: _dataSource.length),
          ),
        ],
      ),
    ));
  }

  /// 构建列表项
  Widget _buildListItemWidget(BuildContext cxt, int idx) {
    final Message m = _dataSource[idx];
    // 头部分
    Widget leading = Padding(
      padding: EdgeInsets.only(right: ScreenUtil.getInstance().setWidth(36.0)),
      child: Avatars(message: m),
    );

    // 身体部分
    Widget middle = Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                m.screenName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: Style.pTextColor,
                  fontSize: ScreenUtil().setSp(51.0),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '2019/12/01',
              style: TextStyle(
                color: Color(0xFFB2B2B2),
                fontSize: ScreenUtil().setSp(36.0),
              ),
            ),
          ],
        ),
        SizedBox(height: ScreenUtil().setHeight(9.0)),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                m.text,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: Color(0xFF9B9B9B),
                  fontSize: ScreenUtil().setSp(48.0),
                ),
              ),
            ),
            Offstage(
              offstage: !m.messageFree,
              child: Image.asset(
                Constant.assetsImagesMainframe +
                    'AlbumMessageDisableNotifyIcon_15x15.png',
                width: ScreenUtil().setWidth(45),
                height: ScreenUtil().setHeight(45.0),
              ),
            )
          ],
        ),
      ],
    );

    final Widget listTile = MHListTile(
      // leading: leading,
      middle: middle,
      allowTap: !_slideIsOpen,
      contentPadding: EdgeInsets.symmetric(
          horizontal: ScreenUtil.getInstance().setWidth(48.0),
          vertical: ScreenUtil.getInstance().setHeight(36.0)),
      dividerColor: Color(0xFFD8D8D8),
      dividerIndent: ScreenUtil().setWidth(228.0),
      onTapValue: (cxt) {
        // 没有侧滑展开项 就直接下钻
        if (!_slideIsOpen) {
          // NavigatorUtils.push(cxt,
          //     '${ContactsRouter.contactInfoPage}?idstr=${user.idstr}');
          return;
        }

        // 下钻联系人信息
        if (Slidable.of(cxt)?.renderingMode == SlidableRenderingMode.none) {
          // 关闭上一个侧滑
          _closeSlidable();
          // 下钻
        } else {
          Slidable.of(cxt)?.close();
        }
      },
    );

    final List<Widget> secondaryActions = [];

    // 每个消息item 都��删除 按钮
    Widget deleteBtn = GestureDetector(
      child: Container(
        color: Colors.red,
        child: Text(
          '删除',
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil.getInstance().setSp(51.0),
            fontWeight: FontWeight.w400,
          ),
        ),
        alignment: Alignment.center,
      ),
      onTap: () {},
    );

    if (m.type == '0') {
      // 订��号消息、微信运动、微信支付
      secondaryActions.add(deleteBtn);
    } else if (m.type == '1') {
      // 单聊、群聊、QQ邮箱提醒
      final Widget notRead = GestureDetector(
        child: Container(
          color: Color(0xFFC7C7CB),
          width: 150,
          child: Text(
            '标为未读',
            style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil.getInstance().setSp(51.0),
              fontWeight: FontWeight.w400,
            ),
          ),
          alignment: Alignment.center,
        ),
        onTap: () {},
      );
      secondaryActions.addAll([notRead, deleteBtn]);
    } else {
      // 公众号
      final Widget focusBtn = GestureDetector(
        child: Container(
          color: Color(0xFFC7C7CB),
          width: 150,
          child: Text(
            '不再关注',
            style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil.getInstance().setSp(51.0),
              fontWeight: FontWeight.w400,
            ),
          ),
          alignment: Alignment.center,
        ),
        onTap: () {},
      );
      secondaryActions.addAll([focusBtn, deleteBtn]);
    }
    // 需要侧滑事件
    return Slidable(
      // 必须的有key
      key: Key(m.idstr),
      controller: _slidableController,
      dismissal: SlidableDismissal(
        closeOnCanceled: false,
        dragDismissible: true,
        child: SlidableDrawerDismissal(),
        onWillDismiss: (actionType) {
          return false;
        },
        onDismissed: (_) {},
      ),
      // 抽屉式
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.2,
      child: listTile,
      secondaryActions: secondaryActions,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('微信'),
      //   actions: <Widget>[
      //     IconButton(
      //       icon: new SvgPicture.asset(
      //         Constant.assetsImagesMainframe + 'icons_outlined_add2.svg',
      //         color: Color(0xFF181818),
      //       ),
      //       onPressed: () {
      //         // 关闭上一个侧滑
      //         _closeSlidable();
      //       },
      //     )
      //   ],
      // ),
      body: _buildChildWidget(),
    );
  }
}
