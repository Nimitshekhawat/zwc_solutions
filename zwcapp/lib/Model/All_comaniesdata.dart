// To parse this JSON data, do
//
//     final getallcompaniesmodel = getallcompaniesmodelFromJson(jsonString);

import 'dart:convert';

Getallcompaniesmodel getallcompaniesmodelFromJson(String str) => Getallcompaniesmodel.fromJson(json.decode(str));

String getallcompaniesmodelToJson(Getallcompaniesmodel data) => json.encode(data.toJson());

class Getallcompaniesmodel {
  bool status;
  List<Datum> data;

  Getallcompaniesmodel({
    required this.status,
    required this.data,
  });

  factory Getallcompaniesmodel.fromJson(Map<String, dynamic> json) => Getallcompaniesmodel(
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
  String companyName;
  String contactPerson;
  String companyContact;
  String companyEmail;
  String companyAddress;
  String companyCity;
  String stateId;
  String state;

  Datum({
    required this.id,
    required this.companyName,
    required this.contactPerson,
    required this.companyContact,
    required this.companyEmail,
    required this.companyAddress,
    required this.companyCity,
    required this.stateId,
    required this.state,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    companyName: json["company_name"],
    contactPerson: json["contact_person"],
    companyContact: json["company_contact"],
    companyEmail: json["company_email"],
    companyAddress: json["company_address"],
    companyCity: json["company_city"],
    stateId: json["state_id"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company_name": companyName,
    "contact_person": contactPerson,
    "company_contact": companyContact,
    "company_email": companyEmail,
    "company_address": companyAddress,
    "company_city": companyCity,
    "state_id": stateId,
    "state": state,
  };
}
