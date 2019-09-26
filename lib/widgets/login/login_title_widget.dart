import 'package:flutter/material.dart';
import 'package:flutter_wechat/constant/style.dart';

class LoginTitleWidget extends StatelessWidget {
  const LoginTitleWidget({Key key, this.title}) : super(key: key);

  /// title
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 42.0),
      child: Row(
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Style.pTextColor,
              fontSize: 24.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
