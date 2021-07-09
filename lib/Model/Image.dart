class Image {
  int id;
  String image;
  String created;

  Image({this.id, this.image, this.created});

  Image.fromJson(Map<String, dynamic> json) {
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