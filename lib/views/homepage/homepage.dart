import 'package:flutter/material.dart';
import 'package:flutter_wechat/views/mainframe/mainframe.dart';
import 'package:flutter_wechat/views/contacts/contacts.dart';
import 'package:flutter_wechat/views/discover/discover.dart';
import 'package:flutter_wechat/views/profile/profile.dart';

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

class _HomePageState extends State<HomePage> {
  static List tabData = [
    _TabBarItem('微信', 'assets/images/tabbar_mainframe_25x23.png',
        'assets/images/tabbar_mainframeHL_25x23.png'),
    _TabBarItem('通讯录', 'assets/images/tabbar_contacts_27x23.png',
        'assets/images/tabbar_contactsHL_27x23.png'),
    _TabBarItem('发现', 'assets/images/tabbar_discover_23x23.png',
        'assets/images/tabbar_discoverHL_23x23.png'),
    _TabBarItem('我', 'assets/images/tabbar_me_23x23.png',
        'assets/images/tabbar_meHL_23x23.png')
  ];

  String appBarTitle = "微信";
  // tabData[0].title;
  List<Widget> list = List();
  int _currentIndex = 0;
  List<BottomNavigationBarItem> myTabs = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < tabData.length; i++) {
      final item = tabData[i];
      myTabs.add(BottomNavigationBarItem(
        icon: Image.asset(
          item.image,
          width: 25.0,
          height: 23.0,
        ),
        activeIcon: Image.asset(
          item.selectedImage,
          width: 25.0,
          height: 23.0,
        ),
        title: Text(
          item.title,
          // Fixed Bug: 这个只需要设置字体大小即可，颜色不要设置
          style: TextStyle(fontSize: 10.0),
        ),
      ));
    }
    list..add(MainFrame())..add(Contacts())..add(Discover())..add(Profile());
  }

  @override
  void dispose() {
    super.dispose();
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

  //  AppBar(
  //       // Here we take the value from the HomePage object that was created by
  //       // the App.build method, and use it to set our appbar title.
  //       title: Text(appBarTitle),
  //     )
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: null,
      body: list[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: myTabs,
        //高亮  被点击高亮
        currentIndex: _currentIndex,
        //修改 页面
        onTap: _itemTapped,
        //fixed：固定
        type: BottomNavigationBarType.fixed,
        // item选中颜色
        selectedItemColor: Color(0xFF57be6a),
        // item非选中
        unselectedItemColor: Color(0xFF191919),
      ),
    );
  }
}
