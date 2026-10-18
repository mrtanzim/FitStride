import 'package:flutter/material.dart';

class AppColors {
  // Background
  static const bgDeep = Color(0xFF060907); // screen base / edges
  static const bgGlow = Color(0xFF0D2A18); // soft green glow behind main content

  // Surfaces (glass)
  static const glass = Color(0x14FFFFFF); // white at ~8%
  static const glassStrong = Color(0x1FFFFFFF); // white at ~12%
  static const glassBorder = Color(0x1AFFFFFF); // white at ~10%
  static const glassSurface = Color(0xB8121914); // rgba(18, 25, 20, 0.72)
  static const glassPill = Color(0x0DFFFFFF); // rgba(255, 255, 255, 0.05)
  static const glassNav = Color(0xE00B100C); // rgba(11, 16, 12, 0.88)

  // Accent
  static const lime = Color(0xFFB6F53C); // primary accent
  static const limeDim = Color(0x33B6F53C); // lime at 20%
  static const onLime = Color(0xFF0A1A05); // text on lime buttons

  // Text
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF9AA39C);
  static const textDisabled = Color(0xFF5C645E);

  // Status
  static const warning = Color(0xFFFFB020); // slips, streak at risk
  static const danger = Color(0xFFFF5A4F); // errors only
}
