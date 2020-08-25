// To parse this JSON data, do
//
//     final empty = emptyFromJson(jsonString);

import 'dart:convert';

List<New> NewFromJson(String str) => List<New>.from(json.decode(str).map((x) => New.fromJson(x)));

String NewToJson(List<New> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class New {
  New({
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

  factory New.fromJson(Map<String, dynamic> json) => New(
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
