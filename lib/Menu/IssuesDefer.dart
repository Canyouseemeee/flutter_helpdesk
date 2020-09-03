import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:flutter_helpdesk/Menu/IssuesDetail.dart';
import 'package:flutter_helpdesk/Models/Defer.dart';
import 'package:flutter_helpdesk/screens/login.dart';
import 'package:flutter_helpdesk/services/Jsondata.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'IssuesClosed.dart';
import 'IssuesNew.dart';

class IssuesDefer extends StatefulWidget {
  @override
  _IssuesDeferState createState() => _IssuesDeferState();
}

class _IssuesDeferState extends State<IssuesDefer> {
  final double _borderRadius = 24;
  SharedPreferences sharedPreferences;
  List<Defer> _defer;
  bool _loading = false;
  ScrollController _scrollController = new ScrollController();
  int _currentMax = 10;

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

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
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
//Todo Appbar
      appBar: AppBar(
        title: Align(
            alignment: Alignment.center,
            child: Text(_loading ? 'Loading...' : "Defer")),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.exit_to_app),
        //     onPressed: () {
        //       sharedPreferences.clear();
        //       sharedPreferences.commit();
        //       Navigator.of(context).pushAndRemoveUntil(
        //           MaterialPageRoute(
        //               builder: (BuildContext context) => LoginScreen()),
        //           (Route<dynamic> route) => false);
        //     },
        //   ),
        // ],
      ),
      body: (_loading
          ? new Center(child: new CircularProgressIndicator())
          : _showJsondata()),

//Todo Tabbar
//      bottomNavigationBar: BottomNavigationBar(
//        currentIndex: _currentIndex,
//        type: BottomNavigationBarType.fixed,
//        items: [
////          BottomNavigationBarItem(
////              icon: Icon(Icons.home),
////              title: Text("Dashboard"),
////              backgroundColor: Colors.blue),
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
          // controller: _scrollController,
          scrollDirection: Axis.vertical,
          itemCount: null == _defer ? 0 : _defer.length + 1,
          itemBuilder: (context, index) {
            if (index == _defer.length) {
              return CupertinoActivityIndicator();
            }
            Defer defer = _defer[index];
            return GestureDetector(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(_borderRadius),
                          gradient: LinearGradient(
                            colors: [Colors.blue, Colors.lightBlue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                      ),
                      Positioned.fill(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Image.asset(
                                'assets/mac-os.png',
                                height: 40,
                                width: 40,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              flex: 4,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    defer.subject,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    defer.issuesid.toString(),
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    defer.trackName.toString().substring(10),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    formatter.formatInBuddhistCalendarThai(
                                        defer.updatedAt),
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.white,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => IssuesDeferDetail(defer)),
                );
              },
            );

//Todo Card
//        return Card(
//          child: Container(
//            child: Row(
//              children: <Widget>[
//                Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Text(defer.issuesid.toString()),
//                    Text(defer.trackName),
//                    Text(defer.subject),
//                    Text(formatter.formatInBuddhistCalendarThai(defer.updatedAt)),
//                  ],
//                ),
//              ],
//            ),
//          ),
//        );
          },
        ),
        onRefresh: _handleRefresh,
      );

  Future<Null> _handleRefresh() async {
    Completer<Null> completer = new Completer<Null>();

    new Future.delayed(new Duration(milliseconds: 2)).then((_) {
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
