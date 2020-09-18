import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:flutter/services.dart';
import 'package:flutter_helpdesk/Menu/IssuesDetail.dart';
import 'package:flutter_helpdesk/Models/Defer.dart';
import 'package:flutter_helpdesk/screens/Loading.dart';
import 'package:http/http.dart' as http;
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
  var max;
  var min;
  var formatter = DateFormat.yMd().add_jm();
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
    Jsondata.getDefer().then((defer) {
      setState(() {
        _defer = defer;
        if (_defer.length == 0) {
          showAlertNullData();
        } else {
          max = _defer.length;
          _defer = List.generate(10, (index) => _defer[index]);
          min = _defer.length;
          _scrollController.addListener(() {
            if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent) {
              getMoreData();
            }
          });
          _loading = false;
        }
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

  getMoreData(){
    if (min == 10) {
      for (int i = _currentMax; i < max - 1; i++) {
        Jsondata.getDefer().then((defer) {
          setState(() {
            _defer = defer;
            _defer.add(_defer[i]);
            _defer.length = max;
            _loading = false;
            if (_defer.isNotEmpty) {
              return _defer.elementAt(0);
            }
          });
        });
      }
      _currentMax = _currentMax + 10;
      if(_defer.length == max){
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
            DateTime dateTime = DateTime.parse(exp.substring(0, 8) + 'T' + exp.substring(8));
            var expired = int.parse(formatDate(dateTime, [yyyy, mm, dd, HH, nn, ss]));
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
//Todo Appbar
      appBar: AppBar(
        title: Align(
            alignment: Alignment.center,
            child: Text(_loading ? 'Loading...' : "Defer")),
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
        //           (Route<dynamic> route) => false);
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
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          itemCount: null == _defer ? 0 : _defer.length + 1,
          itemExtent: 100,
          itemBuilder: (context, index) {
            // Defer _defer[index] = _defer[index];
            if (index == _defer.length) {
              return Center(child: CircularProgressIndicator(backgroundColor: Colors.white70,));
            }
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
                                    _defer[index].subject,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    _defer[index].issuesid.toString(),
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
                                children: <Widget>[
                                  Text(
                                    _defer[index].trackName,
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    formatter.formatInBuddhistCalendarThai(
                                        _defer[index].updatedAt),
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
                      builder: (context) => IssuesDeferDetail(_defer[index])),
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
            _defer = List.generate(10, (index) => _defer[index]);
            _loading = false;
          });
        });
        if(mounted){
          setState(() {
            Text("No Data");
          });
        }
      });
    });

    return null;
  }
}
