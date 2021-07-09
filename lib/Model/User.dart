class User {
  int id;
  String name;
  String username;
  String email;
  String birthday;

  User({this.id, this.name, this.username, this.email, this.birthday});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    birthday = json['birthday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['birthday'] = this.birthday;
    return data;
  }
}