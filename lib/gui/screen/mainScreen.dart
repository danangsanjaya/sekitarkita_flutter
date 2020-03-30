import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:sekitarkita_flutter/core/res/string.dart';
import 'package:sekitarkita_flutter/core/utils/mainUtils.dart';
import 'package:sekitarkita_flutter/gui/screen/page/berandaPage.dart';
import 'package:sekitarkita_flutter/gui/screen/page/pengaturanPage.dart';
import 'package:sekitarkita_flutter/gui/screen/page/riwayatInteraksiPage.dart';

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  List<BottomNav> _listBottomNav;

  int _curIndex = 0;

  @override
  void initState() {
    _listBottomNav = [
      BottomNav(
        bottomNavItem: BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Beranda")),
        page: BerandaPage(),
      ),
      BottomNav(
        bottomNavItem: BottomNavigationBarItem(icon: Icon(Icons.people), title: Text("Riwayat Interaksi")),
        page: RiwayatInteraksiSreen(),
      ),
      BottomNav(
        bottomNavItem: BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text("Pengaturan")),
        page: PengaturanPage(),
      ),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sekitarkita.id"),
        actions: <Widget>[
          IconButton(
            tooltip: "Informasi Sekitarkita",
            onPressed: () {
              showMessage(context, title: perhatian, message: informasiSekitarKita);
            },
            icon: Icon(
              Icons.help_outline,
              color: Colors.white,
            ),
          ),
          IconButton(
            tooltip: "Bagikan Sekitarkita",
            onPressed: () async {
              await FlutterShare.share(
                title: "Sekitarkita.id",
                text: shareTextSekitarKita,
                chooserTitle: "Pilih Media Berbagi",
                linkUrl: "https://landing.sekitarkita.id/",
              );
            },
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
          ),
        ],
        elevation: 0,
      ),
      body: _listBottomNav[_curIndex].page,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        items: _listBottomNav.map((item) => item.bottomNavItem).toList(),
        currentIndex: _curIndex,
        onTap: (index) => setState(() {
          _curIndex = index;
        }),
      ),
    );
  }
}

class BottomNav {
  final Widget page;
  final BottomNavigationBarItem bottomNavItem;

  BottomNav({@required this.page, @required this.bottomNavItem});
}
