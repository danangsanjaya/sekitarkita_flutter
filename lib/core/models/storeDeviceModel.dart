class StoreDevice {
  bool success;
  String message;
  dynamic nearbyDevice;

  StoreDevice({
    this.success,
    this.message,
    this.nearbyDevice,
  });

  factory StoreDevice.fromJson(Map<String, dynamic> json) => StoreDevice(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        nearbyDevice: json["nearby_device"],
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "nearby_device": nearbyDevice,
      };
}
