import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sekitarkita_flutter/core/provider/DeviceProvider.dart';
import 'package:sekitarkita_flutter/core/res/string.dart';
import 'package:sekitarkita_flutter/core/utils/mainUtils.dart';
import 'package:sekitarkita_flutter/core/utils/services.dart';
import 'package:sekitarkita_flutter/gui/components/CustomDivider.dart';
import 'package:sekitarkita_flutter/gui/screen/laporScreen.dart';

class BerandaPage extends StatefulWidget {
  @override
  _BerandaPageState createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  @override
  Widget build(BuildContext context) {
    DeviceProvider provider = Provider.of(context);
    Widget body = Container();
    if (MediaQuery.of(context).size.width > MediaQuery.of(context).size.height) {
      body = SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 50),
        child: _body(provider, context),
      );
    } else {
      body = Center(
        child: FittedBox(
          alignment: Alignment.center,
          child: _body(provider, context),
        ),
      );
    }
    return body;
  }

  Widget _body(DeviceProvider provider, BuildContext context) {
    String health = (provider.health ?? "healthy").toLowerCase();
    Color bgHealthColor = Colors.grey;
    String peringatan = healthMsg;
    switch (health) {
      case "healthy":
        health = "Sehat";
        bgHealthColor = Theme.of(context).primaryColor;
        peringatan = healthMsg;
        break;
      case "odp":
        health = "Orang Dalam Pengawasan";
        bgHealthColor = Theme.of(context).accentColor;
        peringatan = odpMsg;
        break;
      case "pdp":
        health = "Pasien Dalam Perawatan";
        bgHealthColor = Colors.red;
        peringatan = pdpMsg;
        break;
    }
    return Column(
      children: <Widget>[
        Image.asset("assets/images/illustration/social_distance.png", height: 150),
        ColumnDivider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                text: "Selamat datang,\n",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              TextSpan(
                text: provider.userName != null ? (provider.userName.trim().length > 0 ? provider.userName.trim() : "Anonim") : "Anonim",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: bgHealthColor),
              ),
            ]),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 20,
          child: Text(
            peringatan,
            textAlign: TextAlign.center,
            style: TextStyle(color: bgHealthColor, fontSize: 15),
          ),
        ),
        ColumnDivider(),
        Center(
          child: FlatButton(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            color: bgHealthColor,
            shape: StadiumBorder(),
            child: Text(
              health,
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            onPressed: () async {
              await startScreen(context, LaporScreen());
              setState(() {});
            },
          ),
        ),
        Text(
          "Perbarui kondisimu melalui tombol ini",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        ColumnDivider(
          space: 40,
        ),
        SizedBox(
          height: 100,
          width: 100,
          child: FlatButton(
            color: !(provider.service ?? false) ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
            shape: CircleBorder(),
            child: Icon(
              Icons.fingerprint,
              color: Colors.white,
              size: 60,
            ),
            onPressed: () async {
              if (!provider.service) {
                await Services(context).startService();
              } else {
                await Services(context).stopService();
              }
              setState(() {});
            },
          ),
        ),
        ColumnDivider(
          space: 5,
        ),
        Text(
          !(provider.service ?? false) ? "Mulai Layanan" : "Hentikan Layanan",
          style: TextStyle(
            color: !(provider.service ?? false) ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
          ),
        ),
        ColumnDivider(
          space: 20,
        ),
      ],
    );
  }
}
