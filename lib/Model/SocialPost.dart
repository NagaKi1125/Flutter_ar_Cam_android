
class SocialPost {
  int id;
  int userId;
  String username;
  Null imageId;
  String image;
  String content;
  int like;
  String createdAt;

  SocialPost(
      {this.id,
        this.userId,
        this.username,
        this.imageId,
        this.image,
        this.content,
        this.like,
        this.createdAt});

  SocialPost.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    username = json['username'];
    imageId = json['image_id'];
    image = json['image'];
    content = json['content'];
    like = json['like'];
    createdAt = json['created_at'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['username'] = this.username;
    data['image_id'] = this.imageId;
    data['image'] = this.image;
    data['content'] = this.content;
    data['like'] = this.like;
    data['created_at'] = this.createdAt;
    return data;
  }
}
