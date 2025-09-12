import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rimes_flutter/utils/api_constants.dart';
import '../models/analytics_model.dart';

class AnalyticsRepository {
  Future<AnayticsModel> fetchAnalytics() async {
    final response =
        await http.get(Uri.parse("${APiConstants.baseURL}/api/stats"));
    if (response.statusCode == 200) {
      return AnayticsModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to fetch analytics data");
    }
  }
}
