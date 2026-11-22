import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/weather_controller.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../widgets/error_widget.dart';
import '../widgets/glass_card.dart';
import '../widgets/skeleton_widgets.dart';
import '../widgets/fade_slide_in.dart';
import '../models/weather.dart';
import 'weather_search_screen.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with AutomaticKeepAliveClientMixin {
  final WeatherController controller = Get.find<WeatherController>();
  late Future<Weather> _weatherFuture;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _weatherFuture = controller.ensureWeatherLoaded();
  }

  /// إعادة المحاولة بعد خطأ — تنشئ Future جديدة
  void _reload() {
    setState(() {
      _weatherFuture = controller.fetchWeather(controller.currentCity.value);
    });
  }

  /// السحب للتحديث — تنتظر حتى ينتهي الطلب لإيقاف مؤشر RefreshIndicator
  Future<void> _refresh() async {
    final future = controller.fetchWeather(controller.currentCity.value);
    setState(() {
      _weatherFuture = future;
    });
    try {
      await future;
    } catch (_) {
      // الخطأ يُعرض عبر FutureBuilder
    }
  }

  /// بعد البحث — مزامنة الـ Future مع قيمة المتحكم الجديدة
  Future<void> _openSearch() async {
    await Get.to(() => const WeatherSearchScreen());
    if (!mounted) return;
    if (controller.weather.value != null) {
      setState(() {
        _weatherFuture = Future<Weather>.value(controller.weather.value!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text(AppStrings.weatherTitle),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: _openSearch),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: FutureBuilder<Weather>(
          future: _weatherFuture,
          builder: (context, snapshot) {
            // 1) Waiting: عملية جلب جارية
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const WeatherSkeleton();
            }

            // 2) Error: فشل الطلب
            if (snapshot.hasError) {
              return _ScrollableError(
                message: snapshot.error
                        ?.toString()
                        .replaceFirst('Exception: ', '') ??
                    'تعذر جلب بيانات الطقس.',
                onRetry: _reload,
              );
            }

            // 3) Has Data: وصلت البيانات
            if (snapshot.hasData) {
              return _WeatherContent(
                weather: snapshot.data!,
                onRefresh: _refresh,
              );
            }

            // 4) Empty: لا بيانات ولا خطأ (نادر)
            return _ScrollableError(
              message: 'لا توجد بيانات طقس متاحة.',
              onRetry: _reload,
            );
          },
        ),
      ),
    );
  }
}

class _ScrollableError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ScrollableError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: AppErrorWidget(
            message: message,
            onRetry: () => onRetry(),
          ),
        ),
      ),
    );
  }
}

class _WeatherContent extends StatelessWidget {
  final Weather weather;
  final Future<void> Function() onRefresh;

  const _WeatherContent({
    required this.weather,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          20,
          8,
          20,
          MediaQuery.viewPaddingOf(context).bottom + 100,
        ),
        child: Column(
          children: [
            FadeSlideIn(child: _MainWeatherCard(weather: weather)),
            const SizedBox(height: 16),
            FadeSlideIn(
              delay: const Duration(milliseconds: 80),
              child: _InfoGrid(weather: weather),
            ),
            const SizedBox(height: 20),
            FadeSlideIn(
              delay: const Duration(milliseconds: 160),
              child: _ForecastCard(forecast: weather.forecast),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${AppStrings.lastUpdate}: ${DateFormat('HH:mm').format(weather.lastUpdated)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                ),
                TextButton.icon(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text(AppStrings.refresh),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MainWeatherCard extends StatelessWidget {
  final Weather weather;
  const _MainWeatherCard({required this.weather});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      gradient: AppColors.primaryGlassGradient,
      padding: const EdgeInsets.all(24),
      borderRadius: 28,
      blurSigma: 28,
      shadows: AppColors.primaryCardShadows,
      borderColor: Colors.white.withValues(alpha: 0.28),
      topBorderColor: Colors.white.withValues(alpha: 0.75),
      highlightColor: Colors.white.withValues(alpha: 0.22),
      glowColor: const Color(0x240A2E7A),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, color: Colors.white70, size: 18),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  weather.cityName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(weather.icon, style: const TextStyle(fontSize: 76)),
          const SizedBox(height: 8),
          Text('${weather.temperature.round()}°',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 76,
                  fontWeight: FontWeight.bold,
                  height: 1)),
          Text(weather.description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 18)),
          if (weather.tempMax != null && weather.tempMin != null) ...[
            const SizedBox(height: 12),
            Text(
              'عظمى ${weather.tempMax!.round()}° • صغرى ${weather.tempMin!.round()}°',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final Weather weather;
  const _InfoGrid({required this.weather});

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[
      _infoTile(Icons.thermostat, 'المحسوسة', '${weather.feelsLike.round()}°'),
      _infoTile(Icons.water_drop_outlined, AppStrings.humidity,
          '${weather.humidity}%'),
      _infoTile(Icons.air, AppStrings.windSpeed,
          '${weather.windSpeed.round()} كم/س'),
    ];

    final textScale = MediaQuery.textScalerOf(context).scale(1);
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns =
            (constraints.maxWidth < 300 || textScale > 1.25) ? 2 : 3;
        const spacing = 12.0;
        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final tile in tiles)
              SizedBox(width: itemWidth, child: tile),
          ],
        );
      },
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return GlassCard(
      borderRadius: 20,
      blurSigma: 22,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 90),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 26),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 10.5, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ForecastCard extends StatelessWidget {
  final List<DailyForecast> forecast;
  const _ForecastCard({required this.forecast});

  @override
  Widget build(BuildContext context) {
    if (forecast.isEmpty) return const SizedBox.shrink();
    return GlassCard(
      borderRadius: 24,
      blurSigma: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(AppStrings.forecast,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...forecast.take(5).map(_forecastRow),
        ],
      ),
    );
  }

  Widget _forecastRow(DailyForecast f) {
    final formatter = DateFormat('EEEE', 'ar');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text(formatter.format(f.date),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14))),
          Expanded(
            child: Center(
              child: Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.85),
                  shape: BoxShape.circle,
                ),
                child: Text(f.icon, style: const TextStyle(fontSize: 19)),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${f.tempMax.round()}° / ${f.tempMin.round()}°',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style:
                  const TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}