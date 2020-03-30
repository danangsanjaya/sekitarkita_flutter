import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sekitarkita_flutter/core/connection/httpConnection.dart';
import 'package:sekitarkita_flutter/core/models/interactedDevice.dart';
import 'package:sekitarkita_flutter/core/models/storeDeviceModel.dart';
import 'package:sekitarkita_flutter/core/models/userModel.dart';
import 'package:sekitarkita_flutter/core/provider/DeviceProvider.dart';
import 'package:sekitarkita_flutter/core/res/environment.dart'; 

class SekitarKitaConnection extends HttpConnection {
  DeviceProvider provider;
  SekitarKitaConnection(BuildContext context) : super(null) {
    provider = Provider.of(context, listen: false);
  }

  Future<StoreDevice> storeDevice({@required String nearby, @required LocationData locationData}) async {
    var resp = await post(endpoint + "store-device", data: {
      "device_id": provider.mac,
      "nearby_device": nearby,
      "latitude": locationData.latitude,
      "longitude": locationData.longitude,
    });

    if (resp != null) {
      return StoreDevice.fromJson(resp);
    }
    return null;
  }

  Future<User> setHealthDevice({@required String status}) async {
    var resp = await post(endpoint + "set-health", data: {
      "device_id": provider.mac,
      "health": status,
    });

    if (resp != null) {
      return User.fromJson(resp["device"]);
    }
    return null;
  }

  Future<User> getUser() async {
    var resp = await post(endpoint + "me", data: {
      "device_id": provider.mac,
    });
    if (resp != null) {
      return User.fromJson(resp);
    }
    return null;
  }

  Future<List<InteractedDevice>> getDevicesHistory() async {
    var resp = await post(endpoint + "device-history", data: {
      "device_id": provider.mac,
    });
    if (resp != null) {
      if (resp["success"]) return resp["nearbies"].map((item) => InteractedDevice.fromJson(item)).toList().cast<InteractedDevice>();
    }
    return null;
  }

  Future<void> storeToken(String token) async {
    await post(endpoint + "store-firebase-token", data: {
      "device_id": provider.mac,
      "firebase_token": token,
    });
  }
}
