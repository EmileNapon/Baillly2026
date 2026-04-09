import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Palette ────────────────────────────────────────────────
class AppColors {
  static const Color bgPage      = Color(0xFFF3F2EF); // LinkedIn pur
  static const Color white       = Color(0xFFFFFFFF); // Blanc absolu
  static const Color navy        = Color(0xFF1A3A6B);
  static const Color navyLight   = Color(0xFFEEF3FB);
  static const Color textPrimary = Color(0xFF191919);
  static const Color textSecond  = Color(0xFF5E5E5E);
  static const Color textMuted   = Color(0xFF9B9B9B);
  static const Color divider     = Color(0xFFE3E0D8);
  static const Color successBg   = Color(0xFFE8F5E9);
  static const Color successFg   = Color(0xFF1B6B3A);
  static const Color warnBg      = Color(0xFFFFF8E1);
  static const Color warnFg      = Color(0xFF7A5A00);
  static const Color dangerBg    = Color(0xFFFFEBEB);
  static const Color dangerFg    = Color(0xFFB71C1C);
  static const Color infoBg      = Color(0xFFE3EDF9);

  static Color trustColor(int score) {
    if (score >= 90) return successFg;
    if (score >= 75) return const Color(0xFFB45309);
    return dangerFg;
  }
}

// ─── Typographie Aptos (Nunito Sans) ────────────────────────
class AppText {
  static TextStyle display({double size = 22, FontWeight w = FontWeight.w800, Color c = AppColors.navy}) =>
      GoogleFonts.nunitoSans(fontSize: size, fontWeight: w, color: c, height: 1.2, letterSpacing: -0.3);

  static TextStyle heading({double size = 15, FontWeight weight = FontWeight.w700, Color color = AppColors.textPrimary}) =>
      GoogleFonts.nunitoSans(fontSize: size, fontWeight: weight, color: color, height: 1.3);

  static TextStyle body({double size = 14, FontWeight weight = FontWeight.w400, Color color = AppColors.textPrimary}) =>
      GoogleFonts.nunitoSans(fontSize: size, fontWeight: weight, color: color, height: 1.55);

  static TextStyle label({double size = 12, FontWeight weight = FontWeight.w700, Color color = AppColors.textSecond}) =>
      GoogleFonts.nunitoSans(fontSize: size, fontWeight: weight, color: color, letterSpacing: 0.2);

  static TextStyle caption({double size = 11, FontWeight weight = FontWeight.w400, Color color = AppColors.textMuted}) =>
      GoogleFonts.nunitoSans(fontSize: size, fontWeight: weight, color: color, height: 1.4);

  static TextStyle price({double size = 17, Color color = AppColors.navy}) =>
      GoogleFonts.nunitoSans(fontSize: size, fontWeight: FontWeight.w800, color: color, letterSpacing: -0.5);

  static TextStyle button({double size = 13, Color color = Colors.white}) =>
      GoogleFonts.nunitoSans(fontSize: size, fontWeight: FontWeight.w700, color: color, letterSpacing: 0.1);
}

// ─── Dimensions ─────────────────────────────────────────────
class AppDim {
  static const double radiusSm   = 6;
  static const double radiusMd   = 10;
  static const double radiusLg   = 14;
  static const double radiusPill = 100;
  static const double borderW    = 1.0;
}























// Verts
const Color whatsappDarkGreen   = Color(0xFF075E54); // AppBar
const Color whatsappMediumGreen = Color(0xFF128C7E); // icônes actives
const Color whatsappLightGreen  = Color(0xFF25D366); // bulles envoyées / FAB
const Color whatsappPaleGreen   = Color(0xFFDCF8C6); // fond bulle envoyée

// Fond
const Color whatsappBackground  = Color(0xFFECE5DD); // fond chat (beige)
const Color whatsappWhite       = Color(0xFFFFFFFF); // listes, barre nav

// Texte
const Color whatsappTextDark    = Color(0xFF111B21); // texte principal
const Color whatsappTextGrey    = Color(0xFF667781); // texte secondaire / horodatage


