import 'dart:async';
import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helpdesk/Menu/AppointmentsDetail.dart';
import 'package:flutter_helpdesk/Models/IssuesAppointments.dart';
import 'package:flutter_helpdesk/services/Jsondata.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Appointments extends StatefulWidget {
  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  final double _borderRadius = 24;
  SharedPreferences sharedPreferences;
  List<IssuesAppointments> _appointments;
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
    // checkLoginStatus();
    _loading = true;
    Jsondata.getAppointments().then((appointment) {
      setState(() {
        _appointments = appointment;
        if (_appointments.length == 0) {
          // showAlertNullData();
        } else {
          max = _appointments.length;
          if (_appointments.length > 10) {
            _appointments = List.generate(10, (index) => _appointments[index]);
          } else {
            _appointments = _appointments;
          }
          min = _appointments.length;
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
        Jsondata.getAppointments().then((appointment) {
          setState(() {
            _appointments = appointment;
            _appointments.add(_appointments[i]);
            _appointments.length = max;
            _loading = false;
            if (_appointments.isNotEmpty) {
              return _appointments.elementAt(0);
            }
          });
        });
      }
      _currentMax = _currentMax + 10;
      if (_appointments.length == max) {
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
  Widget build(BuildContext context) {
    return Scaffold(
//Todo Appbar
      appBar: AppBar(
        title: Align(
            alignment: Alignment.center,
            child: Padding(
                padding: EdgeInsets.only(right: 40),
                child: Text(_loading ? 'Loading...' : "Appointments"))),
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
          itemCount: null == _appointments ? 0 : _appointments.length + 1,
          itemExtent: 100,
          itemBuilder: (context, index) {
            // Defer _defer[index] = _defer[index];
            if (_appointments.length == 0) {
              return Center(
                child: Text(
                  "ไม่พบข้อมูลงาน",
                  style: TextStyle(color: Colors.white70, fontSize: 20),
                ),
              );
            } else {
              if (index == _appointments.length &&
                  _appointments.length > 10 &&
                  index > 10) {
                return Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Colors.white70,
                ));
              } else if (index == _appointments.length &&
                  _appointments.length <= 10 &&
                  index <= 10) {
                return Center(child: Text(""));
              }
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
                              flex: 11,
                              child: Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Date : " +
                                          formatter
                                              .formatInBuddhistCalendarThai(
                                                  _appointments[index].date),
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      "IssuesId : " +
                                          _appointments[index]
                                              .issuesid
                                              .toString(),
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 9,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Status(index),
                                  // Text(
                                  //   "Status : " +
                                  //       _appointments[index].status.toString(),
                                  //   style: TextStyle(
                                  //       color: Colors.black87,
                                  //       fontWeight: FontWeight.w700),
                                  // ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    "CreateBy : " +
                                        _appointments[index].createby,
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
                //todo detail appointments
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AppointmentDetail(_appointments[index])),
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
        Jsondata.getAppointments().then((appointments) {
          setState(() {
            _appointments = appointments;
            _appointments = List.generate(10, (index) => _appointments[index]);
            _loading = false;
          });
        });
        if (mounted) {
          setState(() {
            Text("No Data");
          });
        }
      });
    });

    return null;
  }

  Status(int index){
    if (_appointments[index].status == 1) {
      return Text(
        "Status : Active",
        style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700),
      );
    }
  }
}
