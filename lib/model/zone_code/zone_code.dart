import 'package:azlistview/azlistview.dart';

// - [国际区号json（含国家中英文名称、简称、区号、首拼）](https://blog.csdn.net/qq_42532128/article/details/100072000)

class ZoneCode extends ISuspensionBean {
  String short;
  String name;
  String en;
  String tel;
  String pinyin;

  String tagIndex;
  String namePinyin;
  @override
  String getSuspensionTag() => tagIndex;

  ZoneCode({
    this.short,
    this.name,
    this.en,
    this.tel,
    this.pinyin,
    this.tagIndex,
    this.namePinyin,
  });

  ZoneCode.fromJson(Map<String, dynamic> json) {
    short = json['short'];
    name = json['name'];
    en = json['en'];
    tel = json['tel'];
    pinyin = json['pinyin'];
    tagIndex = json['tagIndex'];
    namePinyin = json['namePinyin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['short'] = this.short;
    data['name'] = this.name;
    data['en'] = this.en;
    data['tel'] = this.tel;
    data['pinyin'] = this.pinyin;
    data['tagIndex'] = this.tagIndex;
    data['namePinyin'] = this.namePinyin;
    return data;
  }
}
