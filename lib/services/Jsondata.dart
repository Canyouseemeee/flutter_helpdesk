import 'package:flutter_helpdesk/Models/Closed.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_helpdesk/Models/Closed.dart';

class Jsondata {
  static const String url = "http://10.57.34.148:8000/api/issues";

  static Future<List<Closed>> getClosed() async {
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
}
