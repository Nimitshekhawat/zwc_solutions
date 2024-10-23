// To parse this JSON data, do
//
//     final allUsers = allUsersFromJson(jsonString);

import 'dart:convert';

AllUsers allUsersFromJson(String str) => AllUsers.fromJson(json.decode(str));

String allUsersToJson(AllUsers data) => json.encode(data.toJson());

class AllUsers {
  bool status;
  List<Datum> data;

  AllUsers({
    required this.status,
    required this.data,
  });

  factory AllUsers.fromJson(Map<String, dynamic> json) => AllUsers(
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
  String email;
  String phoneNum;
  String address;
  String profileImage;
  String isActive;
  String roleName;

  Datum({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNum,
    required this.address,
    required this.profileImage,
    required this.isActive,
    required this.roleName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phoneNum: json["phone_num"],
    address: json["address"],
    profileImage: json["profile_image"],
    isActive: json["is_active"],
    roleName: json["role_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone_num": phoneNum,
    "address": address,
    "profile_image": profileImage,
    "is_active": isActive,
    "role_name": roleName,
  };
}
