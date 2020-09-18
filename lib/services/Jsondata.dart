import 'package:flutter_helpdesk/Models/Closed.dart';
import 'package:flutter_helpdesk/Models/Defer.dart';
import 'package:flutter_helpdesk/Models/New.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_helpdesk/Models/Closed.dart';

class Jsondata {

  static Future<List<Closed>> getClosed() async {
    const String url = "http://cnmihelpdesk.rama.mahidol.ac.th/api/issues-closed";
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
    const String url = "http://cnmihelpdesk.rama.mahidol.ac.th/api/issues-defer";
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
    const String url = "http://cnmihelpdesk.rama.mahidol.ac.th/api/issues-new";
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

}
