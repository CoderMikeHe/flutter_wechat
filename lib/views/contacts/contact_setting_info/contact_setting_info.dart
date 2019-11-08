import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/cache_key.dart';
import 'package:flutter_wechat/constant/style.dart';
import 'package:flutter_wechat/utils/util.dart';

import 'package:flutter_wechat/model/common/common_item.dart';
import 'package:flutter_wechat/model/common/common_group.dart';
import 'package:flutter_wechat/model/common/common_header.dart';
import 'package:flutter_wechat/model/common/common_footer.dart';
import 'package:flutter_wechat/components/action_sheet/action_sheet.dart';

import 'package:flutter_wechat/widgets/common/common_group_widget.dart';

import 'package:flutter_wechat/model/user/user.dart';
import 'package:flutter_wechat/utils/service/contacts_service.dart';
import 'package:flutter_wechat/utils/service/account_service.dart';

class ContactSettingInfoPage extends StatefulWidget {
  /// 构造函数
  ContactSettingInfoPage({Key key, @required this.idstr}) : super(key: key);

  /// 用户ID
  final String idstr;
  _ContactSettingInfoPageState createState() => _ContactSettingInfoPageState();
}

class _ContactSettingInfoPageState extends State<ContactSettingInfoPage> {
  /// 用户信息
  User _user;

  /// 当前用户信息
  User _currentUser;

  /// 数据源
  List<CommonGroup> _dataSource = [];

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
        title: Text('资料设置'),
      ),
      body: Container(
        child: _buildChildWidget(context),
      ),
    );
  }

  /// 配置数据
  List<CommonGroup> _configData() {
    // group0
    // 设置备注和标签
    final settingRemarks = CommonItem(
      title: '设置备注和标签',
      subtitle: _user.screenName,
    );
    final group0 = CommonGroup(
      items: [
        settingRemarks,
      ],
    );

    // 把他推荐给朋友
    // group1
    final String heOrShe = _user.gender == 1 ? "她" : "他";
    final recommendToFriends = CommonItem(
      title: "把" + heOrShe + "推荐给朋友",
    );
    final group1 = CommonGroup(
      items: [recommendToFriends],
    );

    // PS: 这里需要把当前账号和用户的id 作为前缀去片接cachekey
    final preCacheKey = _currentUser.idstr + '_' + _user.idstr + '_';

    // group2
    // 设为星标朋友
    final starFriend = CommonSwitchItem(
      title: '设为星标朋友',
      cacheKey: preCacheKey + CacheKey.settingToStarFriendKey,
    );
    final group2 = CommonGroup(
      footerHeight: 0.0,
      items: [
        starFriend,
      ],
    );

    // group3
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
    final CommonHeader header0 = CommonHeader(header: '朋友圈和视频动态');
    final group3 = CommonGroup(
      header: header0,
      items: [
        iNotLookHe,
        heNotLookMe,
      ],
    );

    // group3
    // 加入黑名单
    final joinToBlacklist = CommonSwitchItem(
      title: "加入黑名单",
      cacheKey: preCacheKey + CacheKey.joinToBlacklistKey,
    );

    /// 投诉
    final complaint = CommonItem(
      title: "投诉",
    );
    final group4 = CommonGroup(
      items: [
        joinToBlacklist,
        complaint,
      ],
    );

    /// 删除
    final delete = CommonCenterItem(
        title: "删除",
        titleColor: Style.pTextWarnColor,
        onTap: (_) {
          // 显示action sheet
          _showActionSheet(context);
        });
    final group5 = CommonGroup(
      items: [delete],
    );

    // 添加数据源
    return [group0, group1, group2, group3, group4, group5];
  }

  /// 构建actionsheet
  void _showActionSheet(BuildContext context) {
    final String title = '将联系人' + _user.screenName + '”删除，同时删除与该联系人的聊天记录';
    ActionSheet.show(
      context,
      title: Text(title),
      actions: <Widget>[
        ActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          isDestructiveAction: true,
          child: Text('删除联系人'),
        ),
      ],
      cancelButton: ActionSheetAction(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('取消'),
      ),
    );
  }

  /// 构建child
  Widget _buildChildWidget(BuildContext context) {
    return ListView.builder(
      itemCount: _dataSource.length,
      itemBuilder: (BuildContext context, int index) {
        return CommonGroupWidget(
          group: _dataSource[index],
        );
      },
    );
  }
}
