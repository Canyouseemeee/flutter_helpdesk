// To parse this JSON data, do
//
//     final closed = closedFromJson(jsonString);

import 'dart:convert';

List<Closed> ClosedFromJson(String str) => List<Closed>.from(json.decode(str).map((x) => Closed.fromJson(x)));

String ClosedToJson(List<Closed> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Closed {
  Closed({
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
    this.closedBy,
    this.createAt,
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
  String closedBy;
  DateTime createAt;

  factory Closed.fromJson(Map<String, dynamic> json) => Closed(
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
    closedBy: json["ClosedBy"],
    createAt: DateTime.parse(json["create_at"]),
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
    "ClosedBy": closedBy,
    "create_at": createAt.toIso8601String(),
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
