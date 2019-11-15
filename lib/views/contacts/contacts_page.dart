import 'package:flutter/material.dart';
import 'package:azlistview/azlistview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';

import 'package:flutter_wechat/model/user/user.dart';
import 'package:flutter_wechat/utils/service/contacts_service.dart';

import 'package:flutter_wechat/routers/fluro_navigator.dart';
import 'package:flutter_wechat/views/contacts/contacts_router.dart';

import 'package:flutter_wechat/components/list_tile/mh_list_tile.dart';
import 'package:flutter_wechat/components/search_bar/search_bar.dart';

class ContactsPage extends StatefulWidget {
  ContactsPage({Key key}) : super(key: key);

  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  /// 联系人列表
  List<User> _contactsList = [];
  int _suspensionHeight = 40;
  int _itemHeight = 56;
  String _suspensionTag = "";

  /// 联系人总数
  String _contactsCount = '';

  /// 最后一个联系人
  User _lastContact;
  @override
  void initState() {
    super.initState();
    // 请求联系人
    _fetchContacts();
  }

  /// 请求联系人列表
  void _fetchContacts() async {
    List<User> list = [];
    if (ContactsService.sharedInstance.contactsList != null &&
        ContactsService.sharedInstance.contactsList.isNotEmpty) {
      list = ContactsService.sharedInstance.contactsList;
    } else {
      list = await ContactsService.sharedInstance.fetchContacts();
    }
    setState(() {
      _contactsList = list;
      _lastContact = list.last;
      _contactsCount = "${list.length}位联系人";
    });
  }

  /// 索引标签被点击
  void _onSusTagChanged(String tag) {
    setState(() {
      _suspensionTag = tag;
    });
  }

  /// 构建头部
  Widget _buildHeader() {
    return Column(
      children: <Widget>[
        SearchBar(),
        _buildItem(
          Constant.assetsImagesContacts + 'plugins_FriendNotify_36x36.png',
          '新的朋友',
          false,
          onTap: () {},
        ),
        _buildItem(
          Constant.assetsImagesContacts + 'add_friend_icon_addgroup_36x36.png',
          '新的朋友',
          false,
          onTap: () {},
        ),
        _buildItem(
          Constant.assetsImagesContacts + 'Contact_icon_ContactTag_36x36.png',
          '标签',
          false,
          onTap: () {},
        ),
        _buildItem(
          Constant.assetsImagesContacts + 'add_friend_icon_offical_36x36.png',
          '公众号',
          false,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSusWidget(String susTag) {
    return Container(
      height: _suspensionHeight.toDouble(),
      padding: const EdgeInsets.only(left: 15.0),
      color: Color(0xfff3f4f5),
      alignment: Alignment.centerLeft,
      child: Text(
        '$susTag',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xff999999),
        ),
      ),
    );
  }

  Widget _buildListItem(User user) {
    String susTag = user.getSuspensionTag();
    return Column(
      children: <Widget>[
        Offstage(
          offstage: user.isShowSuspension != true,
          child: _buildSusWidget(susTag),
        ),
        Container(
          height: _itemHeight.toDouble(),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Expanded(
                child: _buildItem(user.profileImageUrl, user.screenName, true,
                    onTap: () {
                  // 下钻联系人信息
                  NavigatorUtils.push(context,
                      '${ContactsRouter.contactInfoPage}?idstr=${user.idstr}');
                }),
              )
            ],
          ),
        ),
        Offstage(
          offstage: _lastContact.idstr != user.idstr,
          child: Container(
            width: double.infinity,
            height: 44.0,
            alignment: Alignment.center,
            child: Text(
              _contactsCount,
              style: TextStyle(fontSize: 16.0, color: Style.sTextColor),
            ),
          ),
        ),
      ],
    );
  }

  /// 返回 item
  Widget _buildItem(
    String icon,
    String title,
    bool isNetwork, {
    void Function() onTap,
  }) {
    Widget leading = Padding(
        padding: EdgeInsets.only(right: 16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: isNetwork
              ? CachedNetworkImage(
                  imageUrl: icon,
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return Image.asset(
                      Constant.assetsImagesDefault + 'DefaultHead_48x48.png',
                      width: 36.0,
                      height: 36.0,
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Image.asset(
                      Constant.assetsImagesDefault + 'DefaultHead_48x48.png',
                      width: 36.0,
                      height: 36.0,
                    );
                  },
                )
              : Image.asset(
                  icon,
                  width: 36.0,
                  height: 36.0,
                ),
        ));

    Widget middle = Padding(
      padding: EdgeInsets.only(right: Constant.pEdgeInset),
      child: Text(
        title,
        style: TextStyle(fontSize: 17.0, color: Style.pTextColor),
      ),
    );
    return MHListTile(
      onTap: onTap,
      leading: leading,
      middle: middle,
      height: _itemHeight.toDouble(),
      dividerIndent: 16.0 + 36.0 + 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('通讯录'),
        actions: <Widget>[
          IconButton(
            icon: new SvgPicture.asset(
              Constant.assetsImagesContacts + 'icons_outlined_add-friends.svg',
              color: Color(0xFF333333),
            ),
            onPressed: () {
              NavigatorUtils.push(context, ContactsRouter.addFriendPage);
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: AzListView(
                data: _contactsList,
                itemBuilder: (context, model) => _buildListItem(model),
                suspensionWidget: _buildSusWidget(_suspensionTag),
                isUseRealIndex: true,
                itemHeight: _itemHeight,
                suspensionHeight: _suspensionHeight,
                onSusTagChanged: _onSusTagChanged,
                header: AzListViewHeader(
                    // - [特殊字符](https://blog.csdn.net/cfxy666/article/details/87609526)
                    // - [特殊字符](http://www.fhdq.net/)
                    tag: "♀",
                    height: 5 * _itemHeight,
                    builder: (context) {
                      return _buildHeader();
                    }),
                indexHintBuilder: (context, hint) {
                  return Container(
                    alignment: Alignment.center,
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    child: Text(hint,
                        style: TextStyle(color: Colors.white, fontSize: 30.0)),
                  );
                },
              )),
        ],
      ),
    );
  }
}
