import 'package:flutter/material.dart';

class CurrentLoginPage extends StatefulWidget {
  CurrentLoginPage({Key key}) : super(key: key);

  _CurrentLoginPageState createState() => _CurrentLoginPageState();
}

class _CurrentLoginPageState extends State<CurrentLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '登陆',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
      body: Container(
        child: Center(
          child: Text('登陆'),
        ),
      ),
    );
  }
}
