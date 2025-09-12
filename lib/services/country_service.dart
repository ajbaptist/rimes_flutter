import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rimes_flutter/models/country_model.dart';

class CountryService {
  Future<List<String>> fetchCountryNames() async {
    final res = await http.get(
      Uri.parse('https://restcountries.com/v3.1/all?fields=name'),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to fetch countries: ${res.statusCode}');
    }

    final data = countryDataFromJson(res.body);

    return data.map((e) => e.name.common).toList();
  }
}
