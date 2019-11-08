import 'package:flutter/material.dart';

import 'package:flutter_wechat/utils/util.dart';

import 'package:flutter_wechat/model/common/common_item.dart';
import 'package:flutter_wechat/model/common/common_group.dart';

import 'package:flutter_wechat/widgets/common/common_group_widget.dart';

import 'package:flutter_wechat/model/user/user.dart';
import 'package:flutter_wechat/utils/service/contacts_service.dart';
import 'package:flutter_wechat/utils/service/account_service.dart';

class ContactMoreInfoPage extends StatefulWidget {
  /// 构造函数
  ContactMoreInfoPage({Key key, @required this.idstr}) : super(key: key);

  /// 用户ID
  final String idstr;
  _ContactMoreInfoPageState createState() => _ContactMoreInfoPageState();
}

class _ContactMoreInfoPageState extends State<ContactMoreInfoPage> {
  /// 用户信息
  User _user;

  /// 数据源
  List<CommonGroup> _dataSource = [];

  @override
  void initState() {
    super.initState();
    // 获取用户信息
    _user = ContactsService.sharedInstance.contactsMap[widget.idstr];

    // 配置数据
    _dataSource = _configData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('社交资料'),
      ),
      body: Container(
        child: _buildChildWidget(context),
      ),
    );
  }

  /// 配置数据
  List<CommonGroup> _configData() {
    // group0
    // 我和他的共同群聊
    final sameChats = CommonTextItem(
      title: '我和他(她)的共同群聊',
      subtitle: '0个',
    );
    final group0 = CommonGroup(
      items: [
        sameChats,
      ],
    );

    // group3
    // 个性签名
    final featureSign = CommonTextItem(
      title: "个性签名",
      subtitle: _user.featureSign,
    );

    /// 来源
    final source = CommonTextItem(
      title: "来源",
      subtitle: '通过搜索手机号添加',
    );
    final group1 = CommonGroup(
      items: Util.isNotEmptyString(_user.featureSign)
          ? [featureSign, source]
          : [source],
    );

    // 添加数据源
    return [group0, group1];
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
