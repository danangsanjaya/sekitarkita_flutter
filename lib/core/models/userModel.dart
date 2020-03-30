import 'package:sekitarkita_flutter/core/models/model.dart';

class User extends Model {
  String id;
  String label;
  String phone;
  String deviceName;
  String healthCondition;
  String firebaseToken;
  DateTime createdAt;
  DateTime updatedAt;
  bool online;

  User({
    this.id,
    this.label,
    this.phone,
    this.deviceName,
    this.healthCondition,
    this.firebaseToken,
    this.createdAt,
    this.updatedAt,
    this.online,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        label: json["label"] == null ? null : json["label"],
        phone: json["phone"] == null ? null : json["phone"],
        deviceName: json["device_name"] == null ? null : json["device_name"],
        healthCondition: json["health_condition"] == null ? null : json["health_condition"],
        firebaseToken: json["firebase_token"] == null ? null : json["firebase_token"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        online: json["online"] == null ? null : json["online"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "label": label == null ? null : label,
        "phone": phone == null ? null : phone,
        "device_name": deviceName == null ? null : deviceName,
        "health_condition": healthCondition == null ? null : healthCondition,
        "firebase_token": firebaseToken == null ? null : firebaseToken,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "online": online == null ? null : online,
      };
}
