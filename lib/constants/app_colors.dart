import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF2F6BFF);
  static const primaryDark = Color(0xFF1E4FD1);
  static const primaryLight = Color(0xFFE7EEFF);
  static const background = Color(0xFFF5F7FB);
  static const surface = Colors.white;
  static const textPrimary = Color(0xFF1E2433);
  static const textSecondary = Color(0xFF5B6478);
  static const border = Color(0xFFE2E7F0);
  static const success = Color(0xFF2BB673);
  static const error = Color(0xFFE5484D);

  // ===== Glass fill — شفاف بدرجة كافية ليظهر الـ Blur =====
  static const glassFillTop = Color(0xA6FFFFFF);      // 65% أبيض — أعلى
  static const glassFillBottom = Color(0x66FFFFFF);   // 40% أبيض — أسفل

  // أسماء قديمة (للتوافق)
  static const glassWhite = glassFillTop;
  static const glassMedium = glassFillBottom;
  static const glassStrong = Color(0xE6FFFFFF);

  // ===== حدود بدرجات مختلفة (الضوء من الأعلى) =====
  static const glassBorderTop = Color(0xF2FFFFFF);    // 95% — حافة علوية ساطعة
  static const glassBorderSide = Color(0xB3FFFFFF);   // 70% — الجانبان
  static const glassBorderBottom = Color(0x73FFFFFF); // 45% — الحافة السفلية

  // أسماء قديمة
  static const glassBorder = glassBorderSide;
  static const glassBorderStrong = glassBorderTop;
  static const glassEdgeTop = glassBorderTop;
  static const glassEdgeSide = glassBorderSide;
  static const glassEdgeBottom = glassBorderBottom;
  static const glassInnerEdge = Color(0x40FFFFFF);

  // ===== Highlight / Shade =====
  static const glassHighlight = Color(0x66FFFFFF);    // 40% للأعلى
  static const glassSheen = Color(0x40FFFFFF);
  static const glassBottomShade = Color(0x140F2A5C);  // 8% كحلي

  // ===== ظلال =====
  static const glassShadows = <BoxShadow>[
    BoxShadow(color: Color(0x24163A75), blurRadius: 32, offset: Offset(0, 14)),
    BoxShadow(color: Color(0x142F6BFF), blurRadius: 18, offset: Offset(0, 6)),
  ];

  static const primaryCardShadows = <BoxShadow>[
    BoxShadow(color: Color(0x4D2F6BFF), blurRadius: 36, offset: Offset(0, 18)),
    BoxShadow(color: Color(0x2E102E6B), blurRadius: 14, offset: Offset(0, 6)),
  ];

  // ===== خلفية متدرجة =====
  static const gradientTop = Color(0xFFE5EEFF);
  static const gradientMid = Color(0xFFEFF4FE);
  static const gradientBottom = Color(0xFFFCFDFF);

  // ===== بقع أكثر تشبعًا لتظهر خلف الزجاج =====
  static const blobBlue = Color(0xFF4A8CFF);
  static const blobCyan = Color(0xFF4EC3FF);
  static const blobPurple = Color(0xFF9B7FFF);
  static const blobPink = Color(0xFFFF7EAF);
  static const blobTeal = Color(0xFF3DD9B8);
  static const blobPeach = Color(0xFFFFAB7A);

  // ===== Skeleton =====
  static const shimmerBase = Color(0xFFE4EAF5);
  static const shimmerHighlight = Color(0xFFF8FBFF);

  // ===== Nav Bar =====
  static const navBarBg = Color(0x66FFFFFF);

  static const appBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [gradientTop, gradientMid, gradientBottom],
    stops: [0.0, 0.5, 1.0],
  );

  static const primaryGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [primary, primaryDark],
  );

  /// البطاقة الزرقاء: 70% / 60% — يظهر أزرق الخلفية بعد الـ Blur
  static const primaryGlassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xB32F6BFF), Color(0x991C46BC)],
  );
}