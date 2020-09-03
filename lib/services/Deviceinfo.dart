import 'dart:io';

import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';

class Deviceinfo extends StatefulWidget {
  @override
  _DeviceinfoState createState() => _DeviceinfoState();
}

class _DeviceinfoState extends State<Deviceinfo> {

  String _deviceinfo = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeviceinfo();
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
            Text("Adroind Is: " + _deviceinfo),
          ],
        ),
      ),
    );
  }

  Future<void> getDeviceinfo() async {

    String deviceinfo;

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Running on ${androidInfo.device}');
      deviceinfo = androidInfo.device;
      _deviceinfo = deviceinfo;
      return _deviceinfo;
    }  else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('Running on ${iosInfo.utsname.machine}');
      deviceinfo = iosInfo.utsname.machine;
      _deviceinfo = deviceinfo;
      return _deviceinfo;
    }


  }
}
