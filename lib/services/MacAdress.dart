import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_mac/get_mac.dart';

class MacAdress extends StatefulWidget {
  @override
  _MacAdressState createState() => _MacAdressState();
}

class _MacAdressState extends State<MacAdress> {
  String _macAddress = "";
  String _imeiNumber = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async{
    String macAddress;
    String imeiNumber;

    try{
      macAddress = await GetMac.macAddress;
    } on PlatformException {
      macAddress = "Faild to get Device Mac Address";
    }
    if (!mounted) return;

    setState(() {
      _macAddress = macAddress;
      _imeiNumber = imeiNumber;
      print(_macAddress);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GetMac IMEI"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Mac Is: " + _macAddress),
            Text("IMEI Is: " + _imeiNumber),
          ],
        ),
      ),
    );
  }
}
