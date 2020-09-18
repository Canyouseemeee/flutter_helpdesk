import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_helpdesk/screens/Loading.dart';
import 'package:flutter_helpdesk/screens/login.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  SharedPreferences sharedPreferences;
  String _username;
  String _version = "";
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    setState(() {
      getDeviceinfo();
    });
    checkLoginStatus();
    _settingsection();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") != null) {
      Map data = {
        'token': sharedPreferences.getString("token"),
      };
      var jsonData = null;
      var response = await http.post(
          "http://cnmihelpdesk.rama.mahidol.ac.th/api/issues-delete",
          body: data);
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        if (jsonData != null) {
          setState(() {
            _isLoading = false;
            String exp = sharedPreferences.getString("expired");
            // print(exp);
            DateTime dateTime = DateTime.parse(exp.substring(0, 8) + 'T' + exp.substring(8));
            var expired = int.parse(formatDate(dateTime, [yyyy, mm, dd, HH, nn, ss]));
            var now = int.parse(
                formatDate(DateTime.now(), [yyyy, mm, dd, HH, nn, ss]));
            // print(now);
            if (expired < now) {
              sharedPreferences.clear();
              sharedPreferences.commit();
              showTokenAlert();
            }
          });
        }
      } else if (sharedPreferences.getString("token") == null) {
        sharedPreferences.clear();
        sharedPreferences.commit();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Loading()),
            (Route<dynamic> route) => false);
      }
    }
  }

  showTokenAlert() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Token ของท่านหมดอายุกรุณาทำการล็อคอินใหม่"),
            actions: [
              FlatButton(
                onPressed: () {
                  sharedPreferences.clear();
                  sharedPreferences.commit();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => Loading()),
                      (Route<dynamic> route) => false);
                },
                child: Text("OK"),
              ),
            ],
          );
        });
  }

  checkVersion() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") != null) {
      var jsonData = null;
      var response = await http.get(
          "http://cnmihelpdesk.rama.mahidol.ac.th/api/issues-lastedVersion");
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        if (jsonData != null) {
          setState(() {
            _isLoading = false;
            sharedPreferences.setString("version", jsonData['version']);
            sharedPreferences.setString("url", jsonData['url']);
            // print(sharedPreferences.getString("url"));
            var _newVersion = sharedPreferences.getString("version");
            double Version =
                double.parse(_newVersion.trim().replaceAll(".", ""));
            // print(Version);
            double newVersion = Version;
            // print(newVersion);
            var lastedversion =
                double.parse(_version.trim().replaceAll(".", ""));
            // print(lastedversion);
            if (lastedversion < newVersion) {
              showVersionAlert(_newVersion, _version);
            }
          });
        }
      } else {
        // print(response.body);
      }
    }
  }

  showVersionAlert(String newVersion, String lastversion) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Update App"),
            content: Text("A new version of Upgrader is avalible! Version " +
                newVersion +
                " is now availble-you have " +
                lastversion +
                ""),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("LATER"),
              ),
              FlatButton(
                onPressed: () {
                  _launchURL();
                },
                child: Text("UPDATE NOW"),
              ),
            ],
          );
        });
  }

  _launchURL() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String url = sharedPreferences.getString("url");
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> getDeviceinfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    _version = version;
  }

  Future<void> _settingsection() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String username = sharedPreferences.getString("username");
    setState(() {
      _username = username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(alignment: Alignment.center, child: Text("Menu")),
        backgroundColor: Color(0xFF34558b),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.exit_to_app),
        //     onPressed: () {
        //       sharedPreferences.clear();
        //       sharedPreferences.commit();
        //       Navigator.of(context).pushAndRemoveUntil(
        //           MaterialPageRoute(
        //               builder: (BuildContext context) => LoginScreen()),
        //               (Route<dynamic> route) => false);
        //     },
        //   ),
        // ],
      ),
      body: ListView(
        children: <Widget>[
          Card(
            margin: EdgeInsets.only(top: 30, left: 30, right: 30),
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                child: Form(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 285),
                          width: 40.0,
                          height: 40.0,
                          child: FloatingActionButton(
                              child: Icon(Icons.info),
                              tooltip: "Check Updated",
                              onPressed: () {
                                checkVersion();
                              }),
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        backgroundColor: Color(0xFF34558b),
                                        radius: 30.0,
                                        child: Icon(Icons.person),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        '${_username}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40.0,
                                      margin: EdgeInsets.only(top: 30),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: RaisedButton(
                                        color: Colors.redAccent,
                                        onPressed: () {
                                          setState(() {
                                            _showLogoutAlertDialog();
                                          });
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        child: Text(
                                          "Logout",
                                          style:
                                              TextStyle(color: Colors.white70),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFF34558b),

      //Todo setting
      // SettingsList(
      //   sections: [
      //     SettingsSection(
      //       title: 'Section',
      //       tiles: [
      //         SettingsTile(
      //           title: 'Profile',
      //           subtitle: '${_username}',
      //           leading: Icon(Icons.person),
      //           onTap: () {},
      //         ),
      //       ],
      //     ),
      //     SettingsSection(
      //       title: 'Setting',
      //       tiles: [
      //         SettingsTile(
      //           title: 'Logout',
      //           leading: Icon(Icons.exit_to_app),
      //           onTap: () {
      //             _showLogoutAlertDialog();
      //           },
      //         ),
      //       ],
      //     ),
      //     SettingsSection(
      //       title: 'Version '+_version,
      //       tiles: [
      //         SettingsTile(
      //           title: 'Checked Update',
      //           leading: Icon(Icons.info),
      //           onTap: () {
      //             checkVersion();
      //           },
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
    );
  }

  void _showLogoutAlertDialog() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("${_prefs.getString("username")} to logout"),
            content: Text("Are you sure"),
            actions: [
              FlatButton(
                onPressed: () {
                  sharedPreferences.clear();
                  sharedPreferences.commit();
                  return Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => Loading()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Text("Yes"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No"),
              ),
            ],
          );
        });
  }
}
