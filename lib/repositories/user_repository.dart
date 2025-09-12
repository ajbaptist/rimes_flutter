import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rimes_flutter/models/user_model.dart';

class UserRepository {
  final String baseUrl;

  UserRepository({required this.baseUrl});

  Future<UserModel> fetchUserProfile(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/users/$userId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to load user profile');
    }
  }
}
