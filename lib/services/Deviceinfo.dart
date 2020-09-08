import 'dart:io';

import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:get_ip/get_ip.dart';
import 'package:package_info/package_info.dart';

class Deviceinfo extends StatefulWidget {
  @override
  _DeviceinfoState createState() => _DeviceinfoState();
}

class _DeviceinfoState extends State<Deviceinfo> {

  String _deviceinfo = "";
  String _appName = "";
  String _packageName = "";
  String _version = "";
  String _buildNumber = "";

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
            Text("appName Is: " + _appName),
            Text("packageName Is: " + _packageName),
            Text("version Is: " + _version),
            Text("buildNumber Is: " + _buildNumber),
          ],
        ),
      ),
    );
  }

  Future<void> getDeviceinfo() async {

    String ipAddress = await GetIp.ipAddress;
    print(ipAddress);

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    _appName = appName;
    _packageName = packageName;
    _version = version;
    _buildNumber = buildNumber;

    String deviceinfo;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // print('Running on ${androidInfo.device}');
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
