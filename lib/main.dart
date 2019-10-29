import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:fluro/fluro.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'
    as FlutterScreenUtil;

import 'package:flutter_wechat/routers/application.dart';
import 'package:flutter_wechat/routers/routers.dart';

import 'package:flutter_wechat/views/home/home_page.dart';
import 'package:flutter_wechat/views/login/login_page.dart';

import 'package:flutter_wechat/widgets/alert_dialog/mh_alert_dialog.dart';
import 'package:flutter_wechat/widgets/loading_dialog/loading_dialog.dart';

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
    return MaterialApp(
      title: 'Flutter Demo',
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
      ),
      // home: login ? LoginPage() : HomePage(title: 'Flutter WeChat'),
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

class _HomePage0 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoButton(
        child: Text("show dialog"),
        onPressed: () {
          // _showDialog(context);
          final loading = LoadingDialog(buildContext: context);
          loading.show();
          // 延时1s执行返回
          Future.delayed(Duration(seconds: 5), () {
            loading.hide();
          });
        },
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MHAlertDialog(
          // backgroundColor: Colors.yellow,
          title: new Text('弹窗标题'),
          content: new Text('弹窗内容，告知当前状态、信息和解决方法，描述文字尽量控制在三行内'),
          actions: <Widget>[
            MHDialogAction(
              child: new Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
                print('取消');
              },
            ),
            MHDialogAction(
              child: new Text('主操作'),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop();
                print('取消');
              },
            ),
          ],
        );
      },
    );
  }
}
