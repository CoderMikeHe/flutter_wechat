import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_wechat/views/homepage/homepage.dart';
import 'package:flutter_wechat/views/login/login_page.dart';

import 'package:flutter_wechat/widgets/alert_dialog/mh_alert_dialog.dart';
import 'package:flutter_wechat/widgets/loading_dialog/LoadingDialog.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final login = true;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      home: login ? LoginPage() : HomePage(title: 'Flutter WeChat'),
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
