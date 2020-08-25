// To parse this JSON data, do
//
//     final empty = emptyFromJson(jsonString);

import 'dart:convert';

List<Defer> DeferFromJson(String str) => List<Defer>.from(json.decode(str).map((x) => Defer.fromJson(x)));

String DeferToJson(List<Defer> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Defer {
  Defer({
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

  factory Defer.fromJson(Map<String, dynamic> json) => Defer(
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
