class Picture {
  String name;
  PictureMeta small;
  PictureMeta big;

  Picture({this.name, this.small, this.big});

  Picture.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    small =
        json['small'] != null ? new PictureMeta.fromJson(json['small']) : null;
    big = json['big'] != null ? new PictureMeta.fromJson(json['big']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.small != null) {
      data['small'] = this.small.toJson();
    }
    if (this.big != null) {
      data['big'] = this.big.toJson();
    }
    return data;
  }
}

class PictureMeta {
  String url;

  PictureMeta({this.url});

  PictureMeta.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}
