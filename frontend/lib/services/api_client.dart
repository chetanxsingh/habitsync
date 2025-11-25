import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/utils/api_config.dart';
import '../core/utils/token_storage.dart';

class ApiClient {
  static Future<Map<String, String>> _headers() async {
    final token = await TokenStorage.load();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Uri _buildUri(String path) {
    return Uri.parse('${ApiConfig.baseUrl}$path');
  }

  static Future<http.Response> get(String path) async {
    final res = await http.get(_buildUri(path), headers: await _headers());
    _checkError(res);
    return res;
  }

  static Future<http.Response> post(String path, {Object? body}) async {
    final res = await http.post(
      _buildUri(path),
      headers: await _headers(),
      body: body == null ? null : jsonEncode(body),
    );
    _checkError(res);
    return res;
  }

  static Future<http.Response> put(String path, {Object? body}) async {
    final res = await http.put(
      _buildUri(path),
      headers: await _headers(),
      body: body == null ? null : jsonEncode(body),
    );
    _checkError(res);
    return res;
  }

  static Future<http.Response> delete(String path) async {
    final res = await http.delete(_buildUri(path), headers: await _headers());
    _checkError(res);
    return res;
  }

  static void _checkError(http.Response res) {
    if (res.statusCode >= 400) {
      throw Exception(
          'API Error ${res.statusCode}: ${res.body.isNotEmpty ? res.body : 'No message'}');
    }
  }
}