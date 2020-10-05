import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_helpdesk/Models/Checkin.dart';
import 'package:image_picker/image_picker.dart';
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
  final double _borderRadius = 25;
  int _currentMax = 10;
  var max;
  var min;
  var formatter = DateFormat.yMd().add_jm();
  ScrollController _scrollController = new ScrollController();
  List<Checkin> _checkin;
  DateTime time = DateTime.now();
  bool _disposed = false;
  TextEditingController commentController = new TextEditingController();


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

  showAlertCheckout(String news) async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text("ท่านต้องการปิดงานหรือสานงานต่อ ?"),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showDialog();
                },
                child: Text("ปิดงาน"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showDialog2();
                },
                child: Text("สานงานต่อ"),
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

  closedstatus(String news,String comment) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") != null) {
      Map data = {
        'issuesid': news.toString(),
        'user': sharedPreferences.getString("name"),
        'comment': comment,
      };
      var jsonData = null;
      var response = await http
          .post("http://10.57.34.148:8000/api/issues-checkclosedstatus", body: data);
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        if (jsonData != null) {

        }
      } else {
        print(response.body);
      }
    }
  }

  keepstatus(String news,String comment) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") != null) {
      Map data = {
        'issuesid': news.toString(),
        'user': sharedPreferences.getString("name"),
        'comment': comment,
      };
      var jsonData = null;
      var response = await http
          .post("http://10.57.34.148:8000/api/issues-checkkeepstatus", body: data);
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

  showAlertupdatesuccess() async {
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
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        });
  }

  _showDialog() async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      child: new AlertDialog(
        title: Text('Comment'),
        content: Stack(
          children:<Widget>[
            TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: commentController,
              decoration: InputDecoration(hintText: "Comment",icon: Icon(Icons.comment)),
            ),
          ],
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text('SAVE'),
            onPressed: () {
              closedstatus(news,commentController.text);
              Navigator.pop(context);
              showAlertupdatesuccess();
            },
          ),
          new FlatButton(
            child: new Text('Close'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  _showDialog2() async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      child: new AlertDialog(
        title: Text('Comment'),
        content: TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: commentController,
          decoration: InputDecoration(hintText: "Comment",icon: Icon(Icons.comment)),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text('SAVE'),
            onPressed: () {
              keepstatus(news,commentController.text);
              Navigator.pop(context);
              showAlertupdatesuccess();
            },
          ),
          new FlatButton(
            child: new Text('Close'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
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
        floatingActionButton: Padding(
          padding: EdgeInsets.only(left: 40),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              margin: EdgeInsets.only(top: 650),
              padding: EdgeInsets.symmetric(
                  horizontal: 80.0),
              child:
              RaisedButton(
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    showAlertUpdate(news);
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(30.0),
                ),
                child: Text(
                  "Checkin",
                  style:
                  TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ),
        ),
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
            child:
            Text(
              "ไม่พบข้อมูลงาน",
              style: TextStyle(color: Colors.white70, fontSize: 20),
            ),
          );
        } else {
          if (index == _checkin.length && _checkin.length > 10 && index > 10) {
            return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white70,
                ));
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
                      borderRadius: BorderRadius.circular(15.0),
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
                          child: Padding(
                            padding: EdgeInsets.only(left: 20),
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
                        ),
                        Expanded(
                          flex: 9,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextStatus(index),
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
                        showButton(index),
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

  TextStatus(int index){
    if (_checkin[index].status == 1) {
     return Text(
        "Status : Active",
        style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700),
      );
    }else if(_checkin[index].status == 2){
      return Text(
        "Status : Closed",
        style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700),
      );
    }else if(_checkin[index].status == 3){
      return Text(
        "Status : Keep on",
        style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700),
      );
    }
  }

  showButton(int index){
    if (_checkin[index].status == 1) {
      return Padding(
        padding: EdgeInsets.all(4),
        child: RaisedButton(
          color: Colors.red,
          onPressed: () {
            setState(() {
              // showAlertUpdate(news);
              showAlertCheckout(news);
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(30.0),
          ),
          child: Text(
            "CheckOut",
            style:
            TextStyle(color: Colors.white70),
          ),
        ),
      );
    }else if(_checkin[index].status == 2){
      return Text(
        "",
        style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700),
      );
    }else if(_checkin[index].status == 3){
      return Padding(
        padding: EdgeInsets.all(4),
        child: RaisedButton(
          color: Colors.red,
          onPressed: () {
            setState(() {
              // showAlertUpdate(news);
              showAlertCheckout(news);
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(30.0),
          ),
          child: Text(
            "CheckOut",
            style:
            TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

  }


}
