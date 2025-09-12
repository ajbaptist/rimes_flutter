// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String username;
  String email;
  int totalPosts;
  List<Post> posts;
  List<PostingFrequency> postingFrequency;

  UserModel({
    required this.username,
    required this.email,
    required this.totalPosts,
    required this.posts,
    required this.postingFrequency,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        username: json["username"],
        email: json["email"],
        totalPosts: json["totalPosts"],
        posts: List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
        postingFrequency: List<PostingFrequency>.from(
            json["postingFrequency"].map((x) => PostingFrequency.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "totalPosts": totalPosts,
        "posts": List<dynamic>.from(posts.map((x) => x.toJson())),
        "postingFrequency":
            List<dynamic>.from(postingFrequency.map((x) => x.toJson())),
      };
}

class PostingFrequency {
  DateTime date;
  int count;

  PostingFrequency({
    required this.date,
    required this.count,
  });

  factory PostingFrequency.fromJson(Map<String, dynamic> json) =>
      PostingFrequency(
        date: DateTime.parse(json["date"]),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "count": count,
      };
}

class Post {
  String id;
  String title;
  String body;
  DateTime createdAt;

  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["_id"],
        title: json["title"],
        body: json["body"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "body": body,
        "createdAt": createdAt.toIso8601String(),
      };
}
