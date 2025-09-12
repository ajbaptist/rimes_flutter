// To parse this JSON data, do
//
//     final anayticsModel = anayticsModelFromJson(jsonString);

import 'dart:convert';

AnayticsModel anayticsModelFromJson(String str) =>
    AnayticsModel.fromJson(json.decode(str));

String anayticsModelToJson(AnayticsModel data) => json.encode(data.toJson());

class AnayticsModel {
  Letters letters;
  String lastUpdated;
  int totalUsers;
  List<User> users;

  AnayticsModel({
    required this.letters,
    required this.lastUpdated,
    required this.totalUsers,
    required this.users,
  });

  factory AnayticsModel.fromJson(Map<String, dynamic> json) => AnayticsModel(
        letters: Letters.fromJson(json["letters"]),
        lastUpdated: json["lastUpdated"],
        totalUsers: json["totalUsers"],
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "letters": letters.toJson(),
        "lastUpdated": lastUpdated,
        "totalUsers": totalUsers,
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
      };
}

class Letters {
  int r;
  int i;
  int m;
  int e;
  int s;

  Letters({
    required this.r,
    required this.i,
    required this.m,
    required this.e,
    required this.s,
  });

  factory Letters.fromJson(Map<String, dynamic> json) => Letters(
        r: json["r"],
        i: json["i"],
        m: json["m"],
        e: json["e"],
        s: json["s"],
      );

  Map<String, dynamic> toJson() => {
        "r": r,
        "i": i,
        "m": m,
        "e": e,
        "s": s,
      };
}

class User {
  String id;
  String username;
  String email;

  User({
    required this.id,
    required this.username,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        username: json["username"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "email": email,
      };
}
