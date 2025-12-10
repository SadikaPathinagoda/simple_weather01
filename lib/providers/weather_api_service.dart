import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';

class WeatherApiService {
  final http.Client _client;

  WeatherApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> fetchCurrentWeather(String city) async {
    final uri = Uri.parse(
      '$kOpenWeatherBaseUrl/weather?q=$city&appid=$kOpenWeatherApiKey&units=metric',
    );
    final res = await _client.get(uri);

    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load weather (${res.statusCode})');
    }
  }

  Future<Map<String, dynamic>> fetchFiveDayForecast(String city) async {
    final uri = Uri.parse(
      '$kOpenWeatherBaseUrl/forecast?q=$city&appid=$kOpenWeatherApiKey&units=metric',
    );
    final res = await _client.get(uri);

    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load forecast (${res.statusCode})');
    }
  }
  



}