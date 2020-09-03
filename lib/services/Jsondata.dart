import 'package:flutter_helpdesk/Models/Closed.dart';
import 'package:flutter_helpdesk/Models/Defer.dart';
import 'package:flutter_helpdesk/Models/MacAddress.dart';
import 'package:flutter_helpdesk/Models/New.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_helpdesk/Models/Closed.dart';

class Jsondata {

  static Future<List<Closed>> getClosed() async {
    const String url = "http://cnmihelpdesk.rama.mahidol.ac.th/api/issues-closed";
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<Closed> closeds = ClosedFromJson(response.body);
        return closeds;
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
        final List<Defer> defers = DeferFromJson(response.body);
        return defers;
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
        final List<New> news = NewFromJson(response.body);
        return news;
      } else {
        return List<New>();
      }
    } catch (e) {
      return List<New>();
    }
  }

  static Future<List<MacAddress>> getMacAddress() async {
    const String url = "http://10.57.34.148:8000/api/issues-getMacAddress";
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<MacAddress> macaddress = macAddressFromJson(response.body);
        return macaddress;
      } else {
        return List<MacAddress>();
      }
    } catch (e) {
      return List<MacAddress>();
    }
  }

}
