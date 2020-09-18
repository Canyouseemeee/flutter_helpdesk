import 'dart:async';
import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helpdesk/Menu/IssuesDetail.dart';
import 'package:flutter_helpdesk/Models/New.dart';
import 'package:flutter_helpdesk/screens/Loading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_helpdesk/services/Jsondata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'IssuesClosed.dart';
import 'IssuesDefer.dart';

class IssuesNew extends StatefulWidget {
  @override
  _IssuesNewState createState() => _IssuesNewState();
}

class _IssuesNewState extends State<IssuesNew> {
  SharedPreferences sharedPreferences;
  final double _borderRadius = 24;
  int _currentMax = 10;
  var max;
  var min;
  var formatter = DateFormat.yMd().add_jm();
  ScrollController _scrollController = new ScrollController();
  List<New> _new;
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
    Jsondata.getNew().then((news) {
      setState(() {
        _new = news;
        max = _new.length;
        // _new = List.generate(10, (index) => _new[index]);
        min = _new.length;
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

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    _disposed = true;
    super.dispose();
  }

  showAlertNullData() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("ไม่มีข้อมูลของงานใหม่"),
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
        Jsondata.getNew().then((news) {
          setState(() {
            _new = news;
            _new.add(_new[i]);
            _new.length = max;
            _loading = false;
            if (_new.isNotEmpty) {
              return _new.elementAt(0);
            }
          });
        });
      }
      if (_new.length == max) {
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
            child: Text(_loading ? 'Loading...' : "New")),
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
    );
  }

  Widget _showJsondata() => new RefreshIndicator(
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          itemCount: null == _new ? 0 : _new.length + 1,
          itemExtent: 100,
          itemBuilder: (context, index) {
            if (index == _new.length) {
              if (index > _new.length - 1) {
                return null;
              }
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.white70,
              ));
            }
            // New _new[index] = _new[index];
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
                                    _new[index].subject,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    _new[index].issuesid.toString(),
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    _new[index].trackName,
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    formatter.formatInBuddhistCalendarThai(
                                        _new[index].updatedAt),
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
                      builder: (context) => IssuesNewDetail(_new[index])),
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
        Timer(Duration(seconds: 1), () {
          if (!_disposed)
            setState(() {
              time = time.add(Duration(seconds: -1));
            });
        });
        _loading = true;
        Jsondata.getNew().then((news) {
          setState(() {
            _new = news;
            max = _new.length;
            // _new = List.generate(10, (index) => _new[index]);
            min = _new.length;
            _scrollController.addListener(() {
              if (_scrollController.position.pixels ==
                  _scrollController.position.maxScrollExtent) {
                getMoreData();
              }
            });
            _loading = false;
          });
        });
      });
    });

    return null;
  }
}
