import 'dart:convert';

List<IssuesAppointments> appointmentsFromJson(String str) => List<IssuesAppointments>.from(json.decode(str).map((x) => IssuesAppointments.fromJson(x)));

String appointmentsToJson(List<IssuesAppointments> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IssuesAppointments {
  IssuesAppointments({
    this.appointmentsid,
    this.issuesid,
    this.date,
    this.comment,
    this.status,
    this.createby,
    this.updateby,
    this.uuid,
    this.createdAt,
    this.updatedAt,
  });

  int appointmentsid;
  int issuesid;
  DateTime date;
  String comment;
  int status;
  String createby;
  String updateby;
  String uuid;
  DateTime createdAt;
  DateTime updatedAt;

  factory IssuesAppointments.fromJson(Map<String, dynamic> json) => IssuesAppointments(
    appointmentsid: json["Appointmentsid"],
    issuesid: json["Issuesid"],
    date: DateTime.parse(json["Date"]),
    comment: json["Comment"],
    status: json["Status"],
    createby: json["Createby"],
    updateby: json["Updateby"],
    uuid: json["Uuid"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "Appointmentsid": appointmentsid,
    "Issuesid": issuesid,
    "Date": date.toIso8601String(),
    "Comment": comment,
    "Status": status,
    "Createby": createby,
    "Updateby": updateby,
    "Uuid": uuid,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
