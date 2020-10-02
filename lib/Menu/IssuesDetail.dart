import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_helpdesk/Menu/IssuesCheckin.dart';
import 'package:flutter_helpdesk/services/Deviceinfo.dart';
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

  var formatter = DateFormat.yMd().add_jm();

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
        backgroundColor: Color(0xFF34558b));
  }

  _heaaderImageSection() {
    if (defer.trackName.toString() == "HW") {
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
                    "Issuesid : " + defer.issuesid.toString(),
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
                            "Subject = " + defer.subject.toString(),
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
                            "Department = " + defer.dmName.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Description = " + defer.description.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
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
                Container(
                  child: RaisedButton(
                    color: Colors.green,
                    onPressed: () {
                      showAlertUpdate(defer.issuesid);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      "Checkin Issues",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          ),
          color: Color(0xFFf2f6f5),
        ),
      );

  showAlertUpdate(int issuesid) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("ต้องการปิดงานใช่หรือไม่ ?"),
            actions: [
              FlatButton(
                onPressed: () {
                  updatestatus(issuesid);
                  Navigator.pop(context);
                },
                child: Text("ใช่"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("ไม่"),
              ),
            ],
          );
        });
  }

  updatestatus(int issuesid) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") != null) {
      print(issuesid);
      print(sharedPreferences.getString("name"));
      Map data = {
        'issuesid': issuesid.toString(),
        'user': sharedPreferences.getString("name"),
      };
      var jsonData = null;
      var response = await http.post(
          "http://cnmihelpdesk.rama.mahidol.ac.th/api/issues-updatestatus",
          body: data);
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        if (jsonData != null) {
          showAlertsuccess();
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
            title: Text("ปิดงานสำเร็จ"),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => MainPage()),
                      (Route<dynamic> route) => false);
                },
                child: Text("OK"),
              ),
            ],
          );
        });
  }
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
  String statuscheckin;

  _IssuesNewDetailState(this.news);

  var formatter = DateFormat.yMd().add_jm();

  getstatus(int issuesid) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") != null) {
      Map data = {
        'issuesid': issuesid.toString(),
      };
      var jsonData = null;
      var response = await http
          .post("http://10.57.34.148:8000/api/issues-getstatus", body: data);
      if (response.statusCode == 200) {
        jsonData = json.decode(response.body);
        if (jsonData != null) {
          sharedPreferences.setString(
              "checkstatus", jsonData['status'].toString());
          // print(sharedPreferences.getString("checkstatus"));
          if (sharedPreferences.getString("checkstatus") != null) {
            statuscheckin = sharedPreferences
                .getString("checkstatus")
                .substring(10)
                .replaceAll("}]", "");
            print(statuscheckin);
          }
        }
      } else {
        print(response.body);
      }
    }
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
          _titleSection(context),
        ],
      ),
      backgroundColor: Color(0xFF34558b),
    );
  }

  _heaaderImageSection() {
    if (news.trackName.toString() == "HW") {
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
                    "Issuesid : " + news.issuesid.toString(),
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
                Container(
                  child: RaisedButton(
                    color: Colors.green,
                    onPressed: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IssuesCheckin(news.issuesid.toString())),
                      );
                      // showAlertUpdate(news.issuesid);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      "CheckIn",
                      style: TextStyle(color: Colors.white70),
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
class IssuesClosedDetail extends StatelessWidget {
  Closed closed;
  final double _borderRadius = 24;

  IssuesClosedDetail(this.closed);

  var formatter = DateFormat.yMd().add_jm();

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
              ],
            ),
          ),
        ),
      );
}
