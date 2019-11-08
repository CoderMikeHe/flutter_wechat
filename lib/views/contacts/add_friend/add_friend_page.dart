import 'package:flutter/material.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';

import 'package:flutter_wechat/widgets/contacts/add_friend/search_friend_header.dart';
import 'package:flutter_wechat/components/list_tile/mh_list_tile.dart';

class AddFriendPage extends StatefulWidget {
  AddFriendPage({Key key}) : super(key: key);

  _AddFriendPageState createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  /// 数据源
  final List<Map> dataSource = [];

  @override
  void initState() {
    super.initState();

    // 配置数据源
    this.dataSource.add(
          _generateData(
            Constant.assetsImagesContacts + 'add_friend_icon_reda_36x36.png',
            '雷达加朋友',
            '添加身边的朋友',
          ),
        );
    this.dataSource.add(
          _generateData(
            Constant.assetsImagesContacts +
                'add_friend_icon_addgroup_36x36.png',
            '面对面建群',
            '与身边的朋友进入同一个群聊',
          ),
        );
    this.dataSource.add(
          _generateData(
            Constant.assetsImagesContacts + 'add_friend_icon_scanqr_36x36.png',
            '扫一扫',
            '扫描二维码名片',
          ),
        );
    this.dataSource.add(
          _generateData(
            Constant.assetsImagesContacts +
                'add_friend_icon_contacts_36x36.png',
            '手机联系人',
            '添加通讯录中的朋友',
          ),
        );
    this.dataSource.add(
          _generateData(
            Constant.assetsImagesContacts + 'add_friend_icon_offical_36x36.png',
            '公众号',
            '获取更多资讯和服务',
          ),
        );
    this.dataSource.add(
          _generateData(
            Constant.assetsImagesContacts +
                'add_friend_icon_search_wework_36x36.png',
            '企业微信联系人',
            '通过手机号搜索企业微信用户',
          ),
        );
  }

  /// -------- Action
  Map _generateData(String icon, String title, String subtitle) {
    return {
      'icon': icon,
      'title': title,
      'subtitle': subtitle,
    };
  }

  ///  -------- UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('添加朋友'),
      ),
      body: _buildChildWidget(),
    );
  }

  /// 构建子部件
  Widget _buildChildWidget() {
    return ListView.builder(
      itemCount: 1 + this.dataSource.length,
      itemBuilder: (BuildContext context, int index) {
        return index == 0 ? _buildHeaderWidget() : _buildItemWidget(index - 1);
      },
    );
  }

  /// 构建 header 部件
  Widget _buildHeaderWidget() {
    return SearchFriendHeader();
  }

  /// 构建 item 部件
  Widget _buildItemWidget(int index) {
    final m = this.dataSource[index];
    Widget leading = Padding(
      padding: EdgeInsets.only(right: 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Image.asset(
          m['icon'],
          width: 36.0,
          height: 36.0,
        ),
      ),
    );

    Widget middle = Padding(
      padding: EdgeInsets.only(right: Constant.pEdgeInset),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            m['title'],
            style: TextStyle(fontSize: 16.0, color: Style.pTextColor),
          ),
          Text(
            m['subtitle'],
            style: TextStyle(fontSize: 12.0, color: Style.mTextColor),
          )
        ],
      ),
    );

    Widget trailing = Image.asset(
      Constant.assetsImagesArrow + 'tableview_arrow_8x13.png',
      width: 8.0,
      height: 13.0,
    );

    return MHListTile(
      leading: leading,
      middle: middle,
      trailing: trailing,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      dividerIndent: 16.0 + 36.0 + 16.0,
    );
  }
}
