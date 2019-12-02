import 'package:flutter_wechat/model/user/user.dart';
import 'package:flutter_wechat/model/badge/badge.dart';

// 列表消息
class Message {
  String idstr;
  List<User> users;
  String screenName;
  String createdAt;
  String text;
  Badge badge;

  /// 消息免打扰
  bool messageFree;

  Message({
    this.idstr,
    this.users,
    this.screenName,
    this.createdAt,
    this.text,
    this.badge,
    this.messageFree,
  });

  Message.fromJson(Map<String, dynamic> json) {
    idstr = json['idstr'];
    if (json['users'] != null) {
      users = new List<User>();
      json['users'].forEach((v) {
        users.add(new User.fromJson(v));
      });
    }
    screenName = json['screen_name'];
    createdAt = json['created_at'];
    text = json['text'];
    badge = json['badge'] != null ? new Badge.fromJson(json['badge']) : null;
    messageFree = json['messageFree'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idstr'] = this.idstr;
    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    data['screen_name'] = this.screenName;
    data['created_at'] = this.createdAt;
    data['text'] = this.text;
    data['messageFree'] = this.messageFree;
    if (this.badge != null) {
      data['badge'] = this.badge.toJson();
    }
    return data;
  }
}
