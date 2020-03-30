import 'package:flutter/material.dart';
import 'package:sekitarkita_flutter/core/res/string.dart';
import 'package:sekitarkita_flutter/core/res/warna.dart';
import 'package:sekitarkita_flutter/core/utils/macInput.dart';
import 'package:sekitarkita_flutter/core/utils/mainUtils.dart';
import 'package:sekitarkita_flutter/core/utils/preferences.dart';
import 'package:sekitarkita_flutter/core/utils/systemSettings.dart';
import 'package:sekitarkita_flutter/gui/components/CustomDivider.dart';
import 'package:sekitarkita_flutter/gui/screen/mainScreen.dart';
import 'package:toast/toast.dart';

class InputMacScreen extends StatefulWidget {
  final String macAddress;

  const InputMacScreen({Key key, this.macAddress}) : super(key: key);
  @override
  InputMacScreenState createState() => InputMacScreenState();
}

class InputMacScreenState extends State<InputMacScreen> {
  final TextEditingController _etMac = TextEditingController();
  final MacInput _macInput = MacInput();

  @override
  void initState() {
    if (widget.macAddress != null) _etMac.text = widget.macAddress;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Center(
              child: ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(30),
                children: <Widget>[
                  Image.asset(
                    "assets/images/illustration/connected.png",
                    height: 150,
                  ),
                  Text(
                    "Taukah kamu?",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  ColumnDivider(
                    space: 3,
                  ),
                  Text(
                    "Dengan bluetooth, Aplikasi Sekitarkita bisa membantu kamu mengetahui dengan siapa saja kamu pernah berinteraksi, Jika lawan interaksimu melapor sebagai seorang ODP atau PDP, kamu akan mendapatkan Notifikasi dan bersegeralah mengambil tindakan medis.\n\nUntuk memantapkan fungsi aplikasi, Isi MAC Bluetoothmu dengan jujur ya ^-^.",
                    style: TextStyle(fontSize: 12),
                  ),
                  ColumnDivider(
                    space: 20,
                  ),
                  TextField(
                    controller: _etMac,
                    textAlign: TextAlign.center,
                    maxLength: 17,
                    onChanged: (val) => _macInput.macChange(val, _etMac),
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade300,
                      filled: true,
                      border: InputBorder.none,
                      counter: Container(),
                      hintText: "AB:CD:EF:12:34:56",
                    ),
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Lihat MAC Bluetooth",
                        style: TextStyle(color: primaryColor, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onTap: () async {
                      await SystemSettings().openDeviceInfo();
                    },
                  ),
                  ColumnDivider(),
                  SizedBox(
                    height: 40,
                    child: FlatButton(
                      color: primaryColor,
                      child: Text(
                        "Simpan",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      shape: StadiumBorder(),
                      onPressed: _simpanMac,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 10,
              top: 10,
              child: widget.macAddress != null ? CloseButton() : Container(),
            )
          ],
        ),
      ),
    );
  }

  void _simpanMac() async {
    if (_etMac.text.length == 17) {
      if (!(await showMessage(context, title: perhatian, message: "Apa MAC yang anda masukan sudah benar?.", actions: [
            FlatButton(
              child: Text("Sudah Benar!"),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            FlatButton(
              child: Text("Belum"),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ])) ??
          false) return;

      (await Preferences.init(context)).saveMacBluetooth(_etMac.text);
      Toast.show("Detil Mac berhasil disimpan", context, duration: 2);
      if (widget.macAddress == null)
        replaceScreen(context, MainScreen());
      else
        Navigator.pop(context);
    } else {
      showMessage(context, title: perhatian, message: "Sepertinya MAC Addressmu tidak valid.");
      return;
    }
  }
}
