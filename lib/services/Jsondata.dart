import 'package:flutter_helpdesk/Models/Checkin.dart';
import 'package:flutter_helpdesk/Models/IssuesAppointments.dart';
import 'package:flutter_helpdesk/Models/Closed.dart';
import 'package:flutter_helpdesk/Models/Defer.dart';
import 'package:flutter_helpdesk/Models/New.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_helpdesk/Models/Closed.dart';

class Jsondata {

  static Future<List<Closed>> getClosed() async {
    const String url = "http://10.57.34.148:8000/api/issues-closed";
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final List<Closed> closeds = ClosedFromJson(response.body);
          return closeds;
        }
      } else {
        return List<Closed>();
      }
    } catch (e) {
      return List<Closed>();
    }
  }

  static Future<List<Defer>> getDefer() async {
    const String url = "http://10.57.34.148:8000/api/issues-defer";
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final List<Defer> defers = DeferFromJson(response.body);
          return defers;
        }
      } else {
        return List<Defer>();
      }
    } catch (e) {
      return List<Defer>();
    }
  }

  static Future<List<New>> getNew() async {
    const String url = "http://10.57.34.148:8000/api/issues-new";
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final List<New> news = NewFromJson(response.body);
          return news;
        }

      } else {
        return List<New>();
      }
    } catch (e) {
      return List<New>();
    }
  }

  static Future<List<IssuesAppointments>> getAppointments() async {
    const String url = "http://10.57.34.148:8000/api/appointments";
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final List<IssuesAppointments> appointments = appointmentsFromJson(response.body);
          return appointments;
        }

      } else {
        return List<IssuesAppointments>();
      }
    } catch (e) {
      return List<IssuesAppointments>();
    }
  }

  // static Future<List<Checkin>> getCheckin() async {
  //   const String url = "http://10.57.34.148:8000/api/issues-getstatus";
  //   try {
  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       if (response.body.isNotEmpty) {
  //         final List<Checkin> checkin = checkinFromJson(response.body);
  //         return checkin;
  //       }
  //
  //     } else {
  //       return List<Checkin>();
  //     }
  //   } catch (e) {
  //     return List<Checkin>();
  //   }
  // }

}
