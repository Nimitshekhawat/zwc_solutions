// To parse this JSON data, do
//
//     final getmoduleofrole = getmoduleofroleFromJson(jsonString);

import 'dart:convert';

Getmoduleofrole getmoduleofroleFromJson(String str) => Getmoduleofrole.fromJson(json.decode(str));

String getmoduleofroleToJson(Getmoduleofrole data) => json.encode(data.toJson());

class Getmoduleofrole {
  bool status;
  List<Datum> data;

  Getmoduleofrole({
    required this.status,
    required this.data,
  });

  factory Getmoduleofrole.fromJson(Map<String, dynamic> json) => Getmoduleofrole(
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
  String userRoleId;
  String systemModuleId;
  int isAdd;
  int isEdit;
  int isDelete;
  int isView;
  DateTime lct;
  String name;

  Datum({
    required this.id,
    required this.userRoleId,
    required this.systemModuleId,
    required this.isAdd,
    required this.isEdit,
    required this.isDelete,
    required this.isView,
    required this.lct,
    required this.name,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userRoleId: json["user_role_id"],
    systemModuleId: json["system_module_id"],
    isAdd: json["is_add"],
    isEdit: json["is_edit"],
    isDelete: json["is_delete"],
    isView: json["is_view"],
    lct: DateTime.parse(json["lct"]),
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_role_id": userRoleId,
    "system_module_id": systemModuleId,
    "is_add": isAdd,
    "is_edit": isEdit,
    "is_delete": isDelete,
    "is_view": isView,
    "lct": lct.toIso8601String(),
    "name": name,
  };
}
