import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sekitarkita_flutter/core/provider/DeviceProvider.dart';

class Services {
  final BuildContext context;
  final MethodChannel _channel = MethodChannel("service");

  Services(this.context);

  Future<bool> startService() async {
    var resp = await _channel.invokeMethod("start");
    Provider.of<DeviceProvider>(context, listen: false).service = resp;
    return resp;
  }

  Future<bool> stopService() async {
    var resp = await _channel.invokeMethod("stop");
    Provider.of<DeviceProvider>(context, listen: false).service = !(resp ?? false);
    return resp;
  }
}
