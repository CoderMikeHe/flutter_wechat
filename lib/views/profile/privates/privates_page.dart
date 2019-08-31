import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_wechat/constant/cache_key.dart';

import 'package:flutter_wechat/model/common/common_item.dart';
import 'package:flutter_wechat/model/common/common_group.dart';
import 'package:flutter_wechat/model/common/common_footer.dart';
import 'package:flutter_wechat/model/common/common_header.dart';

import 'package:flutter_wechat/widgets/common/common_group_widget.dart';

import 'package:flutter_wechat/views/profile/add_way/add_way_page.dart';
import 'package:flutter_wechat/views/profile/check_scope/check_scope_page.dart';

/// 隐私
class PrivatesPage extends StatefulWidget {
  PrivatesPage({Key key}) : super(key: key);

  _PrivatesPageState createState() => _PrivatesPageState();
}

class _PrivatesPageState extends State<PrivatesPage> {
  /// 数据源
  List<CommonGroup> _dataSource = [];

  /// 查看范围 item
  CommonItem _checkScope;

  /// 点击事件
  final TapGestureRecognizer _tapGr0 = TapGestureRecognizer();
  final TapGestureRecognizer _tapGr1 = TapGestureRecognizer();

  /// 是否允许点击高亮
  bool _highlight0 = false;
  bool _highlight1 = false;
  @override
  void initState() {
    super.initState();

    // 配置点击事假
    _tapGr0.onTap = () {
      _handleTap(0);
    };
    _tapGr0.onTapDown = (TapDownDetails details) {
      _handleTapDown(details, 0);
    };
    _tapGr0.onTapUp = (TapUpDetails details) {
      _handleTapUp(details, 0);
    };
    _tapGr0.onTapCancel = () {
      _handleTapCancel(0);
    };

    _tapGr1.onTap = () {
      _handleTap(1);
    };
    _tapGr1.onTapDown = (TapDownDetails details) {
      _handleTapDown(details, 1);
    };
    _tapGr1.onTapUp = (TapUpDetails details) {
      _handleTapUp(details, 1);
    };
    _tapGr1.onTapCancel = () {
      _handleTapCancel(1);
    };

    // 配置数据源
    _configData();
    // 赋值
    _getCheckScopeCache();
  }

