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

class MainframePage extends StatefulWidget {
  MainframePage({Key key}) : super(key: key);

  @override
  _MainframePageState createState() => _MainframePageState();
}

class _MainframePageState extends State<MainframePage> {
  /// 数据源
  List<Message> _dataSource = [];
  // 侧滑controller
  SlidableController _slidableController;
  // 是否展开
  bool _slideIsOpen = false;

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

  /// ✨✨✨✨✨✨✨ UI ✨✨✨✨✨✨✨
  /// 构建子部件
  Widget _buildChildWidget() {
    return Container(
      child: CustomScrollView(
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
    );
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

    // 每个消息item 都有删除 按钮
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
      // 订阅号消息、微信运动、微信支付
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
      appBar: AppBar(
        title: Text('微信'),
        actions: <Widget>[
          IconButton(
            icon: new SvgPicture.asset(
              Constant.assetsImagesMainframe + 'icons_outlined_add2.svg',
              color: Color(0xFF181818),
            ),
            onPressed: () {
              // 关闭上一个侧滑
              _closeSlidable();
            },
          )
        ],
      ),
      body: _buildChildWidget(),
    );
  }
}
