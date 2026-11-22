import 'dart:async';
import 'package:get/get.dart';
import '../models/weather.dart';
import '../models/location.dart';
import '../services/weather_service.dart';

class WeatherController extends GetxController {
  final WeatherService _service = WeatherService();

  final weather = Rxn<Weather>();
  final currentCity = 'صنعاء'.obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  final searchResults = <Location>[].obs;
  final isSearching = false.obs;
  final searchError = RxnString();
  final searchQuery = ''.obs;

  Timer? _debounce;
  int _searchRequestId = 0;
  Future<Weather>? _pendingFuture;

  @override
  void onInit() {
    super.onInit();
    // يبدأ الجلب مرة واحدة؛ النتيجة يستخدمها FutureBuilder في الشاشة.
    ensureWeatherLoaded().ignore();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  /// ترجع Future مشترك بين onInit و FutureBuilder - لتفادي طلبين متوازيين.
  Future<Weather> ensureWeatherLoaded() {
    if (weather.value != null) return Future.value(weather.value!);
    return _pendingFuture ??= fetchWeather(currentCity.value);
  }

  /// تجلب الطقس وترجع Future من نوع Weather — تُستخدم من FutureBuilder.
  Future<Weather> fetchWeather(String cityName) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final result = await _service.fetchWeatherForCity(cityName);
      weather.value = result;
      currentCity.value = result.cityName;
      _pendingFuture = null;
      return result;
    } catch (e) {
      _pendingFuture = null;
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectLocation(Location location) async {
    isLoading.value = true;
    errorMessage.value = null;
    weather.value = null;
    try {
      final result = await _service.fetchWeatherForCoords(
          location.latitude, location.longitude, location.name);
      weather.value = result;
      currentCity.value = result.cityName;
      _pendingFuture = Future.value(result);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshWeather() async {
    _pendingFuture = null;
    await fetchWeather(currentCity.value);
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    _debounce?.cancel();

    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      _cancelAndClear();
      return;
    }
    if (trimmed.length < 2) {
      _cancelAndClear();
      searchError.value = 'اكتب حرفين على الأقل للبحث';
      return;
    }

    searchError.value = null;
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _performSearch(trimmed);
    });
  }

  void _cancelAndClear() {
    _debounce?.cancel();
    _searchRequestId++;
    searchResults.clear();
    isSearching.value = false;
    searchError.value = null;
  }

  Future<void> _performSearch(String query) async {
    final requestId = ++_searchRequestId;
    isSearching.value = true;
    searchError.value = null;
    searchResults.clear();

    try {
      final results = await _service.searchLocations(query);
      if (requestId != _searchRequestId) return;
      searchResults.assignAll(results);
      if (results.isEmpty) {
        searchError.value = 'لم يتم العثور على نتائج مطابقة.';
      }
    } catch (e) {
      if (requestId != _searchRequestId) return;
      searchError.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      if (requestId == _searchRequestId) {
        isSearching.value = false;
      }
    }
  }

  void clearSearch() {
    searchQuery.value = '';
    _cancelAndClear();
  }

  void retrySearch() {
    final q = searchQuery.value.trim();
    if (q.length >= 2) _performSearch(q);
  }
}