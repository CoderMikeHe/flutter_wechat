import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
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

  /// ✨✨✨✨✨✨✨ Override ✨✨✨✨✨✨✨
  @override
  void initState() {
    super.initState();

    // 获取数据
    Future.delayed(Duration(milliseconds: 200), _fetchRemoteData);
  }

  /// ✨✨✨✨✨✨✨ Network ✨✨✨✨✨✨✨
  /// 数据请求
  void _fetchRemoteData() async {
    _dataSource.clear();

    // 获取用户信息列表
    final jsonStr =
        await rootBundle.loadString(Constant.mockData + 'mainframe.json');

    // mainframeJson
    final List mainframeJson = json.decode(jsonStr);

    // 遍历
    mainframeJson.forEach((json) {
      final Message m = Message.fromJson(json);
      _dataSource.add(m);
    });

    setState(() {});
  }

  /// ✨✨✨✨✨✨✨ 事件 ✨✨✨✨✨✨✨

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

    return MHListTile(
      leading: leading,
      middle: middle,
      contentPadding: EdgeInsets.symmetric(
          horizontal: ScreenUtil.getInstance().setWidth(48.0),
          vertical: ScreenUtil.getInstance().setHeight(36.0)),
      dividerColor: Color(0xFFD8D8D8),
      dividerIndent: ScreenUtil().setWidth(228.0),
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
              // 关掉侧滑
            },
          )
        ],
      ),
      body: _buildChildWidget(),
    );
  }
}
