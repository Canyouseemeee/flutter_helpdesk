// To parse this JSON data, do
//
//     final defer = deferFromJson(jsonString);

import 'dart:convert';

List<Defer> DeferFromJson(String str) => List<Defer>.from(json.decode(str).map((x) => Defer.fromJson(x)));

String DeferToJson(List<Defer> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Defer {
  Defer({
    this.issuesid,
    this.trackName,
    this.subTrackName,
    this.name,
    this.issName,
    this.ispName,
    this.createby,
    this.assignment,
    this.updatedby,
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
  String updatedby;
  String subject;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  String dmName;


  factory Defer.fromJson(Map<String, dynamic> json) => Defer(
    issuesid: json["Issuesid"],
    trackName: json["TrackName"],
    subTrackName: json["SubTrackName"],
    name: json["Name"],
    issName: json["ISSName"],
    ispName: json["ISPName"],
    createby: json["Createby"],
    assignment: json["Assignment"],
    updatedby: json["UpdatedBy"],
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
    "UpdatedBy": updatedby,
    "Subject": subject,
    "Description": description,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "DmName": dmName,

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
