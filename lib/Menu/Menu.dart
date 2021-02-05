import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
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
  String _name;
  String _team;
  String _version = "";
  bool _isLoading;
  String Url;

  @override
  void initState() {
    super.initState();
    setState(() {
      getDeviceinfo();
    });
    checkLoginStatus();
    _settingsection();
    imageAvatar();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") != null) {
      Map data = {
        'token': sharedPreferences.getString("token"),
      };
      var jsonData = null;
      var response = await http.post(
          "http://192.168.43.222:8000/api/issues-delete",
          body: data);
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        if (jsonData != null) {
          setState(() {
            _isLoading = false;
            String exp =
                sharedPreferences.getString("expired").replaceAll(" ", "");
            // print(exp);
            var expired = int.parse(exp);
            var now = int.parse(
                formatDate(DateTime.now(), [yyyy, mm, dd, HH, nn, ss]));
            // print(expired);
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
            title: Text("Token หมดอายุกรุณาทำการล็อคอินใหม่"),
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
          "http://192.168.43.222:8000/api/issues-lastedVersion");
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
            }else{
              // showDialog(
              //     context: context,
              //     barrierDismissible: false,
              //     builder: (context) {
              //       return AlertDialog(
              //         title: Text("Update App"),
              //         content: Text("Your version is the latest version"),
              //         actions: [
              //           FlatButton(
              //             onPressed: () {
              //               Navigator.pop(context);
              //             },
              //             child: Text("OK"),
              //           ),
              //         ],
              //       );
              //     });
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
    final String name = sharedPreferences.getString("name");
    final String team = sharedPreferences.getString("team");
    setState(() {
      _username = username;
      _name = name;
      _team = team;
    });
    // print(imageAvatar());
    // print(sharedPreferences.getString("image").toString().substring(9).replaceAll("}]", ""));
  }

  Future<void> imageAvatar() async {
    sharedPreferences = await SharedPreferences.getInstance();
    // print(sharedPreferences.getString("image").toString().substring(8).replaceAll("}]", ""));
    final String image = "http://192.168.43.222:8000/storage/" +
        sharedPreferences
            .getString("image")
            .toString()
            .substring(9)
            .replaceAll("}]", "");
    if (sharedPreferences
            .getString("image")
            .toString()
            .substring(9)
            .replaceAll("}]", "") !=
        "null") {
      setState(() {
        Url = image;
      });
    }
    // print(Url);
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 30.0,
                                        backgroundImage: Url == null
                                            ? NetworkImage(
                                                // "https://cdn.icon-icons.com/icons2/1674/PNG/512/person_110935.png")
                                          "https://media1.tenor.com/images/82c6e055245fc8fa7381dc887bf14e62/tenor.gif?itemid=12170592")
                                            : NetworkImage('${Url}'),
                                        // backgroundImage: NetworkImage("http://cnmihelpdesk.rama.mahidol.ac.th/storage/"+image),

                                        // child: Image,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16,left: 16,right: 16),
                                      child: Text(
                                        "Username : "+'${_username}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16,left: 16,right: 16),
                                      child: Text(
                                        "Name : "+'${_name}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16,left: 16,right: 16),
                                      child: Text(
                                        "Team : "+'${_team}',
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
                                      child: RaisedButton.icon(
                                        color: Colors.amberAccent,
                                        onPressed: () {
                                          setState(() {
                                            checkVersion();
                                          });
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(5.0),
                                        ),
                                        icon: Icon(Icons.system_update,color: Colors.white70,),
                                        label: Text(
                                          "CheckforUpdate v" + _version,
                                          style:
                                          TextStyle(color: Colors.white70),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 40.0,
                                      margin: EdgeInsets.only(top: 10),
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
            title: Text("${_prefs.getString("username")} ล็อคเอ้าท์"),
            content: Text("คุณต้องการล็อคเอ้าท์ใช่หรือไม่ ?"),
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
                child: Text("ใช่"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("ไม่"),
              ),
            ],
          );
        });
  }
}
