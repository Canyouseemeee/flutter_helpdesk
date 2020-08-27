import 'package:flutter/material.dart';
import 'package:flutter_helpdesk/Models/Closed.dart';
import 'package:flutter_helpdesk/Models/Defer.dart';
import 'package:flutter_helpdesk/Models/New.dart';
import 'package:intl/intl.dart';
import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';

class IssuesDeferDetail extends StatelessWidget {
  Defer defer;

  IssuesDeferDetail(this.defer);

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

  Widget _titleSection(context) => Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              defer.issuesid.toString(),
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "TrackName = " + defer.trackName.toString().substring(10),
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "SubTrackName = " + defer.subTrackName.toString().substring(13),
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Name = " + defer.name.toString(),
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Status = " + defer.issName.toString().substring(8),
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Priority = " + defer.ispName.toString().substring(8),
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Subject = " + defer.subject,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Description = " + defer.description,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Created = " + defer.createdAt.toString(),
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Updated = " + defer.updatedAt.toString(),
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Users = " + defer.users.toString().substring(6),
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
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

  Widget _titleSection(context) => Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              news.issuesid.toString(),
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "TrackName = " + news.trackName,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "SubTrackName = " + news.subTrackName,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Name = " + news.name,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Status = " + news.issName,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Priority = " + news.ispName,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Subject = " + news.subject,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Description = " + news.description,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Created = " +
                  formatter.formatInBuddhistCalendarThai(news.createdAt),
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Updated = " +
                  formatter.formatInBuddhistCalendarThai(news.updatedAt),
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Users = " + news.users,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
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

  Widget _titleSection(context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: <Widget>[
              Container(
                height: 500,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(_borderRadius),
                //   gradient: LinearGradient(
                //     colors: [Colors.white, Colors.red],
                //     begin: Alignment.topLeft,
                //     end: Alignment.bottomRight,
                //   ),
                // ),
              ),
              Positioned.fill(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: [
                        Text(
                          "Issuesid: "+closed.issuesid.toString(),
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "TrackName = " + closed.trackName,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "SubTrackName = " + closed.subTrackName,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Name = " + closed.name,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Status = " + closed.issName,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Priority = " + closed.ispName,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Subject = " + closed.subject,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Description = " + closed.description,
                          style: TextStyle(
                            color: Colors.black,
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
                            color: Colors.black,
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
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Users = " + closed.users,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
