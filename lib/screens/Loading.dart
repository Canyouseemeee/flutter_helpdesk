import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_helpdesk/services/Jsondata.dart';
import 'package:get_ip/get_ip.dart';
import 'package:get_mac/get_mac.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart';


import 'login.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String _macAddress = "";
  bool _loading;
  List data;
  String _deviceinfo = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading = true;
    if (_loading) {
      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          _loading = false;
          // initPlatformState();
          getDeviceinfo();
          // _buildJson();
        });
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  getDeviceinfo() async {
    String deviceinfo;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceinfo = androidInfo.androidId;
      _deviceinfo = deviceinfo;
      return _getJson(_deviceinfo);
    }  else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('Running on ${iosInfo.utsname.machine}');
      deviceinfo = iosInfo.utsname.machine;
      _deviceinfo = deviceinfo;
      return _getJson(_deviceinfo);
    }
  }

  showDeviceinfo(String deviceinfo) async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(deviceinfo),
            actions: [
              FlatButton(
                onPressed: () {
                  exit(0);
                },
                child: Text("OK"),
              ),
            ],
          );
        });
  }

  Future<void> initPlatformState() async {
    String macAddress;

    try {
      macAddress = await GetMac.macAddress;
    } on PlatformException {
      macAddress = "Faild to get Device Mac Address";
    }
    if (!mounted) return;

    setState(() {
      _macAddress = macAddress;
    });
    if (_macAddress != null) {
      _getJson(_macAddress);
    } else {
      print("Error MacAddress");
    }
  }

  // postMacAdress(String macAddress) async {
  //   Map data = {'macAddress': macAddress};
  //   var jsonData = null;
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   var response =
  //       await http.post("http://10.57.34.148:8000/api/issues-postmacAddress", body: data);
  //   if (response.statusCode == 200) {
  //     jsonData = json.decode(response.body);
  //     if (jsonData != null) {
  //       setState(() {
  //         _loading = false;
  //       });
  //       // sharedPreferences.setString("token", jsonData['token']);
  //       // sharedPreferences.setString(
  //       //     'username', usernameController.text.toString());
  //
  //       Navigator.of(context).pushAndRemoveUntil(
  //           MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
  //               (Route<dynamic> route) => false);
  //     }
  //     print(_macAddress);
  //   } else {
  //     print(response.body);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_loading
          ? new Center(child: new CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                Center(
                  child: new FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image:
                          "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/CNMI_logo.svg/1200px-CNMI_logo.svg.png"),
                ),
              ],
            )),
    );
  }

  _getJson(String _deviceid) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'deviceid': _deviceid,
    };
    var jsonData = null;
    var response = await http.post(
        "http://192.168.43.222:8000/api/issues-deviceid",
        body: data);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      if (jsonData != null) {
        setState(() {
          _loading = false;
          sharedPreferences.setString(
              "Deviceid", jsonData['deviceid'].toString());
          print(sharedPreferences.getString("Deviceid"));
        });
        if (sharedPreferences.getString("Deviceid").replaceAll('[]', '') == '') {
          _showAlertDiolog(_deviceinfo);
        }
        else if (_deviceinfo ==
            sharedPreferences
                .getString("Deviceid")
                .substring(12)
                .replaceAll('}]', '')) {
          _buildJson();
          // getDeviceinfo();
        }
      }
    } else {
      print(response.body);
    }
  }



  _buildJson() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _loading = false;
    // print(_macAddress);
    // print(sharedPreferences.getString("MacAddress"));
    String Deviceid = sharedPreferences
        .getString("Deviceid")
        .substring(12)
        .replaceAll('}]', '');
    // print(Deviceid);
    if (_deviceinfo != Deviceid) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _showAlertDiolog(_deviceinfo);
        // print(item);
      });
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        postLoginData(_deviceinfo);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
            (Route<dynamic> route) => false);
      });
    }
  }

  Future<void> postLoginData(String Deviceid) async {
    String ipAddress = await GetIp.ipAddress;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("Deviceid", Deviceid);
    sharedPreferences.setString("ipAddress", ipAddress);
  }

  void _showAlertDiolog(String _deviceinfo) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(_deviceinfo +
                " หมายเลขของท่านยังไม่ได้ลงทะเบียน"
                    "กรุณาไปลงทะเบียนขอใช้งาน"),
            actions: [
              FlatButton(
                onPressed: () {
                  exit(0);
                },
                child: Text("OK"),
              ),
            ],
          );
        });
  }
}
