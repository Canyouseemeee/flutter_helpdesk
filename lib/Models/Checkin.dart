// To parse this JSON data, do
//
//     final checkin = checkinFromJson(jsonString);

import 'dart:convert';

List<Checkin> checkinFromJson(String str) => List<Checkin>.from(json.decode(str).map((x) => Checkin.fromJson(x)));

String checkinToJson(List<Checkin> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Checkin {
  Checkin({
    this.checkinid,
    this.issuesid,
    this.status,
    this.createby,
    this.createdAt,
    this.updatedAt,
  });

  int checkinid;
  int issuesid;
  int status;
  String createby;
  DateTime createdAt;
  DateTime updatedAt;

  factory Checkin.fromJson(Map<String, dynamic> json) => Checkin(
    checkinid: json["Checkinid"],
    issuesid: json["Issuesid"],
    status: json["Status"],
    createby: json["Createby"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "Checkinid": checkinid,
    "Issuesid": issuesid,
    "Status": status,
    "Createby": createby,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
