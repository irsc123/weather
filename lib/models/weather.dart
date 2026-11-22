class Weather {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int weatherCode;
  final double? tempMax;
  final double? tempMin;
  final DateTime lastUpdated;
  final List<DailyForecast> forecast;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
    required this.lastUpdated,
    this.tempMax,
    this.tempMin,
    this.forecast = const [],
  });

  factory Weather.fromJson(Map<String, dynamic> json, String cityName) {
    final current = json['current'] as Map<String, dynamic>;
    final daily = json['daily'] as Map<String, dynamic>?;

    final dailyList = <DailyForecast>[];
    if (daily != null) {
      final dates = (daily['time'] as List).cast<String>();
      final maxTemps = (daily['temperature_2m_max'] as List).cast<num>();
      final minTemps = (daily['temperature_2m_min'] as List).cast<num>();
      final codes = (daily['weather_code'] as List).cast<num>();
      for (var i = 0; i < dates.length; i++) {
        dailyList.add(DailyForecast(
          date: DateTime.parse(dates[i]),
          tempMax: maxTemps[i].toDouble(),
          tempMin: minTemps[i].toDouble(),
          weatherCode: codes[i].toInt(),
        ));
      }
    }

    return Weather(
      cityName: cityName,
      temperature: (current['temperature_2m'] as num).toDouble(),
      feelsLike: (current['apparent_temperature'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toInt(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
      tempMax: dailyList.isNotEmpty ? dailyList.first.tempMax : null,
      tempMin: dailyList.isNotEmpty ? dailyList.first.tempMin : null,
      lastUpdated: DateTime.now(),
      forecast: dailyList,
    );
  }

  String get description => weatherDescription(weatherCode);
  String get icon => weatherIcon(weatherCode);
}

class DailyForecast {
  final DateTime date;
  final double tempMax;
  final double tempMin;
  final int weatherCode;

  DailyForecast({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.weatherCode,
  });

  String get description => weatherDescription(weatherCode);
  String get icon => weatherIcon(weatherCode);
}

String weatherDescription(int code) {
  if (code == 0) return 'سماء صافية';
  if (code == 1) return 'صافٍ غالبًا';
  if (code == 2) return 'غائم جزئيًا';
  if (code == 3) return 'غائم';
  if (code == 45 || code == 48) return 'ضباب';
  if (code >= 51 && code <= 57) return 'رذاذ';
  if (code >= 61 && code <= 67) return 'مطر';
  if (code >= 71 && code <= 77) return 'ثلج';
  if (code >= 80 && code <= 82) return 'زخات مطر';
  if (code >= 85 && code <= 86) return 'زخات ثلج';
  if (code >= 95 && code <= 99) return 'عاصفة رعدية';
  return 'غير معروف';
}

String weatherIcon(int code) {
  if (code == 0) return '☀️';
  if (code == 1 || code == 2) return '🌤️';
  if (code == 3) return '☁️';
  if (code == 45 || code == 48) return '🌫️';
  if (code >= 51 && code <= 67) return '🌧️';
  if (code >= 71 && code <= 86) return '❄️';
  if (code >= 95) return '⛈️';
  return '🌡️';
}