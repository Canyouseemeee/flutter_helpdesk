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
  TrackName trackName;
  SubTrackName subTrackName;
  String name;
  IssName issName;
  IspName ispName;
  Users users;
  String subject;
  String description;
  DateTime createdAt;
  DateTime updatedAt;

  factory Defer.fromJson(Map<String, dynamic> json) => Defer(
    issuesid: json["Issuesid"],
    trackName: trackNameValues.map[json["TrackName"]],
    subTrackName: subTrackNameValues.map[json["SubTrackName"]],
    name: json["Name"],
    issName: issNameValues.map[json["ISSName"]],
    ispName: ispNameValues.map[json["ISPName"]],
    users: usersValues.map[json["Users"]],
    subject: json["Subject"],
    description: json["Description"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "Issuesid": issuesid,
    "TrackName": trackNameValues.reverse[trackName],
    "SubTrackName": subTrackNameValues.reverse[subTrackName],
    "Name": name,
    "ISSName": issNameValues.reverse[issName],
    "ISPName": ispNameValues.reverse[ispName],
    "Users": usersValues.reverse[users],
    "Subject": subject,
    "Description": description,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

enum IspName { LOW, NORMAL }

final ispNameValues = EnumValues({
  "Low": IspName.LOW,
  "Normal": IspName.NORMAL
});

enum IssName { Defer }

final issNameValues = EnumValues({
  "Defer": IssName.Defer
});

enum SubTrackName { INSTALL, MOVE, FIX, OTHER }

final subTrackNameValues = EnumValues({
  "Fix": SubTrackName.FIX,
  "Install": SubTrackName.INSTALL,
  "Move": SubTrackName.MOVE,
  "Other": SubTrackName.OTHER
});

enum TrackName { SW, HW }

final trackNameValues = EnumValues({
  "HW": TrackName.HW,
  "SW": TrackName.SW
});

enum Users { ADMIN, BANK }

final usersValues = EnumValues({
  "Admin": Users.ADMIN,
  "Bank": Users.BANK
});

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
