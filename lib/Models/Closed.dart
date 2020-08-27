// To parse this JSON data, do
//
//     final empty = emptyFromJson(jsonString);

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
    this.users,
    this.subject,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  int issuesid;
  String trackName;
  String subTrackName;
  String name;
  String issName;
  String ispName;
  String users;
  String subject;
  String description;
  DateTime createdAt;
  DateTime updatedAt;

  factory Closed.fromJson(Map<String, dynamic> json) => Closed(
    issuesid: json["Issuesid"],
    trackName: json["TrackName"],
    subTrackName: json["SubTrackName"],
    name: json["Name"],
    issName: json["ISSName"],
    ispName: json["ISPName"],
    users: json["Users"],
    subject: json["Subject"],
    description: json["Description"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "Issuesid": issuesid,
    "TrackName": trackName,
    "SubTrackName": subTrackName,
    "Name": name,
    "ISSName": issName,
    "ISPName": ispName,
    "Users": users,
    "Subject": subject,
    "Description": description,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
