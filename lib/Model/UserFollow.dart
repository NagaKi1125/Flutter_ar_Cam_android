class UserFollow {
  List<Follow> data;

  UserFollow({this.data});

  UserFollow.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Follow>();
      json['data'].forEach((v) {
        data.add(new Follow.fromJson(v));
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

class Follow {
  String follower;
  String follow;
  String when;

  Follow({this.follower, this.follow, this.when});

  Follow.fromJson(Map<String, dynamic> json) {
    follower = json['follower'];
    follow = json['follow'];
    when = json['when'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['follower'] = this.follower;
    data['follow'] = this.follow;
    data['when'] = this.when;
    return data;
  }
}
