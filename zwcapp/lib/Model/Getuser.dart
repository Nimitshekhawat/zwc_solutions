// To parse this JSON data, do
//
//     final getuser = getuserFromJson(jsonString);

import 'dart:convert';

Getuser getuserFromJson(String str) => Getuser.fromJson(json.decode(str));

String getuserToJson(Getuser data) => json.encode(data.toJson());

class Getuser {
  bool status;
  Data data;
  String id;

  Getuser({
    required this.status,
    required this.data,
    required this.id,
  });

  factory Getuser.fromJson(Map<String, dynamic> json) => Getuser(
    status: json["status"],
    data: Data.fromJson(json["data"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
    "id": id,
  };
}

class Data {
  String id;
  String name;
  String email;
  String phoneNum;
  String address;
  String profileImage;
  String isActive;
  String userRoleId;
  String roleName;

  Data({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNum,
    required this.address,
    required this.profileImage,
    required this.isActive,
    required this.userRoleId,
    required this.roleName,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phoneNum: json["phone_num"],
    address: json["address"],
    profileImage: json["profile_image"],
    isActive: json["is_active"],
    userRoleId: json["user_role_id"],
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
    "user_role_id": userRoleId,
    "role_name": roleName,
  };
}
