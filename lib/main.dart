import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';

import 'package:flutter_wechat/constant/style.dart';

import 'package:flutter_wechat/routers/application.dart';
import 'package:flutter_wechat/routers/routers.dart';

import 'package:flutter_wechat/providers/tab_bar_provider.dart';
import 'package:flutter_wechat/providers/keyboard_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final Widget home;

  MyApp({this.home}) {
    final router = Router();
    Routers.configureRoutes(router);
    Application.router = router;
  }

  final login = true;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TabBarProvider()),
        ChangeNotifierProvider(create: (_) => KeyboardProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false, // 去掉Debug
        onGenerateRoute: Application.router.generator,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          // primarySwatch: Colors.blue,
          primaryColor: Color(0xFFEDEDED),
          // Fixed Bug: 系统提供的 minWidth 88.0 太宽了
          // https://www.jianshu.com/p/52b873d891f0
          buttonTheme: ButtonThemeData(minWidth: 44.0),
          //
          appBarTheme: AppBarTheme(elevation: 1),
          // 脚手架背景色
          scaffoldBackgroundColor: Style.pBackgroundColor,
        ),
        // home: login ? LoginPage() : HomePage(title: 'Flutter WeChat'),
      ),
    );
  }
}

///这个组件用来重新加载整个child Widget的。当我们需要重启APP的时候，可以使用这个方案
///https://stackoverflow.com/questions/50115311/flutter-how-to-force-an-application-restart-in-production-mode
class RestartWidget extends StatefulWidget {
  final Widget child;

  RestartWidget({Key key, @required this.child})
      : assert(child != null),
        super(key: key);

  static restartApp(BuildContext context) {
    final _RestartWidgetState state =
        context.ancestorStateOfType(const TypeMatcher<_RestartWidgetState>());
    state.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();
  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      child: widget.child,
    );
  }
}
