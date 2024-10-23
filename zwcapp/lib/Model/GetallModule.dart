// To parse this JSON data, do
//
//     final getallmodule = getallmoduleFromJson(jsonString);

import 'dart:convert';

Getallmodule getallmoduleFromJson(String str) => Getallmodule.fromJson(json.decode(str));

String getallmoduleToJson(Getallmodule data) => json.encode(data.toJson());

class Getallmodule {
  bool status;
  List<Datum> data;

  Getallmodule({
    required this.status,
    required this.data,
  });

  factory Getallmodule.fromJson(Map<String, dynamic> json) => Getallmodule(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  String name;
  String isEnabled;

  Datum({
    required this.id,
    required this.name,
    required this.isEnabled,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    isEnabled: json["is_enabled"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "is_enabled": isEnabled,
  };
}
