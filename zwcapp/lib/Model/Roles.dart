// To parse this JSON data, do
//
//     final roles = rolesFromJson(jsonString);

import 'dart:convert';

Roles rolesFromJson(String str) => Roles.fromJson(json.decode(str));

String rolesToJson(Roles data) => json.encode(data.toJson());

class Roles {
  bool status;
  List<Datum> data;

  Roles({
    required this.status,
    required this.data,
  });

  factory Roles.fromJson(Map<String, dynamic> json) => Roles(
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
  String roleName;
  String isDefault;

  Datum({
    required this.id,
    required this.roleName,
    required this.isDefault,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    roleName: json["role_name"],
    isDefault: json["is_default"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "role_name": roleName,
    "is_default": isDefault,
  };
}
