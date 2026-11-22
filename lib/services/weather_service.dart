import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import '../models/location.dart';

class WeatherService {
  final http.Client _client;

  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  static const String _geoUrl =
      'https://geocoding-api.open-meteo.com/v1/search';
  static const String _weatherUrl =
      'https://api.open-meteo.com/v1/forecast';

  Future<List<Location>> searchLocations(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) return [];

    final uri = Uri.parse(_geoUrl).replace(queryParameters: {
      'name': trimmed,
      'count': '10',
      'language': 'ar',
      'format': 'json',
    });

    try {
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final results = data['results'] as List?;
        if (results == null || results.isEmpty) return [];
        return results
            .map((r) => Location.fromJson(r as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('فشل البحث (رمز: ${response.statusCode})');
      }
    } on SocketException {
      throw Exception('لا يوجد اتصال بالإنترنت');
    } on TimeoutException {
      throw Exception('انتهت مهلة الاتصال');
    } on FormatException {
      throw Exception('استجابة غير صالحة من الخادم');
    }
  }

  Future<Weather> fetchWeatherForCoords(
      double lat, double lon, String cityName) async {
    final uri = Uri.parse(_weatherUrl).replace(queryParameters: {
      'latitude': lat.toString(),
      'longitude': lon.toString(),
      'current':
          'temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m',
      'daily': 'weather_code,temperature_2m_max,temperature_2m_min',
      'timezone': 'auto',
      'forecast_days': '5',
    });

    try {
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body), cityName);
      } else {
        throw Exception('فشل جلب الطقس (رمز: ${response.statusCode})');
      }
    } on SocketException {
      throw Exception('لا يوجد اتصال بالإنترنت');
    } on TimeoutException {
      throw Exception('انتهت مهلة الاتصال');
    } on FormatException {
      throw Exception('استجابة غير صالحة من الخادم');
    }
  }

  Future<Weather> fetchWeatherForCity(String cityName) async {
    final results = await searchLocations(cityName);
    if (results.isEmpty) {
      throw Exception('لم يتم العثور على المدينة: $cityName');
    }
    final first = results.first;
    return fetchWeatherForCoords(first.latitude, first.longitude, first.name);
  }
}