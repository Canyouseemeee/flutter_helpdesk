import 'package:flutter/material.dart';
import 'package:flutter_helpdesk/Models/IssuesAppointments.dart';
import 'package:intl/intl.dart';
import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';


class AppointmentDetail extends StatelessWidget {
  IssuesAppointments appointments;
  final double _borderRadius = 24;

  AppointmentDetail(this.appointments);

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
          _titleSection(context),
        ],
      ),
      backgroundColor: Color(0xFF34558b),
    );
  }

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
                "Appointmentsid : " + appointments.appointmentsid.toString(),
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
                        "Date = " + formatter.formatInBuddhistCalendarThai(appointments.date),
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
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Status(),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Comment = " + appointments.comment,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
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
                      Text(
                        "Createby = " + appointments.createby,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "UpdateBy = " + appointments.updateby,
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
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Created = " +
                            formatter.formatInBuddhistCalendarThai(
                                appointments.createdAt),
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
                                appointments.updatedAt),
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

  Status(){
    if (appointments.status == 1) {
      return Text(
        "Status : Active",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      );
    }
  }
}
