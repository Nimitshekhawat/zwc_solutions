// To parse this JSON data, do
//
//     final getAllAreas = getAllAreasFromJson(jsonString);

import 'dart:convert';

GetAllAreas getAllAreasFromJson(String str) => GetAllAreas.fromJson(json.decode(str));

String getAllAreasToJson(GetAllAreas data) => json.encode(data.toJson());

class GetAllAreas {
  bool status;
  List<Datum> data;

  GetAllAreas({
    required this.status,
    required this.data,
  });

  factory GetAllAreas.fromJson(Map<String, dynamic> json) => GetAllAreas(
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
  String locationId;
  String locationAreaName;
  String contactPerson;
  String locationAreaContact;
  String locationAreaEmail;
  String locationAreaAddress;
  String locationAreaCity;

  Datum({
    required this.id,
    required this.locationId,
    required this.locationAreaName,
    required this.contactPerson,
    required this.locationAreaContact,
    required this.locationAreaEmail,
    required this.locationAreaAddress,
    required this.locationAreaCity,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    locationId: json["location_id"],
    locationAreaName: json["location_area_name"],
    contactPerson: json["contact_person"],
    locationAreaContact: json["location_area_contact"],
    locationAreaEmail: json["location_area_email"],
    locationAreaAddress: json["location_area_address"],
    locationAreaCity: json["location_area_city"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "location_id": locationId,
    "location_area_name": locationAreaName,
    "contact_person": contactPerson,
    "location_area_contact": locationAreaContact,
    "location_area_email": locationAreaEmail,
    "location_area_address": locationAreaAddress,
    "location_area_city": locationAreaCity,
  };
}
