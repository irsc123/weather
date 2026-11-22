import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// بطاقة زجاجية حقيقية (Premium Frosted Glass):
/// - BackdropFilter يضبب ما خلفها.
/// - تدرج شفاف (65% → 40%).
/// - 4 حدود بدرجات بياض متفاوتة (الضوء من الأعلى).
/// - خط ضوئي (specular) رفيع على الحافة العلوية.
/// - تظليل سفلي خفيف + ظل خارجي ناعم.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final double blurSigma;
  final Color? tint;
  final Gradient? gradient;
  final Color? borderColor;
  final Color? topBorderColor;
  final double borderWidth;
  final List<BoxShadow>? shadows;
  final bool withBlur;
  final bool showHighlight;
  final Color? highlightColor;
  final Color? glowColor;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 22,
    this.blurSigma = 24,
    this.tint,
    this.gradient,
    this.borderColor,
    this.topBorderColor,
    this.borderWidth = 1.0,
    this.shadows,
    this.withBlur = true,
    this.showHighlight = true,
    this.highlightColor,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);

    final effectiveGradient = gradient ??
        LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            tint ?? AppColors.glassFillTop,
            AppColors.glassFillBottom,
          ],
        );

    final glassBody = Container(
      decoration: BoxDecoration(
        gradient: effectiveGradient,
        borderRadius: radius,
        border: Border(
          top: BorderSide(
            color: topBorderColor ?? AppColors.glassBorderTop,
            width: borderWidth + 0.3,
          ),
          left: BorderSide(
            color: borderColor ?? AppColors.glassBorderSide,
            width: borderWidth,
          ),
          right: BorderSide(
            color: borderColor ?? AppColors.glassBorderSide,
            width: borderWidth,
          ),
          bottom: BorderSide(
            color: borderColor ?? AppColors.glassBorderBottom,
            width: borderWidth,
          ),
        ),
      ),
      child: Stack(
        children: [
          // تظليل سفلي
          Positioned(
            left: 0, right: 0, bottom: 0,
            height: borderRadius * 1.4,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(borderRadius),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      glowColor ?? AppColors.glassBottomShade,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // توهج علوي (يتلاشى للأسفل)
          if (showHighlight)
            Positioned(
              top: 0, left: 0, right: 0,
              height: borderRadius * 1.5,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(borderRadius),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        highlightColor ?? AppColors.glassHighlight,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          // المحتوى
          Padding(
            padding: padding ?? const EdgeInsets.all(20),
            child: child,
          ),
          // خط specular رفيع (فوق كل شيء، لكن ليس فوق النص — حافة فقط)
          if (showHighlight)
            Positioned(
              top: 0,
              left: borderRadius * 0.4,
              right: borderRadius * 0.4,
              child: IgnorePointer(
                child: Container(
                  height: 1.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.transparent,
                        Colors.white.withValues(alpha: 0.80),
                        Colors.white.withValues(alpha: 0.95),
                        Colors.white.withValues(alpha: 0.80),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    final clipped = ClipRRect(
      borderRadius: radius,
      child: withBlur
          ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
              child: glassBody,
            )
          : glassBody,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: shadows ?? AppColors.glassShadows,
      ),
      child: clipped,
    );
  }
}