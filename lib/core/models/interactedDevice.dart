import 'package:sekitarkita_flutter/core/models/model.dart';

class InteractedDevice extends Model {
  int id;
  String deviceId;
  String anotherDevice;
  String latitude;
  String longitude;
  int speed;
  String deviceName;
  DateTime createdAt;
  DateTime updatedAt;

  InteractedDevice({
    this.id,
    this.deviceId,
    this.anotherDevice,
    this.latitude,
    this.longitude,
    this.speed,
    this.deviceName,
    this.createdAt,
    this.updatedAt,
  });

  factory InteractedDevice.fromJson(Map<String, dynamic> json) => InteractedDevice(
        id: json["id"] == null ? null : json["id"],
        deviceId: json["device_id"] == null ? null : json["device_id"],
        anotherDevice: json["another_device"] == null ? null : json["another_device"],
        latitude: json["latitude"] == null ? null : json["latitude"],
        longitude: json["longitude"] == null ? null : json["longitude"],
        speed: json["speed"] == null ? null : json["speed"],
        deviceName: json["device_name"] == null ? null : json["device_name"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "device_id": deviceId == null ? null : deviceId,
        "another_device": anotherDevice == null ? null : anotherDevice,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "speed": speed == null ? null : speed,
        "device_name": deviceName == null ? null : deviceName,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}
