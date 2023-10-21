import 'dart:convert';
import 'package:http/http.dart' as http;

class _NetworkConstant {
  static const baseURL = 'http://35.194.29.12:3000';
  static Map<String, String> headers = {'Content-Type': 'application/json'};
}

class Result {
  final dynamic json;
  final int statusCode;
  final bool success;

  static bool isSuccessful(int statusCode) =>
      statusCode >= 200 && statusCode < 300;

  Result(this.json, this.statusCode) : success = isSuccessful(statusCode);
}

class NetworkManager {
  final String baseUrl;
  static const utf8Decoder = Utf8Decoder();

  static NetworkManager? _instance;

  factory NetworkManager({String baseUrl = _NetworkConstant.baseURL}) {
    _instance ??= NetworkManager._internal(baseUrl: baseUrl);
    return _instance!;
  }

  NetworkManager._internal({required this.baseUrl});

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    return _createResponse(response);
  }

  Future<dynamic> post(String endpoint, Object body) async {
    final response = await http.post(Uri.parse('$baseUrl/$endpoint'),
        body: jsonEncode(body), headers: _NetworkConstant.headers);

    return _createResponse(response);
  }

  Result _createResponse(http.Response response) {
    Map<String, dynamic> responseJson = {};

    try {
      final responseString = utf8Decoder.convert(response.bodyBytes);
      responseJson = json.decode(responseString) as Map<String, dynamic>;
    } on Exception {
      responseJson = {};
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Result(responseJson, response.statusCode);
    } else {
      throw Exception('Failed load data. Status code: ${response.statusCode}');
    }
  }
}
