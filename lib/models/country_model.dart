// To parse this JSON data, do
//
//     final countryData = countryDataFromJson(jsonString);

import 'dart:convert';

List<CountryData> countryDataFromJson(String str) => List<CountryData>.from(
    json.decode(str).map((x) => CountryData.fromJson(x)));

String countryDataToJson(List<CountryData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CountryData {
  Name name;

  CountryData({
    required this.name,
  });

  factory CountryData.fromJson(Map<String, dynamic> json) => CountryData(
        name: Name.fromJson(json["name"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name.toJson(),
      };
}

class Name {
  String common;
  String official;

  Name({
    required this.common,
    required this.official,
  });

  factory Name.fromJson(Map<String, dynamic> json) => Name(
        common: json["common"],
        official: json["official"],
      );

  Map<String, dynamic> toJson() => {
        "common": common,
        "official": official,
      };
}

class Eng {
  String official;
  String common;

  Eng({
    required this.official,
    required this.common,
  });

  factory Eng.fromJson(Map<String, dynamic> json) => Eng(
        official: json["official"],
        common: json["common"],
      );

  Map<String, dynamic> toJson() => {
        "official": official,
        "common": common,
      };
}
