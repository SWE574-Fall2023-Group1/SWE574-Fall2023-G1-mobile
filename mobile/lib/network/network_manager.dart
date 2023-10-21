import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:memories_app/util/sp_helper.dart';

class _NetworkConstant {
  static const baseURL = 'http://34.72.72.115:8000/';
  static Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json'
  };
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

  /// INFO: get and post with headers methods use refresh token as headers.
  /// Use these methods for all the calls except register and login.
  Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'),
        headers: _NetworkConstant.defaultHeaders);
    return _createResponse(response);
  }

  Future<dynamic> getWithHeaders(String endpoint) async {
    final customHeaders = await _constructHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: customHeaders,
    );

    return _createResponse(response);
  }

  Future<dynamic> post(String endpoint, Object body) async {
    final response = await http.post(Uri.parse('$baseUrl/$endpoint'),
        body: jsonEncode(body), headers: _NetworkConstant.defaultHeaders);

    return _createResponse(response);
  }

  Future<dynamic> postWithHeaders(String endpoint, Object body) async {
    final customHeaders = await _constructHeaders();
    final response = await http.post(Uri.parse('$baseUrl/$endpoint'),
        body: jsonEncode(body), headers: customHeaders);

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

  /// INFO: Create custom headers map to use refreshToken if there is any in local storage
  Future<Map<String, String>> _constructHeaders() async {
    final String? refreshToken =
        await SPHelper.getString(SPKeys.refreshTokenKey);
    if (refreshToken != null) {
      final Map<String, String> customHeaders = {
        'Content-Type': 'application/json',
        'Cookie': 'refreshToken=$refreshToken'
      };

      return customHeaders;
    } else {
      return _NetworkConstant.defaultHeaders;
    }
  }
}
