import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/weather_controller.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../widgets/glass_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/loading_widget.dart';
import '../models/location.dart';

class WeatherSearchScreen extends StatefulWidget {
  const WeatherSearchScreen({super.key});

  @override
  State<WeatherSearchScreen> createState() => _WeatherSearchScreenState();
}

class _WeatherSearchScreenState extends State<WeatherSearchScreen> {
  final WeatherController controller = Get.find<WeatherController>();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.clearSearch();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _selectLocation(Location location) async {
    Get.back();
    await controller.selectLocation(location);
  }

  @override
  Widget build(BuildContext context) {
    return GlassBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text(AppStrings.searchCity)),
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: GlassCard(
                  borderRadius: 16,
                  blurSigma: 20,
                  padding: EdgeInsets.zero,
                  child: TextField(
                    controller: _textController,
                    autofocus: true,
                    onChanged: controller.onSearchChanged,
                    textInputAction: TextInputAction.search,
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: InputDecoration(
                      hintText: AppStrings.searchHint,
                      prefixIcon: const Icon(Icons.search),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      suffixIcon: Obx(() {
                        if (controller.searchQuery.value.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _textController.clear();
                            controller.clearSearch();
                          },
                        );
                      }),
                    ),
                  ),
                ),
              ),
              Expanded(child: _buildResults()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResults() {
    return Obx(() {
      if (controller.isSearching.value) {
        return const LoadingWidget(message: AppStrings.searching);
      }

      final error = controller.searchError.value;
      if (error != null) {
        return _centeredScrollable(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline,
                  size: 48, color: AppColors.textSecondary),
              const SizedBox(height: 12),
              Text(
                error,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              if (controller.searchQuery.value.trim().length >= 2) ...[
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: controller.retrySearch,
                  icon: const Icon(Icons.refresh),
                  label: const Text(AppStrings.retry),
                ),
              ],
            ],
          ),
        );
      }

      if (controller.searchQuery.value.trim().isEmpty) {
        return _centeredScrollable(
          const Text(
            'اكتب اسم مدينة أو منطقة للبحث',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        );
      }

      final results = controller.searchResults;
      if (results.isEmpty) {
        return const LoadingWidget(message: AppStrings.searching);
      }

      return ListView.separated(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.fromLTRB(
            16, 0, 16, MediaQuery.viewPaddingOf(context).bottom + 24),
        itemCount: results.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final loc = results[i];
          return _SuggestionTile(
            location: loc,
            onTap: () => _selectLocation(loc),
          );
        },
      );
    });
  }

  Widget _centeredScrollable(Widget child) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  final Location location;
  final VoidCallback onTap;

  const _SuggestionTile({required this.location, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 18,
      blurSigma: 20,
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Text(
                  location.flag.isEmpty ? '📍' : location.flag,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location.name,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (location.subtitle.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          location.subtitle,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(Icons.chevron_left, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
