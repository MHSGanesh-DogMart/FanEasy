import 'package:flutter/material.dart';

/// App-wide colour palette.
///
/// `brand` mirrors the Figma brand colour used across the Fans flow.
/// Keep the design-system palette (primary/secondary/surface/...) for
/// future Material widgets and theming.
class AppColors {
  AppColors._();

  // ── Brand ───────────────────────────────────────────────────────────
  static const Color brand = Color(0xFFE13353);
  static const Color brandSoft = Color(0xFFFDE8EC);
  static const Color brandTint = Color(0xFFFFF2F5);
  static const Color brandBadgeBg = Color(0xFFF8E7EA);

  // ── Design system ───────────────────────────────────────────────────
  static const Color primary = Color(0xffBF0DB3);
  static const Color primaryLight = Color(0xffF4B1FF);
  static const Color primaryDark = Color(0xFFAA0062);
  static const Color secondary = Color(0xFF7B2D8B);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8F8F8);
  static const Color scaffoldBackground = Color(0xffFAF9F6);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xff545454);
  static const Color textHint = Color(0xFFAAAAAA);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE8E8E8);
  static const Color borderSubtle = Color(0xFFF2F2ED);
  static const Color divider = Color(0xFFF0F0F0);
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color cardShadow = Color(0x1A000000);
  static const Color mapOverlay = Color(0x80000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFF5F5F5);

  // ── Profile card action buttons ─────────────────────────────────────
  static const Color cardActionBg = Color(0xFF262626);
  static const Color cardActionReplay = Color(0xFFA855F7);
  static const Color cardActionNope = Color(0xFFEF4444);
  static const Color cardActionLike = Color(0xFFF59E0B);
  static const Color cardActionSuper = Color(0xFFFBBF24);
  static const Color cardActionSend = Color(0xFF10B981);

  // ── Gradients ───────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD4007A), Color(0xFF9C0066)],
  );

  static const LinearGradient profileCardOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xCC000000), Colors.black],
    stops: [0.0, 0.4, 0.9],
  );
}
