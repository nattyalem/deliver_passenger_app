import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:koooly_user/constants/data_constants.dart';

class RequestHandlerService {
  static late http.Response response;

  static Future<dynamic> getRequest(String url) async {
    response = await http.get(Uri.parse(url));

    try {
      if (response.statusCode == 200) {
        String jsonData = response.body;
        var decodedData = jsonDecode(jsonData);
        return decodedData;
      } else {
        return responseFailed;
      }
    } catch (exp) {
      return responseFailed;
    }
  }

  static Future<dynamic> postRequest(
      String url, Map<String, String> header, String body) async {
    response = await http.post(Uri.parse(url), body: body, headers: header);

    try {
      if (response.statusCode == 200) {
        String jsonData = response.body;
        var decodedData = jsonDecode(jsonData);
        return decodedData;
      } else {
        return responseFailed;
      }
    } catch (exp) {
      return responseFailed;
    }
  }
}
