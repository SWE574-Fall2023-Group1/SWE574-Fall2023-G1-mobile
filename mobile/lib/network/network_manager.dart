// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:memories_app/util/sp_helper.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';

class NetworkConstant {
  static const String baseURL = 'http://34.68.58.169:8000/';
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

  factory NetworkManager({String baseUrl = NetworkConstant.baseURL}) {
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
    String test = jsonEncode(body);
    debugPrint(test);

    Map<String, String> customHeaders = await _constructHeaders();
    final http.Response response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        body: jsonEncode(body),
        headers: customHeaders);

    debugPrint(response.body);

    return _createResponse(response);
  }

  Future<dynamic> put(String endpoint, {Object? body}) async {
    if (!await _isConnectedToInternet()) {
      throw const SocketException('');
    }
    String test = jsonEncode(body);
    debugPrint(test);

    Map<String, String> customHeaders = await _constructHeaders();
    final http.Response response = await http.put(
        Uri.parse('$baseUrl/$endpoint'),
        body: jsonEncode(body),
        headers: customHeaders);

    debugPrint(response.body);

    return _createResponse(response);
  }

  Future<dynamic> putFile(String endpoint, {required dio.FormData body}) async {
    if (!await _isConnectedToInternet()) {
      throw const SocketException('');
    }

    Map<String, String> customHeaders = await _constructHeaders();
    Uri uri = Uri.parse('$baseUrl/$endpoint');

    // Create a multipart request
    http.MultipartRequest request = http.MultipartRequest('PUT', uri)
      ..headers.addAll(customHeaders);

    // Add fields from the FormData to the request
    body.fields.forEach((MapEntry<String, String> field) {
      request.fields[field.key] = field.value;
    });

    // Add files from the FormData to the request
    for (MapEntry<String, dio.MultipartFile> fileEntry in body.files) {
      dio.MultipartFile file = fileEntry.value;

      // Create a new stream from the file's finalize method
      http.ByteStream stream = http.ByteStream(file.finalize());

      http.MultipartFile multipartFile = http.MultipartFile(
        fileEntry.key,
        stream,
        file.length,
        filename: file.filename,
        contentType: MediaType.parse('multipart/form-data'),
      );

      request.files.add(multipartFile);
    }

    // Send the request
    http.StreamedResponse response = await request.send();

    // Retrieve the response
    return _createResponse(await http.Response.fromStream(response));
  }

  Future<dynamic> delete(String endpoint) async {
    if (!await _isConnectedToInternet()) {
      throw const SocketException('');
    } else {
      Map<String, String> customHeaders = await _constructHeaders();
      final http.Response response = await http.delete(
        Uri.parse('$baseUrl/$endpoint'),
        headers: customHeaders,
      );

      return _createResponse(response);
    }
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

  static Future<String?> fetchMapUrl(Uri uri,
      {Map<String, String>? headers}) async {
    try {
      final http.Response response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
