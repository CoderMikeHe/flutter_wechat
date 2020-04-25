import 'package:flutter/material.dart';
import 'package:azlistview/azlistview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';

import 'package:flutter_wechat/model/user/user.dart';
import 'package:flutter_wechat/utils/service/contacts_service.dart';

import 'package:flutter_wechat/routers/fluro_navigator.dart';
import 'package:flutter_wechat/views/contacts/contacts_router.dart';

import 'package:flutter_wechat/components/list_tile/mh_list_tile.dart';
import 'package:flutter_wechat/components/search_bar/search_bar.dart';
import 'package:flutter_wechat/components/index_bar/mh_index_bar.dart';
import 'package:flutter_wechat/widgets/mainframe/search_content.dart';

import 'package:flutter_wechat/components/app_bar/mh_app_bar.dart';

import 'package:flutter_wechat/providers/tab_bar_provider.dart';

// Standard iOS 10 tab bar height.
const double _kTabBarHeight = 50.0;

/// 用作测试用
const List<String> INDEX_DATA_0 = ['★', '♀', '↑', '@', 'A', 'B', 'C', 'D'];
const List<String> INDEX_DATA_1 = ['E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'];
const List<String> INDEX_DATA_2 = ['M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T'];
const List<String> INDEX_DATA_3 = ['U', 'V', 'W', 'X', 'Y', 'Z', '#', '↓'];
const List<String> IGNORE_TAGS = [];

/// 是否使用自定义IndexBar
const bool USE_CUSTOM_BAR = true;

/// 是否使用自定义IndexBar 的Builder Mode  条件： USE_CUSTOM_BAR = true
const bool USE_CUSTOM_BAR_BUILDER = true;

