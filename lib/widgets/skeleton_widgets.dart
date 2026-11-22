import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_colors.dart';

/// قطعة skeleton أساسية بحركة shimmer
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxShape shape;

  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 12,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      period: const Duration(milliseconds: 1400),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: shape,
          borderRadius:
              shape == BoxShape.rectangle ? BorderRadius.circular(borderRadius) : null,
        ),
      ),
    );
  }
}

/// Skeleton يحاكي شاشة الطقس
class WeatherSkeleton extends StatelessWidget {
  const WeatherSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
      child: Column(
        children: [
          // البطاقة الرئيسية
          const SkeletonBox(width: double.infinity, height: 320, borderRadius: 24),
          const SizedBox(height: 16),
          // 3 بطاقات معلومات
          Row(
            children: List.generate(3, (i) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i < 2 ? 12 : 0),
                child: const SkeletonBox(
                  width: double.infinity,
                  height: 110,
                  borderRadius: 16,
                ),
              ),
            )),
          ),
          const SizedBox(height: 20),
          // التوقعات
          const SkeletonBox(width: double.infinity, height: 240, borderRadius: 20),
        ],
      ),
    );
  }
}

/// Skeleton يحاكي قائمة الملاحظات
class NotesSkeleton extends StatelessWidget {
  const NotesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
      itemCount: 4,
      itemBuilder: (context, i) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: SkeletonBox(width: double.infinity, height: 120, borderRadius: 16),
      ),
    );
  }
}

/// Skeleton للصفحة الرئيسية
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SkeletonBox(width: double.infinity, height: 220, borderRadius: 24),
        const SizedBox(height: 20),
        const SkeletonBox(width: double.infinity, height: 100, borderRadius: 20),
      ],
    );
  }
}