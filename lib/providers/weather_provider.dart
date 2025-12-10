import 'package:flutter/foundation.dart';
import 'package:simple_weather01/providers/weather_api_service.dart';

class WeatherProvider extends ChangeNotifier {
  WeatherProvider(this._api);

  final WeatherApiService _api;
  List<Map<String, dynamic>> threeDayPreview = [];

  bool isLoading = false;
  String? errorMessage;
  Map<String, dynamic>? currentWeather;

  Future<void> loadWeatherForCity(String city) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      currentWeather = await _api.fetchCurrentWeather(city);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadForecastForCity(String city) async {
  try {
    final json = await _api.fetchFiveDayForecast(city);
    final List list = json['list'] ?? [];

    final Map<String, List<double>> byDate = {};

    for (final item in list) {
      final String dtTxt = item['dt_txt']; // "2025-12-10 12:00:00"
      final String date = dtTxt.split(' ').first; // "2025-12-10"

      final double tMin = (item['main']['temp_min'] ?? 0).toDouble();
      final double tMax = (item['main']['temp_max'] ?? 0).toDouble();

      byDate.putIfAbsent(date, () => []);
      byDate[date]!.add(tMin);
      byDate[date]!.add(tMax);
    }

    final entries = byDate.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    threeDayPreview = entries.take(3).map((e) {
      final temps = e.value;
      double min = temps[0];
      double max = temps[1];
      for (int i = 2; i < temps.length; i++) {
        if (temps[i] < min) min = temps[i];
        if (temps[i] > max) max = temps[i];
      }
      return {
        'date': e.key,
        'min': min,
        'max': max,
      };
    }).toList();

    notifyListeners();
  } catch (_) {
    // keep simple for now
  }
}

}
