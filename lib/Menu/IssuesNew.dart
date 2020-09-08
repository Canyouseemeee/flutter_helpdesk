import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_helpdesk/Menu/IssuesDetail.dart';
import 'package:flutter_helpdesk/Models/New.dart';
import 'package:flutter_helpdesk/screens/login.dart';
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
  int _currentIndex = 0;
  var formatter = DateFormat.yMd().add_jm();

//  MainPage one = new MainPage();
  IssuesNew news = new IssuesNew();
  IssuesDefer defer = new IssuesDefer();
  IssuesClosed closed = new IssuesClosed();
  List<Widget> pages;
  Widget currantpage;
  List<New> _new;
  bool _loading;
  int _total = 0;

  @override
  void initState() {
    super.initState();
    // checkLoginStatus();
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
      appBar: AppBar(
        title: Align(
            alignment: Alignment.center,
            child: Text(_loading ? 'Loading...' : "New")),
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
          scrollDirection: Axis.vertical,
          itemCount: _new.length,
          itemBuilder: (context, index) {
            New news = _new[index];
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
                                    news.subject,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    news.issuesid.toString(),
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    news.trackName,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    formatter.formatInBuddhistCalendarThai(
                                        news.updatedAt),
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
                      builder: (context) => IssuesNewDetail(news)),
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
