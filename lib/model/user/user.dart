import 'package:azlistview/azlistview.dart';

class User extends ISuspensionBean {
  String screenName;
  String idstr;
  String profileImageUrl;
  String avatarLarge;
  String coverImageUrl;
  String coverImage;
  String wechatId;
  String featureSign;
  int gender;
  String qq;
  String email;
  String phone;
  String channel;
  String zoneCode;
  List phones;
  List pictures;
  String remarks;

  /// 用于通讯录排序
  String tagIndex;
  String screenNamePinyin;
  @override
  String getSuspensionTag() => tagIndex;

  /// 构造函数
  User(
      {this.screenName,
      this.idstr,
      this.profileImageUrl,
      this.avatarLarge,
      this.coverImageUrl,
      this.coverImage,
      this.wechatId,
      this.featureSign,
      this.gender,
      this.qq,
      this.email,
      this.phone,
      this.channel,
      this.zoneCode,
      this.phones,
      this.pictures,
      this.remarks,
      this.screenNamePinyin,
      this.tagIndex});

  User.fromJson(Map<String, dynamic> json) {
    screenName = json['screen_name'];
    idstr = json['idstr'];
    profileImageUrl = json['profile_image_url'];
    avatarLarge = json['avatar_large'];
    coverImageUrl = json['coverImageUrl'];
    coverImage = json['coverImage'];
    wechatId = json['wechatId'];
    featureSign = json['featureSign'];
    gender = json['gender'];
    qq = json['qq'];
    email = json['email'];
    phone = json['phone'];
    channel = json['channel'];
    zoneCode = json['zoneCode'];
    phones = json['phones'];
    pictures = json['pictures'];
    remarks = json['remarks'];
    screenNamePinyin = json['screenNamePinyin'];
    tagIndex = json['tagIndex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['screen_name'] = this.screenName;
    data['idstr'] = this.idstr;
    data['profile_image_url'] = this.profileImageUrl;
    data['avatar_large'] = this.avatarLarge;
    data['coverImageUrl'] = this.coverImageUrl;
    data['coverImage'] = this.coverImage;
    data['wechatId'] = this.wechatId;
    data['featureSign'] = this.featureSign;
    data['gender'] = this.gender;
    data['qq'] = this.qq;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['channel'] = this.channel;
    data['zoneCode'] = this.zoneCode;
    data['phones'] = this.phones;
    data['pictures'] = this.pictures;
    data['remarks'] = this.remarks;
    data['screenNamePinyin'] = this.screenNamePinyin;
    data['tagIndex'] = this.tagIndex;
    return data;
  }
}
