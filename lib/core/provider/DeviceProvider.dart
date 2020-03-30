import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:sekitarkita_flutter/core/connection/sekitarKitaConnection.dart';
import 'package:sekitarkita_flutter/core/models/latLngModel.dart';
import 'package:sekitarkita_flutter/core/models/userModel.dart';
import 'package:sekitarkita_flutter/core/res/string.dart';
import 'package:sekitarkita_flutter/core/utils/mainUtils.dart';
import 'package:sekitarkita_flutter/core/utils/preferences.dart';

class DeviceProvider extends ChangeNotifier {
  String mac;
  String health;
  String userName;
  LatLng latlng;
  bool service = false;
  bool startServiceOnStart = false;

  DeviceProvider({this.mac, this.health, this.latlng, this.userName});

  Future<DeviceProvider> init(BuildContext context) async {
    Preferences preferences = await Preferences.init(context);
    await getLocation(context);
    health = preferences.getHealth() ?? "healthy";
    mac = preferences.getMacBluetooth();
    userName = preferences.getUserName();
    latlng = preferences.getLastLocation();
    startServiceOnStart = preferences.getServiceOnStart();

    print(startServiceOnStart);

    if (mac != null) {
      try {
        User user = await SekitarKitaConnection(context).getUser();
        if (user != null) {
          health = user.healthCondition;
          preferences.saveHealthStatus(health);
        }
      } catch (e) {}
    }

    notifyListeners();

    return DeviceProvider(mac: mac, health: health, latlng: latlng, userName: userName);
  }

  static Future<LatLng> getLocation(BuildContext context) async {
    Location location = Location();
    if (!(await location.serviceEnabled())) {
      await showMessage(context, title: perhatian, message: "Mohon aktifkan GPSmu untuk menggunakan aplikasi");
      if (!(await location.requestService())) return null;
    }
    if ((await location.hasPermission()) != PermissionStatus.granted) {
      await showMessage(context, title: perhatian, message: "Untuk pemindaian lebih akurat, Aplikasi butuh izin akses GPS mu untuk memetakan posisi saat kamu berinteraksi.");
      if ((await location.requestPermission()) != PermissionStatus.granted) return null;
    }
    LocationData latlngData = await Location.instance.getLocation();
    LatLng latlng = LatLng(latitude: latlngData.latitude, longitude: latlngData.longitude);

    (await Preferences.init(context)).saveLocation(latlng);
    return latlng;
  }
}
