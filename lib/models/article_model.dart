import 'dart:convert';

class Article {
  String id;
  String title;
  String body;
  Author author;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Article({
    required this.id,
    required this.title,
    required this.body,
    required this.author,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json["_id"],
        title: json["title"],
        body: json["body"],
        author: Author.fromJson(json["author"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "body": body,
        "author": author.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "body": body,
        "author": jsonEncode(author.toJson()),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "v": v,
      };

  factory Article.fromMap(Map<String, dynamic> map) => Article(
        id: map["id"],
        title: map["title"],
        body: map["body"],
        author: Author.fromJson(jsonDecode(map["author"])),
        createdAt: DateTime.parse(map["createdAt"]),
        updatedAt: DateTime.parse(map["updatedAt"]),
        v: map["v"],
      );
}

class Author {
  String id;
  String username;

  Author({
    required this.id,
    required this.username,
  });

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: json["_id"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
      };
}
