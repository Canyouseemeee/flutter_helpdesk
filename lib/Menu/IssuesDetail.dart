import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_helpdesk/Menu/IssuesCheckin.dart';
import 'package:flutter_helpdesk/Menu/IssuesComment.dart';
import 'package:flutter_helpdesk/services/Deviceinfo.dart';
import 'package:flutter_helpdesk/services/Jsondata.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_helpdesk/Models/Closed.dart';
import 'package:flutter_helpdesk/Models/Defer.dart';
import 'package:flutter_helpdesk/Models/New.dart';
import 'package:intl/intl.dart';
import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class IssuesDeferDetail extends StatefulWidget {
  Defer defer;
  IssuesDeferDetail(this.defer);

  @override
  _IssuesDeferDetailState createState() => _IssuesDeferDetailState(defer);
}

class _IssuesDeferDetailState extends State<IssuesDeferDetail> {
  Defer defer;
  _IssuesDeferDetailState(this.defer);

  String statuscheckin;
  String count;
  DateTime time = DateTime.now();
  bool _disposed = false;
  bool _loading;
  var formatter = DateFormat.yMd().add_jm();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading = true;
    Timer(Duration(seconds: 1), () {
      if (!_disposed)
        setState(() {
          time = time.add(Duration(seconds: -1));
        });
    });
    getCommentCount();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_loading ? 'Loading...' : "Detail"),
        backgroundColor: Color(0xFF34558b),
      ),
      body: (_loading
          ? new Center(
          child: new CircularProgressIndicator(
            backgroundColor: Colors.white70,
          ))
          : ListView(
          children: <Widget>[
            _titleSection(context),
          ]
      )
      ),
      backgroundColor: Color(0xFF34558b),
    );
  }

  _heaaderImageSection() {
    if (defer.trackName.toString() == "HW") {
      return Padding(
        padding: EdgeInsets.only(top: 20),
        child: Image.asset(
          'assets/HW.png',
          height: 40,
          width: 40,
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: 20),
        child: Image.asset(
          'assets/SW.png',
          height: 40,
          width: 40,
        ),
      );
    }
  }

  getCommentCount() async {
    Map data = {'issuesid': defer.issuesid.toString()};
    var jsonData = null;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var response = await http
        .post("http://192.168.43.222:8000/api/issues-getcountComment", body: data);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      if (jsonData != null) {
        _loading = false;
        sharedPreferences.setString('count', jsonData['count'].toString());
        count = sharedPreferences.getString('count');
      }
    } else {
      print(response.body);
    }
  }

  Widget _titleSection(context) => Padding(
    padding: EdgeInsets.all(0),
    child: Card(
      child: Padding(
        padding: EdgeInsets.only(left: 8),
        child: Column(
          children: <Widget>[
            _heaaderImageSection(),
            SizedBox(
              height: 16,
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 150),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Issuesid : " + defer.issuesid.toString(),
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: RaisedButton(
                    color: Colors.green,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                IssuesCheckin(defer.issuesid.toString())),
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Text(
                      "CheckIn",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
              endIndent: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Subject = " + defer.subject,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
              endIndent: 10,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "TrackName = " + defer.trackName,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "SubTrackName = " + defer.subTrackName,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "SubName = " + defer.name,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Status = " + defer.issName,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Priority = " + defer.ispName,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Assignment = " + defer.assignment,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Tel = " + defer.tel.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Comname = " + defer.comname.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
              endIndent: 10,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Informer = " + defer.informer.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Department = " + defer.dmName,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Description = " + defer.description,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Createby = " + defer.createby,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "UpdateBy = " + defer.updatedby,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        "Created = " +
                            formatter.formatInBuddhistCalendarThai(
                                defer.createdAt),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Updated = " +
                            formatter.formatInBuddhistCalendarThai(
                                defer.updatedAt),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(
                    horizontal: 80.0),
                child:
                RaisedButton(
                  color: Colors.pink,
                  onPressed: () {
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                IssuesComment(defer.issuesid.toString())),
                      );
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    "Comment ("+count+")",
                    style:
                    TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

//Todo new
class IssuesNewDetail extends StatefulWidget {
  New news;
  IssuesNewDetail(this.news);

  @override
  _IssuesNewDetailState createState() => _IssuesNewDetailState(news);
}

class _IssuesNewDetailState extends State<IssuesNewDetail> {
  New news;
  _IssuesNewDetailState(this.news);
  String statuscheckin;
  String count;
  DateTime time = DateTime.now();
  bool _disposed = false;
  bool _loading;
  var formatter = DateFormat.yMd().add_jm();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading = true;
    Timer(Duration(seconds: 1), () {
      if (!_disposed)
        setState(() {
          time = time.add(Duration(seconds: -1));
        });
    });
    getCommentCount();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_loading ? 'Loading...' : "Detail"),
        backgroundColor: Color(0xFF34558b),
      ),
      body: (_loading
          ? new Center(
          child: new CircularProgressIndicator(
            backgroundColor: Colors.white70,
          ))
          : ListView(
        children: <Widget>[
          _titleSection(context),
        ]
      )
      ),
      backgroundColor: Color(0xFF34558b),
    );
  }

  _heaaderImageSection() {
    if (news.trackName.toString() == "HW") {
      return Padding(
        padding: EdgeInsets.only(top: 20),
        child: Image.asset(
          'assets/HW.png',
          height: 40,
          width: 40,
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: 20),
        child: Image.asset(
          'assets/SW.png',
          height: 40,
          width: 40,
        ),
      );
    }
  }

  getCommentCount() async {
    Map data = {'issuesid': news.issuesid.toString()};
    var jsonData = null;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var response = await http
        .post("http://192.168.43.222:8000/api/issues-getcountComment", body: data);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      if (jsonData != null) {
        _loading = false;
          sharedPreferences.setString('count', jsonData['count'].toString());
          count = sharedPreferences.getString('count');
      }
    } else {
      print(response.body);
    }
  }

  Widget _titleSection(context) => Padding(
        padding: EdgeInsets.all(0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.only(left: 8),
            child: Column(
              children: <Widget>[
                _heaaderImageSection(),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 150),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Issuesid : " + news.issuesid.toString(),
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 50),
                      child: RaisedButton(
                        color: Colors.green,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    IssuesCheckin(news.issuesid.toString())),
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Text(
                          "CheckIn",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Divider(
                  thickness: 1,
                  color: Colors.grey,
                  endIndent: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Subject = " + news.subject,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                  color: Colors.grey,
                  endIndent: 10,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "TrackName = " + news.trackName,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "SubTrackName = " + news.subTrackName,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "SubName = " + news.name,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Status = " + news.issName,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Priority = " + news.ispName,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Assignment = " + news.assignment,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Tel = " + news.tel.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Comname = " + news.comname.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Divider(
                  thickness: 1,
                  color: Colors.grey,
                  endIndent: 10,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Informer = " + news.informer.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Department = " + news.dmName,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Description = " + news.description,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Createby = " + news.createby,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "UpdateBy = " + news.updatedBy,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            "Created = " +
                                formatter.formatInBuddhistCalendarThai(
                                    news.createdAt),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Updated = " +
                                formatter.formatInBuddhistCalendarThai(
                                    news.updatedAt),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.symmetric(
                        horizontal: 80.0),
                    child:
                    RaisedButton(
                      color: Colors.pink,
                      onPressed: () {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    IssuesComment(news.issuesid.toString())),
                          );
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        "Comment ("+count+")",
                        style:
                        TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

//Todo Closed
class IssuesClosedDetail extends StatefulWidget {
  Closed closed;
  IssuesClosedDetail(this.closed);
  @override
  _IssuesClosedDetailState createState() => _IssuesClosedDetailState(closed);
}

class _IssuesClosedDetailState extends State<IssuesClosedDetail> {
  Closed closed;
  _IssuesClosedDetailState(this.closed);

  String statuscheckin;
  String count;
  DateTime time = DateTime.now();
  bool _disposed = false;
  bool _loading;
  var formatter = DateFormat.yMd().add_jm();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading = true;
    Timer(Duration(seconds: 1), () {
      if (!_disposed)
        setState(() {
          time = time.add(Duration(seconds: -1));
        });
    });
    getCommentCount();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _disposed = true;
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
        backgroundColor: Color(0xFF34558b),
      ),
      body: ListView(
        children: <Widget>[
          // _heaaderImageSection(),
          _titleSection(context),
        ],
      ),
      backgroundColor: Color(0xFF34558b),
    );
  }

  _heaaderImageSection() {
    if (closed.trackName.toString() == "HW") {
      return Image.asset(
        'assets/HW.png',
        height: 30,
        width: 30,
      );
    } else {
      return Image.asset(
        'assets/SW.png',
        height: 40,
        width: 40,
      );
    }
  }

  getCommentCount() async {
    Map data = {'issuesid': closed.issuesid.toString()};
    var jsonData = null;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var response = await http
        .post("http://192.168.43.222:8000/api/issues-getcountComment", body: data);
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      if (jsonData != null) {
        _loading = false;
        sharedPreferences.setString('count', jsonData['count'].toString());
        count = sharedPreferences.getString('count');
      }
    } else {
      print(response.body);
    }
  }

  Widget _titleSection(context) => Padding(
    padding: EdgeInsets.all(0),
    child: Card(
      child: Padding(
        padding: EdgeInsets.only(left: 8),
        child: Column(
          children: <Widget>[
            _heaaderImageSection(),
            SizedBox(
              height: 16,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Issuesid : " + closed.issuesid.toString(),
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
              endIndent: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Subject = " + closed.subject,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
              endIndent: 10,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "TrackName = " + closed.trackName,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "SubTrackName = " + closed.subTrackName,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "SubName = " + closed.name,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Status = " + closed.issName,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Priority = " + closed.ispName,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Assignment = " + closed.assignment,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Tel = " + closed.tel.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Comname = " + closed.comname.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Divider(
              thickness: 1,
              color: Colors.grey,
              endIndent: 10,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Informer = " + closed.informer.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Department = " + closed.dmName,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Description = " + closed.description,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Createby = " + closed.createby,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "UpdateBy = " + closed.updatedBy,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "ClosedBy = " + closed.closedBy,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Created = " +
                            formatter.formatInBuddhistCalendarThai(
                                closed.createdAt),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Updated = " +
                            formatter.formatInBuddhistCalendarThai(
                                closed.updatedAt),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Closed = " +
                            formatter.formatInBuddhistCalendarThai(
                                closed.createAt),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(
                    horizontal: 80.0),
                child:
                RaisedButton(
                  color: Colors.pink,
                  onPressed: () {
                    setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                IssuesComment(closed.issuesid.toString())),
                      );
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    "Comment ("+count+")",
                    style:
                    TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
