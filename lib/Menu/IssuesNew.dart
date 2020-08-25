import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helpdesk/Models/New.dart';
import 'package:flutter_helpdesk/screens/login.dart';
import 'package:flutter_helpdesk/services/Jsondata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';


import '../main.dart';
import 'IssuesClosed.dart';

void main() {
//  Intl.defaultLocale = 'th';
//  initializeDateFormatting();
//  runApp(
//    IssuesNew(),
//  );
}

class IssuesNew extends StatefulWidget {
  @override
  _IssuesNewState createState() => _IssuesNewState();
}

class _IssuesNewState extends State<IssuesNew> {
  var formatter = DateFormat.yMMMd().add_jm();

  SharedPreferences sharedPreferences;
  int _currentIndex = 1;
  List<New> _new;
  bool _loading;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    _loading = true;
    Jsondata.getNew().then((news) {
      setState(() {
        _new = news;
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
//        title: Text(_loading ? 'Loading...' : "New"),
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
      itemCount: null == _new ? 0 : _new.length,
      itemBuilder: (context, index) {
        New news = _new[index];
        return Card(
          child: Container(
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(news.issuesid.toString()),
                    Text(news.trackName),
                    Text(news.issName),
                    Text(news.ispName),
                    Text(news.users),
                    Text(news.subject),
                    Text(formatter.formatInBuddhistCalendarThai(news.updatedAt)),
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
        Jsondata.getNew().then((news) {
          setState(() {
            _new = news;
            _loading = false;
          });
        });
      });
    });

    return null;
  }
}
