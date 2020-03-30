import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sekitarkita_flutter/core/provider/DeviceProvider.dart';
import 'package:sekitarkita_flutter/core/res/warna.dart'; 
import 'package:sekitarkita_flutter/core/utils/services.dart';

import 'gui/screen/inputMacScreen.dart';
import 'gui/screen/mainScreen.dart';

main() {
  Provider.debugCheckInvalidValueType = null;
  return runApp(
    Provider(
      create: (context) => DeviceProvider(),
      child: MaterialApp(
        title: "Sekitarkita.id",
        home: Root(),
        theme: ThemeData(
          appBarTheme: AppBarTheme(textTheme: TextTheme(title: TextStyle(fontSize: 20, color: Colors.white))),
          primaryColor: primaryColor,
          accentColor: accentColor,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.light(secondary: secondaryColor, surface: Colors.grey.shade100),
          backgroundColor: Colors.white,
        ),
      ),
    ),
  );
}

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  bool _initialized = false;
  bool _ready = false;

  @override
  void didChangeDependencies() {
    _initEverything();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = _splashWidget();
    if (_initialized) {
      if (_ready) {
        body = MainScreen();
      } else {
        body = InputMacScreen();
      }
    }
    return body;
  }

  Widget _splashWidget() {
    return Scaffold(
      body: Center(
          child: Image.asset(
        "assets/images/logo.png",
        height: 100,
        color: primaryColor,
      )),
    );
  }

  Future _initEverything() async {
    var provider = Provider.of<DeviceProvider>(context, listen: false);

    await provider.init(context);
    if ((provider.mac != null) && (provider.startServiceOnStart ?? false)) {
      await Services(context).startService();
    }
    setState(() {
      _ready = provider.mac != null;
      _initialized = true;
    });
  }
}
