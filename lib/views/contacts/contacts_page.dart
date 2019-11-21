import 'package:flutter/material.dart';
import 'package:azlistview/azlistview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  /// 悬浮view 高度 向上取整
  int _suspensionHeight =
      (ScreenUtil.getInstance().setHeight(99.0) as double).ceil();

  /// 每个item 高度 向上取整
  int _itemHeight =
      (ScreenUtil.getInstance().setHeight(168.0) as double).ceil();
  String _suspensionTag = "";

  /// 联系人总数
  String _contactsCount = '';

  /// 最后一个联系人
  User _lastContact;

  // 侧滑controller
  SlidableController _slidableController;
  // 是否展开
  bool _slideIsOpen = false;

  @override
  void initState() {
    super.initState();
    // 请求联系人
    _fetchContacts();
    // 配制数字居
    _slidableController = SlidableController(
      onSlideAnimationChanged: _handleSlideAnimationChanged,
      onSlideIsOpenChanged: _handleSlideIsOpenChanged,
    );
  }

  void _handleSlideAnimationChanged(Animation<double> slideAnimation) {
    // print('handleSlideAnimationChanged');
  }

  void _handleSlideIsOpenChanged(bool isOpen) {
    print('handleSlideIsOpenChanged $isOpen');
    setState(() {
      _slideIsOpen = isOpen;
    });
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
    print('_buildHeader');
    return Column(
      children: <Widget>[
        SearchBar(),
        _buildItem(
          Constant.assetsImagesContacts + 'plugins_FriendNotify_36x36.png',
          '新的朋友',
          false,
          onTap: (cxt) {
            if (Slidable.of(cxt)?.renderingMode == SlidableRenderingMode.none) {
              // 细节：这里由于 SlideActionType.primary 对应 actions 为空，所以虽然看似展开空，目的就是关闭 上一个打开的 secondary action
              Slidable.of(cxt)?.open(actionType: SlideActionType.primary);
              // 上面的虽然打开了一个空的 但是系统还是会认为是 打开的 也就是 _slideIsOpen = true
              // 手动设置为true
              _slideIsOpen = false;
            } else {
              Slidable.of(cxt)?.close();
            }

            // 下钻
          },
        ),
        _buildItem(
          Constant.assetsImagesContacts + 'add_friend_icon_addgroup_36x36.png',
          '群聊',
          false,
        ),
        _buildItem(
          Constant.assetsImagesContacts + 'Contact_icon_ContactTag_36x36.png',
          '标签',
          false,
        ),
        _buildItem(
          Constant.assetsImagesContacts + 'add_friend_icon_offical_36x36.png',
          '公众号',
          false,
        ),
      ],
    );
  }

  /// 构建悬浮部件
  /// [susTag] 标签名称
  /// [isFloat] 是否悬浮
  Widget _buildSusWidget(String susTag, {bool isFloat = false}) {
    return Container(
      height: _suspensionHeight.toDouble(),
      padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(51.0)),
      decoration: BoxDecoration(
        color: isFloat ? Colors.white : Style.pBackgroundColor,
        border: isFloat
            ? Border(bottom: BorderSide(color: Color(0xFFE6E6E6), width: 0.5))
            : null,
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        '$susTag',
        softWrap: false,
        style: TextStyle(
          fontSize: ScreenUtil.getInstance().setSp(39.0),
          color: isFloat ? Style.pTintColor : Color(0xff777777),
        ),
      ),
    );
  }

  /// 构建列表项
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
                    needSlidable: true, onTap: (cxt) {
                  print('3333 ---- $cxt');
                  // 下钻联系人信息
                  if (Slidable.of(cxt)?.renderingMode ==
                      SlidableRenderingMode.none) {
                    // 细节：这里由于 SlideActionType.primary 对应 actions 为空，所以虽然看似展开空，目的就是关闭 上一个打开的 secondary action
                    Slidable.of(cxt)?.open(actionType: SlideActionType.primary);
                    // 上面的虽然打开了一个空的 但是系统还是会认为是 打开的 也就是 _slideIsOpen = true
                    // 手动设置为true
                    _slideIsOpen = false;
                    NavigatorUtils.push(cxt,
                        '${ContactsRouter.contactInfoPage}?idstr=${user.idstr}');
                  } else {
                    Slidable.of(cxt)?.close();
                  }
                }),
              )
            ],
          ),
        ),
        // 底部显示共有多人
        Offstage(
          offstage: _lastContact.idstr != user.idstr,
          child: Container(
            width: double.infinity,
            height: ScreenUtil.getInstance().setHeight(150.0),
            alignment: Alignment.center,
            child: Text(
              _contactsCount,
              style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setSp(48.0),
                  color: Style.sTextColor),
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
    void Function(BuildContext context) onTap,
    bool needSlidable = false,
  }) {
    final double iconWH = ScreenUtil.getInstance().setWidth(123.0);
    // 头部分
    Widget leading = Padding(
        padding:
            EdgeInsets.only(right: ScreenUtil.getInstance().setWidth(39.0)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: isNetwork
              ? CachedNetworkImage(
                  imageUrl: icon,
                  width: iconWH,
                  height: iconWH,
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return Image.asset(
                      Constant.assetsImagesDefault + 'DefaultHead_48x48.png',
                      width: iconWH,
                      height: iconWH,
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Image.asset(
                      Constant.assetsImagesDefault + 'DefaultHead_48x48.png',
                      width: iconWH,
                      height: iconWH,
                    );
                  },
                )
              : Image.asset(
                  icon,
                  width: iconWH,
                  height: iconWH,
                ),
        ));
    // 中部分
    Widget middle = Padding(
      padding: EdgeInsets.only(right: Constant.pEdgeInset),
      child: Text(
        title,
        style: TextStyle(
            fontSize: ScreenUtil.getInstance().setSp(51.0),
            color: Style.pTextColor),
      ),
    );
    // 组成cell
    Widget listTile = MHListTile(
      dividerColor: Color(0xFFE6E6E6),
      onTapValue: onTap,
      allowTap: !_slideIsOpen,
      leading: leading,
      middle: middle,
      height: _itemHeight.toDouble(),
      dividerIndent: ScreenUtil.getInstance().setWidth(210.0),
    );

    // Fixed Bug： 不需要侧滑事件 尽管不需要侧滑事件，但是还是得需要 Slidable
    // if (!needSlidable) {
    //   return listTile;
    // }
    // 需要侧滑事件
    return Slidable(
      // 必须的有key
      key: Key(title),
      controller: _slidableController,
      dismissal: SlidableDismissal(
        closeOnCanceled: true,
        dragDismissible: true,
        child: SlidableDrawerDismissal(),
        onWillDismiss: (actionType) {
          return false;
        },
      ),
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.2,
      child: listTile,
      // 不需要侧滑，设为null 后期有妙用
      secondaryActions: needSlidable
          ? <Widget>[
              Container(
                color: Color(0xFFC7C7CB),
                child: Text(
                  '备注',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil.getInstance().setSp(51.0),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                alignment: Alignment.center,
              )
            ]
          : null,
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
            child: _buildContactsList(true),
          ),
        ],
      ),
    );
  }

  /// 构建联系人列表
  Widget _buildContactsList(bool defaultMode) {
    if (defaultMode) {
      return _buildDefaultIndexBarList();
    } else {
      return _buildCustomIndexBarList();
    }
  }

  /// 构建默认索引条的列表
  /// AzListView 默认提供的
  Widget _buildDefaultIndexBarList() {
    return AzListView(
      data: _contactsList,
      itemBuilder: (context, model) => _buildListItem(model),
      suspensionWidget: _buildSusWidget(_suspensionTag, isFloat: true),
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
        },
      ),
      indexHintBuilder: (context, hint) {
        return Container(
          alignment: Alignment.center,
          width: 80.0,
          height: 80.0,
          decoration:
              BoxDecoration(color: Color(0xFFC7C7CB), shape: BoxShape.circle),
          child:
              Text(hint, style: TextStyle(color: Colors.white, fontSize: 30.0)),
        );
      },
    );
  }

  // 构建自定义索引条的
  Widget _buildCustomIndexBarList() {
    return AzListView(
      data: _contactsList,
      itemBuilder: (context, model) => _buildListItem(model),
      suspensionWidget: _buildSusWidget(_suspensionTag, isFloat: true),
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
        },
      ),
      indexHintBuilder: (context, hint) {
        return Container(
          alignment: Alignment.center,
          width: 80.0,
          height: 80.0,
          decoration:
              BoxDecoration(color: Color(0xFFC7C7CB), shape: BoxShape.circle),
          child:
              Text(hint, style: TextStyle(color: Colors.white, fontSize: 30.0)),
        );
      },
    );
  }
}
