import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_helpdesk/Models/MacAddress.dart';
import 'package:flutter_helpdesk/services/Jsondata.dart';
import 'package:get_mac/get_mac.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'login.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String _macAddress = "";
  bool _loading;
  String MacAddress;

  List data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading = true;
    if (_loading) {
      Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          _loading = false;
          getJSONData();
          initPlatformState();
        });
      });
    }
  }

  Future<String> getJSONData() async {
    var response =
        await http.get("http://10.57.34.148:8000/api/issues-getMacAddress");
    setState(() {
      data = json.decode(response.body);
    });
    return "Successfull";
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
      return _macAddress;
      // postMacAdress(_macAddress);
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
      //     (Route<dynamic> route) => false);
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
          : _buildListView()),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (context, index) {
          return _buildJson(data[index]);
        });
  }

  Widget _buildJson(dynamic item) {
    _loading = false;
    if (_macAddress != item['MacAddress']) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _showAlertDiolog();
      });
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
            (Route<dynamic> route) => false);
      });
    }

    // print(_macAddress);
    // print(item['MacAddress']);
  }

  void _showAlertDiolog() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("หมายเลขของท่านยังไม่ได้ลงทะเบียน"
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