class ContactsPage extends StatefulWidget {
  ContactsPage({Key key}) : super(key: key);

  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with AutomaticKeepAliveClientMixin {
  /// 联系人列表
  List<User> _contactsList = [];

  /// 悬浮view 高度 向上取整
  int _suspensionHeight =
      (ScreenUtil.getInstance().setHeight(99.0) as double).ceil();

  /// 每个item 高度 向上取整
  int _itemHeight =
      (ScreenUtil.getInstance().setHeight(168.0) as double).ceil();

  /// 标签名
  String _suspensionTag = "";

  /// 联系人总数
  String _contactsCount = '';

  /// 最后一个联系人
  User _lastContact;

  // 侧滑controller
  SlidableController _slidableController;
  // 是否展开
  bool _slideIsOpen = false;

  // 记录slidable cxt
  Map<String, BuildContext> _slidableCxtMap = Map();

  // 滚动
  ScrollController _scrollController;

  /// 是否展示搜索页
  bool _showSearch = false;

  /// 动画时间 0 无动画
  int _duration = 0;

  ///
  @override
  bool get wantKeepAlive => true;

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
    // 初始化滚动条
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  // 监听事件
  void _handleSlideAnimationChanged(Animation<double> slideAnimation) {}
  void _handleSlideIsOpenChanged(bool isOpen) {
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
      _suspensionTag = '♀';
    });
  }

  /// 索引标签被点击
  void _onSusTagChanged(String tag) {
    setState(() {
      _suspensionTag = tag;
    });
  }

  /// 关闭slidable
  void _closeSlidable() {
    // 容错处理
    if (!_slideIsOpen) return;

    // 方案三：
    _slidableController.activeState?.close();

    // 方案二：
    // final cxts = _slidableCxtMap.values.toList();
    // final len = cxts.length;
    // for (var i = 0; i < len; i++) {
    //   final value = cxts[i];
    //   if (Slidable.of(value)?.renderingMode != SlidableRenderingMode.none) {
    //     // 关掉上一个
    //     Slidable.of(value)?.close();
    //     return;
    //   }
    // }
  }

  /// 构建头部
  Widget _buildHeader() {
    return Column(
      children: <Widget>[
        SearchBar(
          onEdit: () {
            //
            print('edit action ....');
            // 隐藏底部的TabBar
            Provider.of<TabBarProvider>(context, listen: false).setHidden(true);
            setState(() {
              _showSearch = true;
              _duration = 300;
            });
          },
          onCancel: () {
            print('cancel action ....');
            // 显示底部的TabBar
            Provider.of<TabBarProvider>(context, listen: false)
                .setHidden(false);
            setState(() {
              _showSearch = false;
              _duration = 300;
            });
          },
        ),
        _buildItem(
          Constant.assetsImagesContacts + 'plugins_FriendNotify_36x36.png',
          '新的朋友',
          false,
          onTap: (_) {
            // 关掉侧滑
            _closeSlidable();
            // 下钻
          },
        ),
        _buildItem(
          Constant.assetsImagesContacts + 'add_friend_icon_addgroup_36x36.png',
          '群聊',
          false,
          onTap: (_) {
            // 关掉侧滑
            _closeSlidable();
          },
        ),
        _buildItem(
          Constant.assetsImagesContacts + 'Contact_icon_ContactTag_36x36.png',
          '标签',
          false,
          onTap: (_) {
            // 关掉侧滑
            _closeSlidable();
          },
        ),
        _buildItem(
          Constant.assetsImagesContacts + 'add_friend_icon_offical_36x36.png',
          '公众号',
          false,
          onTap: (_) {
            // 关掉侧滑
            _closeSlidable();
          },
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
                  // 没有侧滑���开项 就直接下钻
                  if (!_slideIsOpen) {
                    NavigatorUtils.push(cxt,
                        '${ContactsRouter.contactInfoPage}?idstr=${user.idstr}');
                    return;
                  }

                  // 下钻联系人信息
                  if (Slidable.of(cxt)?.renderingMode ==
                      SlidableRenderingMode.none) {
                    // 方案一： 针对cell点击 和下钻容易处理  但是一但 点击导航栏上的 添加联系人按钮 ，因为获取不到 cxt 而力不从心
                    // 细节：这里由于 SlideActionType.primary 对应 actions 为空，所以虽然看似展开空，目的就是关闭 上一个打开的 secondary action
                    // Slidable.of(cxt)?.open(actionType: SlideActionType.primary);
                    // 上面的虽然打开了一个空的 但是系统还是会认为是 打开的 也就是 _slideIsOpen = true
                    // 手动设置为false
                    // _slideIsOpen = false;

                    // 方案二： 每次生�����一个 cell ,就用 Map[key] = cxt 记录起来，特别注意，这里用Map 而不是 List or Set
                    // 关闭上一个侧滑
                    _closeSlidable();

                    // 方案三： 直接拿这个activaState 注：已经封装到了 _closeSlidable
                    // _slidableController.activeState?.close();

                    // 下钻
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
    final double iconWH = ScreenUtil.getInstance().setWidth(120.0);
    // 头部分
    Widget leading = Padding(
      padding: EdgeInsets.only(right: ScreenUtil.getInstance().setWidth(39.0)),
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
      ),
    );
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
      allowTap: !_slideIsOpen || !needSlidable,
      leading: leading,
      middle: middle,
      height: _itemHeight.toDouble(),
      dividerIndent: ScreenUtil.getInstance().setWidth(208.0),
      callbackContext: needSlidable
          ? (BuildContext cxt) {
              _slidableCxtMap[title] = cxt;
            }
          : null,
    );

    // 头部是不需要侧滑的
    if (!needSlidable) {
      return listTile;
    }
    // 需要侧滑事件
    return Slidable(
      // 必须的有key
      key: Key(title),
      controller: _slidableController,
      dismissal: SlidableDismissal(
        closeOnCanceled: false,
        dragDismissible: true,
        child: SlidableDrawerDismissal(),
        onWillDismiss: (actionType) {
          print('🔥🔥🔥 $title');
          return false;
        },
        onDismissed: (_) {
          print('🔥🔥🔥 xx $title');
        },
      ),
      actionPane: SlidableScrollActionPane(),
      actionExtentRatio: 0.2,
      child: listTile,
      // 不需要侧滑，设为null 后期有妙用
      secondaryActions: <Widget>[
        GestureDetector(
          child: Container(
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
          ),
          onTap: () {
            print('object');
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // 这个是固定住的AppBar
      // appBar: AppBar(
      //   title: Text('通讯录'),
      //   actions: <Widget>[
      //     IconButton(
      //       icon: new SvgPicture.asset(
      //         Constant.assetsImagesContacts + 'icons_outlined_add-friends.svg',
      //         color: Color(0xFF181818),
      //       ),
      //       onPressed: () {
      //         // 关掉侧滑
      //         _closeSlidable();
      //         NavigatorUtils.push(context, ContactsRouter.addFriendPage);
      //       },
      //     )
      //   ],
      // ),
      // body: Column(
      //   children: <Widget>[
      //     Expanded(
      //       flex: 1,
      //       child: _buildContactsList(defaultMode: false),
      //     ),
      //   ],
      // ),
      // body: _buildContactsList(defaultMode: !USE_CUSTOM_BAR),

      // 下面是非固定住的bar
      body: _buildChildWidget(),
    );
  }

  /// ✨✨✨✨✨✨✨ UI ✨✨✨✨✨✨✨
  /// 构建子部件
  Widget _buildChildWidget() {
    return Container(
      constraints: BoxConstraints.expand(),
      color: Style.pBackgroundColor,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          // 导航栏
          AnimatedPositioned(
            key: Key('bar'),
            top: _showSearch
                ? (-kToolbarHeight - ScreenUtil.statusBarHeight)
                : 0,
            left: 0,
            right: 0,
            child: MHAppBar(
              title: Text('通讯录'),
              actions: <Widget>[
                IconButton(
                  icon: new SvgPicture.asset(
                    Constant.assetsImagesContacts +
                        'icons_outlined_add-friends.svg',
                    color: Color(0xFF181818),
                  ),
                  onPressed: () {
                    // 关闭上一个侧滑
                    _closeSlidable();
                    NavigatorUtils.push(context, ContactsRouter.addFriendPage);
                  },
                )
              ],
            ),
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: _duration),
          ),
          // 内容页
          AnimatedPositioned(
            key: Key('list'),
            top: _showSearch ? -kToolbarHeight : 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                  top: kToolbarHeight + ScreenUtil.statusBarHeight),
              child: _buildContactsList(defaultMode: !USE_CUSTOM_BAR),
              height: ScreenUtil.screenHeightDp - _kTabBarHeight,
            ),
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: _duration),
            onEnd: () {},
          ),
          // 搜索内容页
          Positioned(
            top: ScreenUtil.statusBarHeight + 56,
            left: 0,
            right: 0,
            height: ScreenUtil.screenHeightDp - ScreenUtil.statusBarHeight - 56,
            child: Offstage(
              offstage: !_showSearch,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: _duration),
                child: SearchContent(),
                curve: Curves.easeInOut,
                opacity: _showSearch ? 1.0 : .0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建联系人列表
  /// [defaultMode] 是否使用默认的IndexBar
  Widget _buildContactsList({bool defaultMode = false}) {
    if (defaultMode) {
      return _buildDefaultIndexBarList();
    } else {
      // 自定义IndexBar
      // builderMode 是否启用 builder 这种模式来 构建 tag 和 hint
      return _buildCustomIndexBarList(builderMode: USE_CUSTOM_BAR_BUILDER);
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
  Widget _buildCustomIndexBarList({bool builderMode = true}) {
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
      // 隐藏默认提供的
      showIndexHint: false,
      indexBarBuilder: (context, tagList, onTouch) {
        if (builderMode) {
          return _buildCustomIndexBarByBuilder(context, tagList, onTouch);
        } else {
          return _buildCustomIndexBarByDefault(context, tagList, onTouch);
        }
      },
    );
  }

  /// 构建自定义IndexBar by default
  Widget _buildCustomIndexBarByDefault(BuildContext context,
      List<String> tagList, IndexBarTouchCallback onTouch) {
    return MHIndexBar(
      data: tagList,
      tag: _suspensionTag,
      hintOffsetX: -80,
      ignoreTags: ['♀'],
      // selectedTagColor: Colors.red,
      mapTag: {
        "♀": new SvgPicture.asset(
          Constant.assetsImagesSearch + 'icons_filled_search.svg',
          color: Color(0xFF555555),
          width: 12,
          height: 12,
        ),
      },
      mapSelTag: {
        "♀": new SvgPicture.asset(
          Constant.assetsImagesSearch + 'icons_filled_search.svg',
          color: Color(0xFFFFFFFF),
          width: 12,
          height: 12,
        ),
      },
      mapHintTag: {
        "♀": new SvgPicture.asset(
          Constant.assetsImagesSearch + 'icons_filled_search.svg',
          color: Colors.white70,
          width: 30,
          height: 30,
        ),
      },
      onTouch: onTouch,
    );
  }

  /// 🔥🔥🔥 构建自定义IndexBar by builder  使用Builder的形式控件 更加强大 更高定制度
  Widget _buildCustomIndexBarByBuilder(BuildContext context,
      List<String> tagList, IndexBarTouchCallback onTouch) {
    return MHIndexBar(
      data: tagList,
      tag: _suspensionTag,
      onTouch: onTouch,
      indexBarTagBuilder: (context, tag, indexModel) {
        return _buildIndexBarTagWidget(context, tag, indexModel);
      },
      indexBarHintBuilder: (context, tag, indexModel) {
        return _buildIndexBarHintWidget(context, tag, indexModel);
      },
    );
  }

  /// 构建tag
  Widget _buildIndexBarTagWidget(
      BuildContext context, String tag, IndexBarDetails indexModel) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _fetchColor(tag, indexModel),
        borderRadius: BorderRadius.circular(7),
      ),
      child: _buildTagWidget(tag, indexModel),
      width: 14.0,
      height: 14.0,
    );
  }

  /// 获取背景色
  Color _fetchColor(String tag, IndexBarDetails indexModel) {
    Color color;
    if (INDEX_DATA_0.indexOf(tag) != -1) {
      // 灰
      // color = Color(0xFFC9C9C9);
      // 黄
      color = Color(0xFFFFC300);
    } else if (INDEX_DATA_1.indexOf(tag) != -1) {
      // 红
      color = Color(0xFFFA5151);
    } else if (INDEX_DATA_2.indexOf(tag) != -1) {
      // 绿
      color = Color(0xFF07C160);
    } else {
      // 蓝
      color = Color(0xFF10AEFF);
    }
    if (indexModel.tag == tag) {
      return IGNORE_TAGS.indexOf(tag) != -1 ? Colors.transparent : color;
    }
    return Colors.transparent;
  }

  /// 构建某个tag
  Widget _buildTagWidget(String tag, IndexBarDetails indexModel) {
    Color textColor;
    Color selTextColor;
    if (INDEX_DATA_0.indexOf(tag) != -1) {
      // 浅黑 Color(0xFF555555)
      textColor = Color(0xFFFFC300);
      selTextColor = Colors.white;
    } else if (INDEX_DATA_1.indexOf(tag) != -1) {
      // 红色
      textColor = Color(0xFFFA5151);
      selTextColor = Colors.white;
    } else if (INDEX_DATA_2.indexOf(tag) != -1) {
      // 绿色
      textColor = Color(0xFF07C160);
      selTextColor = Colors.white;
    } else {
      // 蓝色
      textColor = Color(0xFF10AEFF);
      selTextColor = Colors.white;
    }
    // 当前选中的tag, 也就是高亮的场景
    if (indexModel.tag == tag) {
      final isIgnore = IGNORE_TAGS.indexOf(tag) != -1;
      // 如果是忽略
      if (isIgnore) {
        // 你可以针对某个标签 做更加高的定制
        if (tag == '♀') {
          // 返回映射的部件
          return new SvgPicture.asset(
            Constant.assetsImagesSearch + 'icons_filled_search.svg',
            color: Color(0xFFFFC300),
            width: 12,
            height: 12,
          );
        } else {
          // 返回默认的部件
          return Text(
            tag,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.0,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          );
        }
      } else {
        // 不忽略，则显示高��组件
        if (tag == '♀') {
          // 返回映射高亮的部件
          return new SvgPicture.asset(
            Constant.assetsImagesSearch + 'icons_filled_search.svg',
            color: selTextColor,
            width: 12,
            height: 12,
          );
        } else {
          // 返回默认的部件
          return Text(
            tag,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.0,
              color: selTextColor,
              fontWeight: FontWeight.w500,
            ),
          );
        }
      }
    }
    // 非高亮场景
    // 获取mapTag
    if (tag == '♀') {
      // 返回映射的部件
      return new SvgPicture.asset(
        Constant.assetsImagesSearch + 'icons_filled_search.svg',
        color: Color(0xFF555555),
        width: 12,
        height: 12,
      );
    } else {
      // 返回默认的部件

      return Text(
        tag,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10.0,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      );
    }
  }

  /// 构建Hint
  Widget _buildIndexBarHintWidget(
      BuildContext context, String tag, IndexBarDetails indexModel) {
    // 图片名
    String imageName;
    if (INDEX_DATA_0.indexOf(tag) != -1) {
      // 浅黑
      imageName = 'contact_index_bar_bubble_0.png';
    } else if (INDEX_DATA_1.indexOf(tag) != -1) {
      // 红色
      imageName = 'contact_index_bar_bubble_1.png';
    } else if (INDEX_DATA_2.indexOf(tag) != -1) {
      // 绿色
      imageName = 'contact_index_bar_bubble_2.png';
    } else {
      // 蓝色
      imageName = 'contact_index_bar_bubble_3.png';
    }
    return Positioned(
      left: -80,
      top: -(64 - 16) * 0.5,
      child: Offstage(
        offstage: _fetchOffstage(tag, indexModel),
        child: Container(
          width: 64.0,
          height: 64.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/contacts/$imageName'),
              fit: BoxFit.contain,
            ),
          ),
          alignment: Alignment(-0.25, 0.0),
          child: _buildHintChildWidget(tag, indexModel),
        ),
      ),
    );
  }

  /// 构建某个hint中子部件
  Widget _buildHintChildWidget(String tag, IndexBarDetails indexModel) {
    if (tag == '♀') {
      // 返回映射高亮的部件
      return new SvgPicture.asset(
        Constant.assetsImagesSearch + 'icons_filled_search.svg',
        color: Colors.white70,
        width: 30,
        height: 30,
      );
    }
    return Text(
      tag,
      style: TextStyle(
        color: Colors.white70,
        fontSize: 30.0,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  // 获取Offstage 是否隐居幕后
  bool _fetchOffstage(String tag, IndexBarDetails indexModel) {
    if (indexModel.tag == tag) {
      final List<String> ignoreTags = [];
      return ignoreTags.indexOf(tag) != -1 ? true : !indexModel.isTouchDown;
    }
    return true;
  }
}
