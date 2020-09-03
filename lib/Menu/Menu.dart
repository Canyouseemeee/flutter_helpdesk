import 'package:flutter/material.dart';
import 'package:flutter_helpdesk/screens/Loading.dart';
import 'package:flutter_helpdesk/screens/login.dart';
import 'package:flutter_helpdesk/services/MacAdress.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  SharedPreferences sharedPreferences;
  String _username;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLoginStatus();
    _settingsection();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
          (Route<dynamic> route) => false);
    }
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
      body: SettingsList(
        sections: [
          SettingsSection(
            title: 'Section',
            tiles: [
              SettingsTile(
                title: 'Profile',
                subtitle: '${_username}',
                leading: Icon(Icons.person),
                onTap: () {},
              ),
            ],
          ),
          SettingsSection(
            title: 'Setting',
            tiles: [
              SettingsTile(
                title: 'Logout',
                leading: Icon(Icons.exit_to_app),
                onTap: () {
                  _showLogoutAlertDialog();
                },
              ),
            ],
          ),
        ],
      ),
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
                        builder: (BuildContext context) => LoginScreen()),
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
