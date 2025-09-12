import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ApiService({required this.baseUrl});

  // Get token safely
  Future<String> _getToken() async {
    final token = await _secureStorage.read(key: "token");
    if (token == null) {
      return "";
    }
    return token;
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String path) async {
    try {
      final headers = await _getHeaders();
      final res = await http.get(Uri.parse(baseUrl + path), headers: headers);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return jsonDecode(res.body);
      } else if (res.statusCode == 401) {
        throw Exception("Unauthorized: Token may have expired.");
      } else {
        throw Exception('GET failed with status: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('GET error: $e');
    }
  }

  Future<dynamic> post(String path, Map body) async {
    try {
      final headers = await _getHeaders();
      final res = await http.post(Uri.parse(baseUrl + path),
          headers: headers, body: jsonEncode(body));

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return jsonDecode(res.body);
      } else if (res.statusCode == 401) {
        throw Exception("Unauthorized: Token may have expired.");
      } else {
        throw Exception('POST failed with status: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('POST error: $e');
    }
  }

  Future<dynamic> put(String path, Map body) async {
    try {
      final headers = await _getHeaders();
      final res = await http.put(Uri.parse(baseUrl + path),
          headers: headers, body: jsonEncode(body));

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return jsonDecode(res.body);
      } else if (res.statusCode == 401) {
        throw Exception("Unauthorized: Token may have expired.");
      } else {
        throw Exception('PUT failed with status: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('PUT error: $e');
    }
  }

  Future<dynamic> delete(String path) async {
    try {
      final headers = await _getHeaders();
      final res =
          await http.delete(Uri.parse(baseUrl + path), headers: headers);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return jsonDecode(res.body);
      } else if (res.statusCode == 401) {
        throw Exception("Unauthorized: Token may have expired.");
      } else {
        throw Exception('DELETE failed with status: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('DELETE error: $e');
    }
  }
}
