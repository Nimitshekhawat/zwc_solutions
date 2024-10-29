// To parse this JSON data, do
//
//     final locationModel = locationModelFromJson(jsonString);

import 'dart:convert';

LocationModel locationModelFromJson(String str) => LocationModel.fromJson(json.decode(str));

String locationModelToJson(LocationModel data) => json.encode(data.toJson());

class LocationModel {
  bool status;
  List<Datum> data;

  LocationModel({
    required this.status,
    required this.data,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
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
  String companyId;
  String locationName;
  String contactPerson;
  String locationContact;
  String locationEmail;
  String locationAddress;
  String locationCity;
  String stateId;
  String industryTypeId;
  String preAuditSubmitted;
  String preCompletionPercentage;

  Datum({
    required this.id,
    required this.companyId,
    required this.locationName,
    required this.contactPerson,
    required this.locationContact,
    required this.locationEmail,
    required this.locationAddress,
    required this.locationCity,
    required this.stateId,
    required this.industryTypeId,
    required this.preAuditSubmitted,
    required this.preCompletionPercentage,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    companyId: json["company_id"],
    locationName: json["location_name"],
    contactPerson: json["contact_person"],
    locationContact: json["location_contact"],
    locationEmail: json["location_email"],
    locationAddress: json["location_address"],
    locationCity: json["location_city"],
    stateId: json["state_id"],
    industryTypeId: json["industry_type_id"],
    preAuditSubmitted: json["pre_audit_submitted"],
    preCompletionPercentage: json["pre_completion_percentage"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company_id": companyId,
    "location_name": locationName,
    "contact_person": contactPerson,
    "location_contact": locationContact,
    "location_email": locationEmail,
    "location_address": locationAddress,
    "location_city": locationCity,
    "state_id": stateId,
    "industry_type_id": industryTypeId,
    "pre_audit_submitted": preAuditSubmitted,
    "pre_completion_percentage": preCompletionPercentage,
  };
}