  /// 配置数据
  _configData() {
    // group0
    // 加我为朋友时需要验证
    final verification = CommonSwitchItem(
      title: '加我为朋友时需要验证',
      cacheKey: CacheKey.addFriendNeedVerifyKey,
    );
    final group0 = CommonGroup(
      items: [verification],
    );

    // group1
    // 添加我的方式
    final addWay = CommonItem(
      title: "添加我的方式",
      onTap: (_) {
        Navigator.of(context).push(new MaterialPageRoute(
          builder: (_) {
            return AddWayPage();
          },
        ));
      },
    );
    // 向我推荐通讯录朋友
    final recommend = CommonSwitchItem(
      title: "向我推荐通讯录朋友",
      cacheKey: CacheKey.recommendFriendFromContactsListKey,
    );
    final footer1 = CommonFooter(footer: '开启后，为你推荐已经开通微信的手机联系人。');
    final group1 = CommonGroup(
      items: [
        addWay,
        recommend,
      ],
      footer: footer1,
    );

    // group2
    // 通讯录黑名单
    final blacklist = CommonItem(
      title: "通讯录黑名单",
    );
    final group2 = CommonGroup(
      items: [blacklist],
      footerHeight: 0.0,
    );

    // group3
    // 不让他(她)看我的朋友圈
    final notAllow = CommonItem(
      title: "不让他(她)看我的朋友圈",
    );
    // 不看他(她)的朋友圈
    final notWatch = CommonItem(
      title: "不看他(她)的朋友圈",
    );
    // 允许朋友查看朋友圈的范围
    final checkScope = CommonItem(
      title: "允许朋友查看朋友圈的范围",
      subtitle: '',
      onTap: (CommonItem item) async {
        final String result = await Navigator.of(context).push(
          new MaterialPageRoute(
            builder: (_) {
              return CheckScopePage(
                value: item.subtitle.isEmpty ? '全部' : item.subtitle,
              );
            },
          ),
        );
        if (null != result && item.subtitle != result) {
          setState(() {
            item.subtitle = result;
          });
          // 存储本地
          SharedPreferences sp = await SharedPreferences.getInstance();
          sp.setString(CacheKey.momentsCheckScopeKey, result);
        }
      },
    );
    _checkScope = checkScope;

    // 允许陌生人查看十条朋友圈
    final stranger = CommonSwitchItem(
      title: "允许陌生人查看十条朋友圈",
      cacheKey: CacheKey.allowStrongerWatchTenMomentsKey,
    );
    final header3 = CommonHeader(header: '朋友圈和视频动态');
    final group3 = CommonGroup(
      header: header3,
      items: [notAllow, notWatch, checkScope, stranger],
    );

    // group4
    // 朋友圈更新提醒
    final updateAlert = CommonSwitchItem(
      title: '朋友圈更新提醒',
      cacheKey: CacheKey.momentsUpdateAlertKey,
    );
    final footer4 =
        CommonFooter(footer: '关闭后，有朋友发表朋友圈时，界面下方的”发现“切换按钮上不在出现红点提示');
    final group4 = CommonGroup(
      items: [updateAlert],
      footer: footer4,
    );

    // group5
    // 授权管理
    final kinguser = CommonItem(
      title: '授权管理',
    );
    final group5 = CommonGroup(
      items: [kinguser],
    );

    // 添加数据源
    _dataSource = [group0, group1, group2, group3, group4, group5];
  }

  /// 读取缓存
  void _getCheckScopeCache() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String value = sp.getString(CacheKey.momentsCheckScopeKey);
    setState(() {
      _checkScope.subtitle = null == value ? '全部' : value;
    });
  }

  /// 点击状态事件 they occur: down, up, tap, cancel
  void _handleTapDown(TapDownDetails details, int type) {
    setState(() {
      if (type == 0) {
        _highlight0 = true;
      } else {
        _highlight1 = true;
      }
    });
  }

  void _handleTapUp(TapUpDetails details, int type) {
    setState(() {
      if (type == 0) {
        _highlight0 = false;
      } else {
        _highlight1 = false;
      }
    });
  }

  void _handleTapCancel(int type) {
    setState(() {
      if (type == 0) {
        _highlight0 = false;
      } else {
        _highlight1 = false;
      }
    });
  }

  /// 点击事件
  void _handleTap(int type) {
    // 事件回调
  }

  /// 列表数据
  Widget _buildListItem(BuildContext context, int index) {
    return CommonGroupWidget(
      group: _dataSource[index],
    );
  }

  // 构建 child 的小部件
  Widget _buildChildWidget(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          // 列表
          SliverList(
            delegate: SliverChildBuilderDelegate(_buildListItem,
                childCount: _dataSource.length),
          ),
          // 尾部
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: Container(
                width: double.maxFinite,
                child: Text.rich(
                  TextSpan(
                    text: '',
                    children: [
                      TextSpan(
                        text: '《微信软件许可及服务协议》',
                        style: TextStyle(
                            backgroundColor: _highlight0
                                ? Color(0xFFC7C7C5)
                                : Colors.transparent),
                        recognizer: _tapGr0,
                      ),
                      TextSpan(
                        text: '和',
                        style: TextStyle(color: Colors.black87),
                      ),
                      TextSpan(
                        text: '《微信意思保护指引》',
                        style: TextStyle(
                            backgroundColor: _highlight1
                                ? Color(0xFFC7C7C5)
                                : Colors.transparent),
                        recognizer: _tapGr1,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF576B95),
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('隐私'),
      ),
      body: Container(
        child: _buildChildWidget(context),
      ),
    );
  }
}
