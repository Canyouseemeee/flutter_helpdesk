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
    this.issName,
    this.ispName,
    this.users,
    this.subject,
    this.updatedAt,
  });

  int issuesid;
  String trackName;
  String issName;
  String ispName;
  String users;
  String subject;
  DateTime updatedAt;

  factory Closed.fromJson(Map<String, dynamic> json) => Closed(
    issuesid: json["Issuesid"],
    trackName: json["TrackName"],
    issName: json["ISSName"],
    ispName: json["ISPName"],
    users: json["Users"],
    subject: json["Subject"],
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "Issuesid": issuesid,
    "TrackName": trackName,
    "ISSName": issName,
    "ISPName": ispName,
    "Users": users,
    "Subject": subject,
    "updated_at": updatedAt.toIso8601String(),
  };
}
