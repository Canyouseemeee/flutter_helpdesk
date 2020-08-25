import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:flutter_helpdesk/Models/Defer.dart';
import 'package:flutter_helpdesk/screens/login.dart';
import 'package:flutter_helpdesk/services/Jsondata.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'IssuesClosed.dart';

class IssuesDefer extends StatefulWidget {
  @override
  _IssuesDeferState createState() => _IssuesDeferState();
}

class _IssuesDeferState extends State<IssuesDefer> {
  SharedPreferences sharedPreferences;
  int _currentIndex = 2;
  List<Defer> _defer;
  bool _loading;
  var formatter = DateFormat.yMd().add_jm();


  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    _loading = true;
    Jsondata.getDefer().then((defer) {
      setState(() {
        _defer = defer;
        _loading = false;
      });
    });

  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
              (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text(_loading ? 'Loading...' :"Defer"),
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.exit_to_app),
//            onPressed: () {
//              sharedPreferences.clear();
//              sharedPreferences.commit();
//              Navigator.of(context).pushAndRemoveUntil(
//                  MaterialPageRoute(
//                      builder: (BuildContext context) => LoginScreen()),
//                      (Route<dynamic> route) => false);
//            },
//          ),
//        ],
//      ),
      body: _showJsondata(),
//      bottomNavigationBar: BottomNavigationBar(
//        currentIndex: _currentIndex,
//        type: BottomNavigationBarType.fixed,
//        items: [
//          BottomNavigationBarItem(
//              icon: Icon(Icons.home),
//              title: Text("Dashboard"),
//              backgroundColor: Colors.blue),
//          BottomNavigationBarItem(
//              icon: Icon(Icons.search),
//              title: Text("New"),
//              backgroundColor: Colors.blue),
//          BottomNavigationBarItem(
//              icon: Icon(Icons.camera),
//              title: Text("Defer"),
//              backgroundColor: Colors.blue),
//          BottomNavigationBarItem(
//              icon: Icon(Icons.person),
//              title: Text("Closed"),
//              backgroundColor: Colors.blue),
//        ],
//        onTap: (index) {
//          setState(() {
//            _currentIndex = index;
//            if (_currentIndex == 0) {
//              Navigator.of(context).pushAndRemoveUntil(
//                  MaterialPageRoute(
//                      builder: (BuildContext context) => MainPage()),
//                      (Route<dynamic> route) => false);
//            }
//            if (_currentIndex == 1) {
//              Navigator.of(context).pushAndRemoveUntil(
//                  MaterialPageRoute(
//                      builder: (BuildContext context) => IssuesNew()),
//                      (Route<dynamic> route) => false);
//            }
//            if (_currentIndex == 2) {
//              Navigator.of(context).pushAndRemoveUntil(
//                  MaterialPageRoute(
//                      builder: (BuildContext context) => IssuesDefer()),
//                      (Route<dynamic> route) => false);
//            }
//            if (_currentIndex == 3) {
//              Navigator.of(context).pushAndRemoveUntil(
//                  MaterialPageRoute(
//                      builder: (BuildContext context) => IssuesClosed()),
//                      (Route<dynamic> route) => false);
//            }
//          });
//        },
//      ),
    );
  }
  Widget _showJsondata() => new RefreshIndicator(
    child: ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: null == _defer ? 0 : _defer.length,
      itemBuilder: (context, index) {
        Defer defer = _defer[index];
        return Card(
          child: Container(
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(defer.issuesid.toString()),
                    Text(defer.trackName),
                    Text(defer.issName),
                    Text(defer.ispName),
                    Text(defer.users),
                    Text(defer.subject),
                    Text(formatter.formatInBuddhistCalendarThai(defer.updatedAt)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
    onRefresh: _handleRefresh,
  );

  Future<Null> _handleRefresh() async {
    Completer<Null> completer = new Completer<Null>();

    new Future.delayed(new Duration(seconds: 3)).then((_) {
      completer.complete();
      setState(() {
        _loading = true;
        Jsondata.getDefer().then((defer) {
          setState(() {
            _defer = defer;
            _loading = false;
          });
        });
      });
    });

    return null;
  }
}
