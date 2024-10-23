// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  bool status;
  Data data;

  ProfileModel({
    required this.status,
    required this.data,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  String name;
  String email;
  String phoneNum;
  String address;
  String isActive;
  String profileImage;
  DateTime lct;
  dynamic firebaseToken;

  Data({
    required this.name,
    required this.email,
    required this.phoneNum,
    required this.address,
    required this.isActive,
    required this.profileImage,
    required this.lct,
    required this.firebaseToken,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    name: json["name"],
    email: json["email"],
    phoneNum: json["phone_num"],
    address: json["address"],
    isActive: json["is_active"],
    profileImage: json["profile_image"],
    lct: DateTime.parse(json["lct"]),
    firebaseToken: json["firebase_token"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phone_num": phoneNum,
    "address": address,
    "is_active": isActive,
    "profile_image": profileImage,
    "lct": lct.toIso8601String(),
    "firebase_token": firebaseToken,
  };
}
