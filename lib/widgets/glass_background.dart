import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class GlassBackground extends StatelessWidget {
  final Widget child;
  const GlassBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(gradient: AppColors.appBackgroundGradient),
        ),
        Positioned(
          top: -size.height * 0.10,
          left: -size.width * 0.30,
          child: _Blob(color: AppColors.blobBlue, size: size.width * 0.95),
        ),
        Positioned(
          top: size.height * 0.10,
          right: -size.width * 0.35,
          child: _Blob(color: AppColors.blobCyan, size: size.width * 0.85),
        ),
        Positioned(
          top: size.height * 0.38,
          left: -size.width * 0.40,
          child: _Blob(color: AppColors.blobPurple, size: size.width * 0.95),
        ),
        Positioned(
          top: size.height * 0.32,
          right: -size.width * 0.25,
          child: _Blob(color: AppColors.blobTeal, size: size.width * 0.65),
        ),
        Positioned(
          top: size.height * 0.65,
          right: -size.width * 0.30,
          child: _Blob(color: AppColors.blobPink, size: size.width * 0.70),
        ),
        Positioned(
          bottom: -size.height * 0.15,
          left: -size.width * 0.30,
          child: _Blob(color: AppColors.blobBlue, size: size.width * 0.90),
        ),
        Positioned(
          bottom: size.height * 0.05,
          right: -size.width * 0.20,
          child: _Blob(color: AppColors.blobPeach, size: size.width * 0.55),
        ),
        child,
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;
  const _Blob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: 0.80),
              color.withValues(alpha: 0.0),
            ],
            stops: const [0.0, 0.9],
          ),
        ),
      ),
    );
  }
}