import 'package:flutter/material.dart';

import 'package:flutter_wechat/constant/constant.dart';
import 'package:flutter_wechat/constant/style.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key key,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
    this.onTap,
  }) : super(key: key);

  /// The SearchBar's internal padding.
  ///
  /// If null, `EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0)` is used.
  final EdgeInsetsGeometry contentPadding;

  /// Called when the user taps this list tile.
  ///
  /// Inoperative if [enabled] is false.
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: contentPadding ??
          EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      color: Style.pBackgroundColor,
      child: InkWell(
        child: Container(
          height: 40.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                Constant.assetsImagesSearch + 'SearchContactsBarIcon_20x20.png',
                width: 20.0,
                height: 20.0,
              ),
              SizedBox(
                width: 6.0,
              ),
              Text(
                '搜索',
                style: TextStyle(
                  color: Style.sTextColor,
                ),
              )
            ],
          ),
        ),
        onTap: onTap,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
    );
  }
}
