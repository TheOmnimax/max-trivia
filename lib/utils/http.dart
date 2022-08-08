import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:max_trivia/constants/constants.dart';

class Http {
  static Future<http.Response> post({
    required String uri,
    required Map<String, dynamic> body,
    //TODO: Add way to add additional headers
  }) async {
    print('Running request to $uri');
    print('Body:');
    print(body);
    final encodedBody = json.encode(body);
    final response = await http.post(
      Uri.parse(uri),
      headers: sendHeaders,
      body: encodedBody,
    );

    if (response.statusCode >= 500) {
      print('${response.statusCode} ${response.reasonPhrase}');
    }
    return response;
  }

  static Map<String, dynamic> jsonDecode(String data) {
    return json.decode(data) as Map<String, dynamic>;
  }
}
