import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/city_model.dart';
import '../models/weather_model.dart';

class ApiService {
  static const String _geoBaseUrl = 'https://geocoding-api.open-meteo.com/v1/';
  static const String _weatherBaseUrl = 'https://api.open-meteo.com/v1';

  Future<List<Results>> searchCities(String query) async {
    if (query.isEmpty) return [];
    final uri = Uri.parse('$_geoBaseUrl/search?name=$query');
    try {
      final response = await http.get(uri);
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        City cityResponse = City.fromJson(jsonMap);
        if (cityResponse.results == null) {
          return [];
        }
        return cityResponse.results!;
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load cities. Please try again. Error: $e');
    }
  }



  Future<Weather> getWeather(double lat, double lon) async {
    final response = await http.get(
      Uri.parse('$_weatherBaseUrl/forecast?latitude=$lat&longitude=$lon&current_weather=true'),);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Weather.fromJson(data['current_weather']);
    } else {
      throw Exception('Failed to load weather');
    }
  }
}