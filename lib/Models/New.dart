// To parse this JSON data, do
//
//     final new = newFromJson(jsonString);

import 'dart:convert';

List<New> NewFromJson(String str) => List<New>.from(json.decode(str).map((x) => New.fromJson(x)));

String NewToJson(List<New> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class New {
  New({
    this.issuesid,
    this.trackName,
    this.subTrackName,
    this.name,
    this.issName,
    this.ispName,
    this.createby,
    this.assignment,
    this.updatedBy,
    this.subject,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.dmName,
  });

  int issuesid;
  String trackName;
  String subTrackName;
  String name;
  String issName;
  String ispName;
  String createby;
  String assignment;
  String updatedBy;
  String subject;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  String dmName;

  factory New.fromJson(Map<String, dynamic> json) => New(
    issuesid: json["Issuesid"],
    trackName: json["TrackName"],
    subTrackName: json["SubTrackName"],
    name: json["Name"],
    issName: json["ISSName"],
    ispName: json["ISPName"],
    createby: json["Createby"],
    assignment: json["Assignment"],
    updatedBy: json["UpdatedBy"],
    subject: json["Subject"],
    description: json["Description"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    dmName: json["DmName"],
  );

  Map<String, dynamic> toJson() => {
    "Issuesid": issuesid,
    "TrackName": trackName,
    "SubTrackName": subTrackName,
    "Name": name,
    "ISSName": issName,
    "ISPName": ispName,
    "Createby": createby,
    "Assignment": assignment,
    "UpdatedBy": updatedBy,
    "Subject": subject,
    "Description": description,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "DmName": dmName,
  };
}
