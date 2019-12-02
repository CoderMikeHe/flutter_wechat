// 角标
class Badge {
  String type;
  int value;
  String text;
  bool show;
  bool dot;

  Badge({this.type, this.value, this.text, this.show, this.dot});

  Badge.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
    text = json['text'];
    show = json['show'];
    dot = json['dot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['value'] = this.value;
    data['text'] = this.text;
    data['show'] = this.show;
    data['dot'] = this.dot;
    return data;
  }
}
