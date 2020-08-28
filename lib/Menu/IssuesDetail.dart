import 'package:flutter/material.dart';
import 'package:flutter_helpdesk/Models/Closed.dart';
import 'package:flutter_helpdesk/Models/Defer.dart';
import 'package:flutter_helpdesk/Models/New.dart';
import 'package:intl/intl.dart';
import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';

class IssuesDeferDetail extends StatelessWidget {
  Defer defer;

  IssuesDeferDetail(this.defer);

  var formatter = DateFormat.yMd().add_jm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
      ),
      body: ListView(
        children: <Widget>[
          _heaaderImageSection(),
          _titleSection(context),
        ],
      ),
    );
  }

  Widget _heaaderImageSection() => Image.asset(
        'assets/mac-os.png',
        height: 40,
        width: 40,
      );

  Widget _titleSection(context) => Padding(
        padding: EdgeInsets.all(0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.only(left: 8),
            child: Column(
              children: <Widget>[
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
                            "Subject = " + defer.subject,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
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
                            "TrackName = " +
                                defer.trackName.toString().substring(10),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "SubTrackName = " +
                                defer.subTrackName.toString().substring(13),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Name = " + defer.name.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
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
                            "Status = " + defer.issName.toString().substring(8),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Priority = " +
                                defer.ispName.toString().substring(8),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            "Users = " + defer.users.toString().substring(6),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
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
                            "Description = " + defer.description,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
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
              ],
            ),
          ),
        ),
      );
}

//Todo new
class IssuesNewDetail extends StatelessWidget {
  New news;

  IssuesNewDetail(this.news);

  var formatter = DateFormat.yMd().add_jm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
      ),
      body: ListView(
        children: <Widget>[
          _heaaderImageSection(),
          _titleSection(context),
        ],
      ),
    );
  }

  Widget _heaaderImageSection() => Image.asset(
        'assets/mac-os.png',
        height: 40,
        width: 40,
      );

  Widget _titleSection(context) => Padding(
    padding: EdgeInsets.all(0),
    child: Card(
      child: Padding(
        padding: EdgeInsets.only(left: 8),
        child: Column(
          children: <Widget>[
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
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
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
                        "TrackName = " +
                            news.trackName,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "SubTrackName = " +
                            news.subTrackName,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Name = " + news.name,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
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
                        "Status = " + news.issName,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Priority = " +
                            news.ispName,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Users = " + news.users,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
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
      ),
      body: ListView(
        children: <Widget>[
          _heaaderImageSection(),
          _titleSection(context),
        ],
      ),
    );
  }

  Widget _heaaderImageSection() => Image.asset(
        'assets/mac-os.png',
        height: 40,
        width: 40,
      );

  Widget _titleSection(context) => Padding(
    padding: EdgeInsets.all(0),
    child: Card(
      child: Padding(
        padding: EdgeInsets.only(left: 8),
        child: Column(
          children: <Widget>[
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
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
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
                        "TrackName = " +
                            closed.trackName,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "SubTrackName = " +
                            closed.subTrackName,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Name = " + closed.name,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
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
                        "Status = " + closed.issName,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Priority = " +
                            closed.ispName,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Users = " + closed.users,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
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
