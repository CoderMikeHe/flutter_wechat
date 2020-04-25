import 'package:flutter/material.dart';

import 'package:flutter_wechat/utils/util.dart';
import 'package:flutter_wechat/constant/cache_key.dart';
import 'package:flustars/flustars.dart';

import 'package:flutter_wechat/model/common/common_item.dart';
import 'package:flutter_wechat/model/common/common_group.dart';

import 'package:flutter_wechat/model/common/common_header.dart';
import 'package:flutter_wechat/model/common/common_footer.dart';
import 'package:flutter_wechat/widgets/common/common_group_widget.dart';
import 'package:flutter_wechat/widgets/loading_dialog/loading_dialog.dart';

import 'package:flutter_wechat/model/user/user.dart';
import 'package:flutter_wechat/utils/service/contacts_service.dart';
import 'package:flutter_wechat/utils/service/account_service.dart';

// 适配完毕
class FriendPermissionPage extends StatefulWidget {
  /// 构造函数
  FriendPermissionPage({Key key, @required this.idstr}) : super(key: key);

  /// 用户ID
  final String idstr;

  _FriendPermissionPageState createState() => _FriendPermissionPageState();
}

class _FriendPermissionPageState extends State<FriendPermissionPage> {
  /// 用户信息
  User _user;

  /// 当前用户信息
  User _currentUser;

  /// 数据源
  List<CommonGroup> _dataSource = [];

  /// 选中的Item
  CommonRadioItem _selectedItem;

  @override
  void initState() {
    super.initState();
    // 获取用户信息
    _user = ContactsService.sharedInstance.contactsMap[widget.idstr];
    _currentUser = AccountService.sharedInstance.currentUser;
    // 配置数据
    _dataSource = _configData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('朋友权限'),
      ),
      body: Container(
        child: _buildChildWidget(context),
      ),
    );
  }

  /// 配置数据
  List<CommonGroup> _configData() {
    // PS: 这里需要把当前账号和用户的id 作为前缀去片接cachekey
    final preCacheKey = _currentUser.idstr + '_' + _user.idstr + '_';

    // 获取朋友圈权限
    final friendPeimisson = SpUtil.getString(
        preCacheKey + CacheKey.settingFriendPermissionKey,
        defValue: 'All');

    // group0
    // 聊天、朋友圈、微信运动等
    final all = CommonRadioItem(
      title: '聊天、朋友圈、微信运动等',
      onTap: _itemOnTap,
      value: 'All' == friendPeimisson,
    );
    // 仅聊天
    final chat = CommonRadioItem(
      title: '仅聊天',
      onTap: _itemOnTap,
      value: 'Chat' == friendPeimisson,
    );

    // 赋值给 _selectedItem
    _selectedItem = all.value ? all : chat;

    final group0 = CommonGroup(
      items: [all, chat],
      header: CommonHeader(header: '设置朋友权限'),
    );

    // group1
    final String heOrShe = _user.gender == 1 ? "她" : "他";

    // 不让他看
    final iNotLookHe = CommonSwitchItem(
      title: '不让' + heOrShe + '看',
      cacheKey: preCacheKey + CacheKey.notAllowLookMyMomentsKey,
    );
    // 不看他
    final heNotLookMe = CommonSwitchItem(
      title: "不看" + heOrShe,
      cacheKey: preCacheKey + CacheKey.notLookHisMomentsKey,
    );
    // 组头
    final CommonHeader header1 = CommonHeader(header: '朋友圈和视频动态');
    final group1 = CommonGroup(
      header: header1,
      items: [
        iNotLookHe,
        heNotLookMe,
      ],
    );

    // 添加数据源
    return [group0, group1];
  }

  /// itemOnTap
  void _itemOnTap(CommonItem i) {
    final CommonRadioItem item = (i as CommonRadioItem);
    // 三部曲
    if (_selectedItem == null) {
      setState(() {
        item.value = true;
        _selectedItem = item;
      });
    } else if (_selectedItem != null && _selectedItem == item) {
    } else if (_selectedItem != null && _selectedItem != item) {
      /// 配置数据
      final loading =
          LoadingDialog(buildContext: context, loadingMessage: '正在加载中...');

      /// show loading
      loading.show();
      // 延时1s执行返回,模拟网络加载
      Future.delayed(Duration(seconds: 1), () async {
        // hide loading
        loading.hide();
        _selectedItem.value = false;
        item.value = true;
        _selectedItem = item;
        final preCacheKey = _currentUser.idstr + '_' + _user.idstr + '_';
        if (item.title == '仅聊天') {
          SpUtil.putString(
              preCacheKey + CacheKey.settingFriendPermissionKey, 'Chat');
        } else {
          SpUtil.putString(
              preCacheKey + CacheKey.settingFriendPermissionKey, 'All');
        }
        setState(() {});
      });
    }
  }

  /// 构建child
  Widget _buildChildWidget(BuildContext context) {
    return ListView.builder(
      itemCount: _selectedItem.title == '仅聊天'
          ? _dataSource.length - 1
          : _dataSource.length,
      itemBuilder: (BuildContext context, int index) {
        return CommonGroupWidget(
          group: _dataSource[index],
        );
      },
    );
  }
}
