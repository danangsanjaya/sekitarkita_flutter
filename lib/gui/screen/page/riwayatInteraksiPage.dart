import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:sekitarkita_flutter/core/connection/sekitarKitaConnection.dart';
import 'package:sekitarkita_flutter/core/models/interactedDevice.dart';
import 'package:sekitarkita_flutter/gui/components/CustomDivider.dart';
import 'package:url_launcher/url_launcher.dart';

class RiwayatInteraksiSreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<InteractedDevice>>(
      future: SekitarKitaConnection(context).getDevicesHistory(),
      builder: (BuildContext context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: LoadingFlipping.circle(borderColor: Theme.of(context).primaryColor),
            );
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) return _dataBody(snapshot);
            }
            return Center(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(15),
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Image.asset("assets/images/illustration/social_circle.png"),
                  ColumnDivider(),
                  Text(
                    "Belum ada interaksi yang tercatat",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Ingat, Dirumah lebih baik!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            );
            break;
          default:
            return ListView(
              padding: EdgeInsets.all(15),
              children: <Widget>[
                Image.asset("assets/images/illustration/social_circle.png"),
                ColumnDivider(),
                Text(
                  "Gagal mendapatkan informasi",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Coba periksa koneksi internet kamu deh.",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            );
            break;
        }
      },
    );
  }

  Widget _dataBody(AsyncSnapshot<List<InteractedDevice>> snapshot) {
    return NestedScrollView(
      physics: NeverScrollableScrollPhysics(),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: 200,
            floating: true,
            pinned: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  "assets/images/illustration/social_connected.png",
                  fit: BoxFit.contain,
                  height: 150,
                  width: 200,
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 48),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                height: 48,
                alignment: Alignment.center,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "Bluetooth Address",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Pada",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ];
      },
      body: ListView.builder(
        physics: ClampingScrollPhysics(),
        itemCount: snapshot.data.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () async {
            String url = "https://www.google.com/maps/search/?api=1&query=${snapshot.data[index].latitude},${snapshot.data[index].longitude}";
            if (await canLaunch(url)) launch(url);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(snapshot.data[index].anotherDevice),
                      RowDivider(),
                      Icon(
                        Icons.gps_fixed,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    DateFormat.yMMMMEEEEd().format(snapshot.data[index].createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
