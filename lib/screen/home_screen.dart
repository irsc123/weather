import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/weather_controller.dart';
import '../controllers/notes_controller.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../widgets/error_widget.dart';
import '../widgets/glass_card.dart';
import '../widgets/glass_background.dart';
import '../widgets/floating_nav_bar.dart';
import '../widgets/skeleton_widgets.dart';
import '../widgets/fade_slide_in.dart';
import 'weather_screen.dart';
import 'notes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<WeatherController>()) {
      Get.put(WeatherController(), permanent: true);
    }
    if (!Get.isRegistered<NotesController>()) {
      Get.put(NotesController(), permanent: true);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTap(int i) {
    if (i == _currentIndex) return;
    setState(() => _currentIndex = i);
    _pageController.animateToPage(
      i,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: GlassBackground(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            _HomeTab(),
            WeatherScreen(),
            NotesScreen(),
          ],
        ),
      ),
      bottomNavigationBar: FloatingNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTap,
        icons: const [
          Icons.home_outlined,
          Icons.wb_sunny_outlined,
          Icons.sticky_note_2_outlined,
        ],
        activeIcons: const [
          Icons.home,
          Icons.wb_sunny,
          Icons.sticky_note_2,
        ],
      ),
    );
  }
}

class _HomeTab extends StatefulWidget {
  const _HomeTab();

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> with AutomaticKeepAliveClientMixin {
  final _weatherController = Get.find<WeatherController>();
  final _notesController = Get.find<NotesController>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.viewPaddingOf(context).bottom + 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeSlideIn(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(AppStrings.welcome,
                        style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                    SizedBox(height: 4),
                    Text(
                      AppStrings.appName,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FadeSlideIn(
                delay: const Duration(milliseconds: 80),
                child: _buildWeatherCard(),
              ),
              const SizedBox(height: 20),
              FadeSlideIn(
                delay: const Duration(milliseconds: 160),
                child: _buildNotesCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    try {
      await _weatherController.refreshWeather();
      await _notesController.loadNotes();
    } catch (_) { /* خطأ التحديث يظهر في بطاقة الطقس */ }
  }

  Widget _buildWeatherCard() {
    return Obx(() {
      if (_weatherController.weather.value == null) {
        if (_weatherController.errorMessage.value != null) {
          return GlassCard(
            child: AppErrorWidget(
              message: _weatherController.errorMessage.value!,
              onRetry: () => _handleRefresh(),
            ),
          );
        }
        return const HomeSkeleton();
      }
      final w = _weatherController.weather.value!;
      return GlassCard(
        gradient: AppColors.primaryGlassGradient,
        padding: const EdgeInsets.all(22),
        borderRadius: 26,
        blurSigma: 26,
        shadows: AppColors.primaryCardShadows,
        borderColor: Colors.white.withValues(alpha: 0.28),
        topBorderColor: Colors.white.withValues(alpha: 0.72),
        highlightColor: Colors.white.withValues(alpha: 0.20),
        glowColor: const Color(0x240A2E7A),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    w.cityName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                Text(w.icon, style: const TextStyle(fontSize: 34)),
              ],
            ),
            const SizedBox(height: 6),
            Text(w.description,
                style: const TextStyle(color: Colors.white70, fontSize: 14)),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${w.temperature.round()}°',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        height: 1)),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${AppStrings.feelsLike}: ${w.feelsLike.round()}°',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text('${AppStrings.humidity}: ${w.humidity}%',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(
                            '${AppStrings.windSpeed}: ${w.windSpeed.round()} كم/س',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildNotesCard() {
    return Obx(() {
      final count = _notesController.notes.length;
      return GlassCard(
        blurSigma: 24,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryLight, Color(0xFFD6E4FF)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.sticky_note_2_outlined,
                  color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(AppStrings.notesCount,
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text('$count',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}