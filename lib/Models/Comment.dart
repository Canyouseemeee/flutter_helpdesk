// To parse this JSON data, do
//
//     final issuesComment = issuesCommentFromJson(jsonString);

import 'dart:convert';

List<Comment> issuesCommentFromJson(String str) => List<Comment>.from(json.decode(str).map((x) => Comment.fromJson(x)));

String issuesCommentToJson(List<Comment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Comment {
  Comment({
    this.commentid,
    this.issuesid,
    this.status,
    this.type,
    this.comment,
    this.image,
    this.createby,
    this.createdAt,
    this.updatedAt,
  });

  int commentid;
  int issuesid;
  int status;
  int type;
  String comment;
  String image;
  String createby;
  DateTime createdAt;
  DateTime updatedAt;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    commentid: json["Commentid"],
    issuesid: json["Issuesid"],
    status: json["Status"],
    type: json["Type"],
    comment: json["Comment"] == null ? null : json["Comment"],
    image: json["Image"],
    createby: json["Createby"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "Commentid": commentid,
    "Issuesid": issuesid,
    "Status": status,
    "Type": type,
    "Comment": comment == null ? null : comment,
    "Image": image,
    "Createby": createby,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
