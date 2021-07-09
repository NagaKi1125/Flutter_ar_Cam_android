
class UserImage {
  List<ImageName> data;

  UserImage({this.data});

  UserImage.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<ImageName>();
      json['data'].forEach((v) {
        data.add(new ImageName.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImageName {
  int id;
  String image;
  String created;

  ImageName({this.id, this.image, this.created});

  ImageName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['created'] = this.created;
    return data;
  }
}


