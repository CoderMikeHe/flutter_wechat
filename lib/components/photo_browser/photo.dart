import 'package:flutter/widgets.dart';

class Photo {
  /// tag
  String tag;

  /// url
  String url;

  /// 是否本地图片
  bool isLocal;

  /// 构造函数
  Photo({@required this.url, this.tag, this.isLocal = false});

  Photo.fromJson(Map<String, dynamic> json) {
    tag = json['tag'];
    url = json['url'];
    isLocal = json['isLocal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tag'] = this.tag;
    data['url'] = this.url;
    data['isLocal'] = this.isLocal;
    return data;
  }
}
