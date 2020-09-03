// To parse this JSON data, do
//
//     final macAddress = macAddressFromJson(jsonString);

import 'dart:convert';

List<MacAddress> macAddressFromJson(String str) => List<MacAddress>.from(json.decode(str).map((x) => MacAddress.fromJson(x)));

String macAddressToJson(List<MacAddress> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MacAddress {
  MacAddress({
    this.macid,
    this.macAddress,
    this.createdAt,
    this.updatedAt,
  });

  int macid;
  String macAddress;
  DateTime createdAt;
  DateTime updatedAt;

  factory MacAddress.fromJson(Map<String, dynamic> json) => MacAddress(
    macid: json["Macid"],
    macAddress: json["MacAddress"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "Macid": macid,
    "MacAddress": macAddress,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
