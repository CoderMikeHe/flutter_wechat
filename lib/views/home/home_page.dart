import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';
import 'package:flutter_wechat/providers/tab_bar_provider.dart';

import 'package:flutter_wechat/views/mainframe/mainframe_page.dart';
import 'package:flutter_wechat/views/contacts/contacts_page.dart';
import 'package:flutter_wechat/views/discover/discover_page.dart';
import 'package:flutter_wechat/views/profile/profile_page.dart';
import 'package:provider/provider.dart';

class _TabBarItem {
  String title, image, selectedImage;
  _TabBarItem(this.title, this.image, this.selectedImage);
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  static List tabData = [
    // 7.0.0-
    // _TabBarItem(
    //     '微信',
    //     Constant.assetsImagesTabbar + 'tabbar_mainframe_25x23.png',
    //     Constant.assetsImagesTabbar + 'tabbar_mainframeHL_25x23.png'),
    // _TabBarItem(
    //     '通讯录',
    //     Constant.assetsImagesTabbar + 'tabbar_contacts_27x23.png',
    //     Constant.assetsImagesTabbar + 'tabbar_contactsHL_27x23.png'),
    // _TabBarItem('发现', Constant.assetsImagesTabbar + 'tabbar_discover_23x23.png',
    //     Constant.assetsImagesTabbar + 'tabbar_discoverHL_23x23.png'),
    // _TabBarItem('我', Constant.assetsImagesTabbar + 'tabbar_me_23x23.png',
    //     Constant.assetsImagesTabbar + 'tabbar_meHL_23x23.png'),

    // 7.0.0+
    _TabBarItem('微信', Constant.assetsImagesTabbar + 'icons_outlined_chats.svg',
        Constant.assetsImagesTabbar + 'icons_filled_chats.svg'),
    _TabBarItem(
        '通讯录',
        Constant.assetsImagesTabbar + 'icons_outlined_contacts.svg',
        Constant.assetsImagesTabbar + 'icons_filled_contacts.svg'),
    _TabBarItem(
        '发现',
        Constant.assetsImagesTabbar + 'icons_outlined_discover.svg',
        Constant.assetsImagesTabbar + 'icons_filled_discover.svg'),
    _TabBarItem('我', Constant.assetsImagesTabbar + 'icons_outlined_me.svg',
        Constant.assetsImagesTabbar + 'icons_filled_me.svg'),
  ];

  String appBarTitle = "微信";
  List<Widget> list = List();
  int _currentIndex = 0;
  List<BottomNavigationBarItem> myTabs = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    for (int i = 0; i < tabData.length; i++) {
      final item = tabData[i];
      myTabs.add(
        BottomNavigationBarItem(
          // 7.0.0 之前版本
          // icon: Image.asset(
          //   item.image,
          //   width: 25.0,
          //   height: 23.0,
          // ),
          // activeIcon: Image.asset(
          //   item.selectedImage,
          //   width: 25.0,
          //   height: 23.0,
          // ),

          // 7.0.0 之后版本
          icon: new SvgPicture.asset(
            item.image,
          ),
          activeIcon: new SvgPicture.asset(
            item.selectedImage,
            color: Style.pTintColor,
          ),
          title: Text(
            item.title,
            textScaleFactor: 1.0,
            // Fixed Bug: 这个只需要设置字体大小即可，颜色不要设置
            style: TextStyle(
              fontSize: 10.0,
            ),
          ),
        ),
      );
    }
    list
      ..add(MainframePage())
      ..add(ContactsPage())
      ..add(DiscoverPage())
      ..add(ProfilePage());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🔥🔥 👉 ${MediaQuery.of(context).viewInsets.bottom}');
    });
  }

  void _itemTapped(int index) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _currentIndex = index;
      appBarTitle = tabData[index].title;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Consumer<TabBarProvider>(
      builder: (context, tabBarProvider, _) {
        return Scaffold(
          appBar: null,
          body: list[_currentIndex],
          // Android
          // bottomNavigationBar: BottomNavigationBar(
          //   items: myTabs,
          //   //高亮  被点击高亮
          //   currentIndex: _currentIndex,
          //   //修改 页面
          //   onTap: _itemTapped,
          //   //fixed：固定
          //   type: BottomNavigationBarType.fixed,
          //   // item选中颜色
          //   selectedItemColor: Style.pTintColor,
          //   // item非选中
          //   unselectedItemColor: Color(0xFF191919),
          // ),
          // iOS
          bottomNavigationBar: tabBarProvider.hidden
              ? null
              : CupertinoTabBar(
                  items: myTabs,
                  onTap: _itemTapped,
                  currentIndex: _currentIndex,
                  activeColor: Style.pTintColor,
                  inactiveColor: Color(0xFF191919),
                ),
        );
      },
    );
  }
}
