class Comment {
  List<Data> data;

  Comment({this.data});

  Comment.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
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

class Data {
  int id;
  int post;
  String username;
  String comment;
  String when;

  Data({this.id, this.post, this.username, this.comment, this.when});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    post = json['post'];
    username = json['username'];
    comment = json['comment'];
    when = json['when'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post'] = this.post;
    data['username'] = this.username;
    data['comment'] = this.comment;
    data['when'] = this.when;
    return data;
  }
}
