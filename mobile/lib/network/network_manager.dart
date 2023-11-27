import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:memories_app/util/sp_helper.dart';

class _NetworkConstant {
  static const String baseURL = 'http://34.72.72.115:8000/';
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
  static const Utf8Decoder utf8Decoder = Utf8Decoder();

  static NetworkManager? _instance;

  factory NetworkManager({String baseUrl = _NetworkConstant.baseURL}) {
    _instance ??= NetworkManager._internal(baseUrl: baseUrl);
    return _instance!;
  }

  NetworkManager._internal({required this.baseUrl});

  Future<dynamic> get(String endpoint) async {
    if (!await _isConnectedToInternet()) {
      throw const SocketException('');
    } else {
      Map<String, String> customHeaders = await _constructHeaders();
      final http.Response response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: customHeaders,
      );

      return _createResponse(response);
    }
  }

  Future<dynamic> post(String endpoint, {Object? body}) async {
    if (!await _isConnectedToInternet()) {
      throw const SocketException('');
    }
    Map<String, String> customHeaders = await _constructHeaders();
    final http.Response response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        body: jsonEncode(body),
        headers: customHeaders);

    return _createResponse(response);
  }

  Future<Map<String, String>> _constructHeaders() async {
    final String? refreshToken =
        await SPHelper.getString(SPKeys.refreshTokenKey);
    final Map<String, String> customHeaders = <String, String>{
      'Content-Type': 'application/json',
      if (refreshToken != null) 'Cookie': 'refreshToken=$refreshToken',
    };
    return customHeaders;
  }

  Result _createResponse(http.Response response) {
    Map<String, dynamic> responseJson = <String, dynamic>{};

    try {
      final String responseString = utf8Decoder.convert(response.bodyBytes);
      responseJson = json.decode(responseString) as Map<String, dynamic>;
    } on Exception {
      responseJson = <String, dynamic>{};
    }

    return Result(responseJson, response.statusCode);
  }

  Future<bool> _isConnectedToInternet() async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }
}
