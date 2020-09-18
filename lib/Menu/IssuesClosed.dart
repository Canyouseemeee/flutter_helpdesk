import 'dart:async';
import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:flutter_helpdesk/Menu/IssuesDetail.dart';
import 'package:flutter_helpdesk/screens/Loading.dart';
import 'package:flutter_helpdesk/services/Jsondata.dart';
import 'package:flutter_helpdesk/Models/Closed.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'IssuesDefer.dart';
import 'IssuesNew.dart';

class IssuesClosed extends StatefulWidget {
  @override
  _IssuesClosedState createState() => _IssuesClosedState();
}

class _IssuesClosedState extends State<IssuesClosed> {
  var formatter = DateFormat.yMMMd().add_jm();
  SharedPreferences sharedPreferences;
  final double _borderRadius = 24;
  ScrollController _scrollController = new ScrollController();
  int _currentMax = 10;
  var max;
  var min;
  List<Closed> _closed;
  bool _loading;
  DateTime time = DateTime.now();
  bool _disposed = false;

  @override
  void initState() {
    Timer(Duration(seconds: 1), () {
      if (!_disposed)
        setState(() {
          time = time.add(Duration(seconds: -1));
        });
    });
    super.initState();
    checkLoginStatus();
    _loading = true;
    Jsondata.getClosed().then((closed) {
      setState(() {
        _closed = closed;
        max = _closed.length;
        _closed = List.generate(10, (index) => _closed[index]);
        min = _closed.length;
        _scrollController.addListener(() {
          if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
            getMoreData();
          }
        });
        _loading = false;
      });
    });
  }

  showAlertNullData() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("ไม่มีข้อมูลของงาน"),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        });
  }

  getMoreData() {
    if (min == 10) {
      for (int i = _currentMax; i < max - 1; i++) {
        Jsondata.getClosed().then((closed) {
          setState(() {
            _closed = closed;
            _closed.add(_closed[i]);
            _closed.length = max;
            _loading = false;
            if (_closed.isNotEmpty) {
              return _closed.elementAt(0);
            }
          });
        });
      }
      if (_closed.length == max) {
        showAlertLimitData();
      }
    }
    setState(() {});
  }

  showAlertLimitData() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("ข้อมูลสิ้นสุดแค่นี้"),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    _disposed = true;
    super.dispose();
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
            _loading = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
            alignment: Alignment.center,
            child: Text(_loading ? 'Loading...' : "Closed")),
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
      body: (_loading
          ? new Center(
              child: new CircularProgressIndicator(
              backgroundColor: Colors.white70,
            ))
          : _showJsondata()),
      backgroundColor: Color(0xFF34558b),
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
////            if (_currentIndex == 0) {
////              Navigator.of(context).pushAndRemoveUntil(
////                  MaterialPageRoute(
////                      builder: (BuildContext context) => MainPage()),
////                      (Route<dynamic> route) => false);
////            }
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
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          itemCount: null == _closed ? 0 : _closed.length + 1,
          itemExtent: 100,
          itemBuilder: (context, index) {
            if (index == _closed.length) {
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.white70,
              ));
            }
            // Closed _closed[index] = _closed[index];
            return GestureDetector(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(_borderRadius),
                          color: Color(0xFFf2f6f5),
                          // gradient: LinearGradient(
                          //   colors: [Color(0xFF34558b), Colors.lightBlue],
                          //   begin: Alignment.topLeft,
                          //   end: Alignment.bottomRight,
                          // ),
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
                                    _closed[index].subject,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    _closed[index].issuesid.toString(),
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _closed[index].trackName.toString(),
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    formatter.formatInBuddhistCalendarThai(
                                        _closed[index].updatedAt),
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.black87,
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
                      builder: (context) => IssuesClosedDetail(_closed[index])),
                );
              },
            );
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
        if (_loading == true) {
          Jsondata.getClosed().then((closed) {
            setState(() {
              _closed = closed;
              _closed = List.generate(10, (index) => _closed[index]);
              _loading = false;
            });
          });
          if (mounted) {
            setState(() {
              Text("No Data");
            });
          }
        }
      });
    });

    return null;
  }
}
