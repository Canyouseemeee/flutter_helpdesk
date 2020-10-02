import 'dart:async';
import 'dart:convert';
import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_helpdesk/Models/Checkin.dart';
import 'package:flutter_helpdesk/Models/New.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IssuesCheckin extends StatefulWidget {
  String news;
  IssuesCheckin(this.news);
  @override
  _IssuesCheckinState createState() => _IssuesCheckinState(news);
}

class _IssuesCheckinState extends State<IssuesCheckin> {
  String news;
  _IssuesCheckinState(this.news);
  bool _loading;
  SharedPreferences sharedPreferences;
  final double _borderRadius = 24;
  int _currentMax = 10;
  var max;
  var min;
  var formatter = DateFormat.yMd().add_jm();
  ScrollController _scrollController = new ScrollController();
  List<Checkin> _checkin;
  DateTime time = DateTime.now();
  bool _disposed = false;

  static Future<List<Checkin>> getCheckin(String news) async {
    Map data = {
      'issuesid': news,
    };
    const String url = "http://10.57.34.148:8000/api/issues-getstatus";
    try {
      final response = await http.post(url,body: data);
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final List<Checkin> checkin = checkinFromJson(response.body);
          return checkin;
        }
      } else {
        return List<Checkin>();
      }
    } catch (e) {
      return List<Checkin>();
    }
  }

  @override
  void initState() {
    Timer(Duration(seconds: 1), () {
      if (!_disposed)
        setState(() {
          time = time.add(Duration(seconds: -1));
        });
    });
    super.initState();
    _loading = true;
    getCheckin(news).then((checkins) {
      setState(() {
        _checkin = checkins;
        if (_checkin.length == 0) {
          // showAlertNullData();
          _loading = false;

        } else {
          max = _checkin.length;
          if (_checkin.length > 10) {
            _checkin = List.generate(10, (index) => _checkin[index]);
          } else {
            _checkin = checkins;
          }
          min = _checkin.length;
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

  getMoreData() {
    if (min == 10) {
      for (int i = _currentMax; i < max - 1; i++) {
        getCheckin(news).then((checkins) {
          setState(() {
            _checkin = checkins;
            _checkin.add(_checkin[i]);
            _checkin.length = max;
            _loading = false;
            if (_checkin.isNotEmpty) {
              return _checkin.elementAt(0);
            }
          });
        });
      }
      if (_checkin.length == max) {
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

  showAlertUpdate(String news) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("ท่านต้องการเริ่มงานใช่หรือไม่"),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  showAlertsuccess();
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

  poststatus(String news) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") != null) {
      Map data = {
        'issuesid': news.toString(),
        'user': sharedPreferences.getString("name"),
      };
      var jsonData = null;
      var response = await http
          .post("http://10.57.34.148:8000/api/issues-poststatus", body: data);
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        if (jsonData != null) {

        }
      } else {
        print(response.body);
      }
    }
  }

  showAlertsuccess() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("อัพเดทสำเร็จ"),
            actions: [
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                  poststatus(news);
                  Navigator.pop(context);
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
          child: Padding(
              padding: EdgeInsets.only(right: 40),
              child: Text(_loading ? 'Loading...' : "Checkin-Checkout")),
        ),
        backgroundColor: Color(0xFF34558b),
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
      itemCount: null == _checkin ? 0 : _checkin.length + 1,
      itemExtent: 100,
      itemBuilder: (context, index) {
        if (_checkin.length == 0) {
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.symmetric(
                  horizontal: 80.0),
              child: RaisedButton(
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    showAlertUpdate(news);
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(5.0),
                ),
                child: Text(
                  "Checkin",
                  style:
                  TextStyle(color: Colors.white70),
                ),
              ),
            ),
            // Text(
            //   "ไม่พบข้อมูลงาน",
            //   style: TextStyle(color: Colors.white70, fontSize: 20),
            // ),
          );
        } else {
          if (index == _checkin.length) {
            return  Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 5.0,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(
                    horizontal: 20.0),
                child: RaisedButton(
                  color: Colors.green,
                  onPressed: () {
                    setState(() {
                      // _showLogoutAlertDialog();
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    "Checkin",
                    style:
                    TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            );
          } else if (index == _checkin.length &&
              _checkin.length <= 10 &&
              index <= 10) {
            return Center(child: Text(""));
          }
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
                      color:
                      Color(0xFFf2f6f5),
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
                          flex: 4,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Cid : "+_checkin[index].checkinid.toString(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                "Id : " + _checkin[index].issuesid.toString(),
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                "Status : " + _checkin[index].status.toString(),
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                "Createat : " +
                                    formatter.formatInBuddhistCalendarThai(
                                        _checkin[index].createdAt),
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
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => IssuesNewDetail(_new[index])),
            // );
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
        getCheckin(news).then((checkins) {
          setState(() {
            _checkin = checkins;
            max = _checkin.length;
            // _new = List.generate(10, (index) => _new[index]);
            min = _checkin.length;
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
