import 'package:flutter/material.dart';

import 'package:flutter_wechat/views/homepage/homepage.dart';
import 'package:flutter_wechat/views/login/login_page.dart';

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
      ),
      home: login ? LoginPage() : HomePage(title: 'Flutter WeChat'),
    );
  }
}
