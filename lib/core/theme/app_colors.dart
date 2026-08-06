import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFF06060F);
  static const backgroundCard = Color(0x0AFFFFFF);
  static const accentPurple = Color(0xFFA855F7);
  static const accentIndigo = Color(0xFF6C63FF);
  static const accentPink = Color(0xFFEC4899);
  static const textPrimary = Color(0xD9FFFFFF);
  static const textSecondary = Color(0x59FFFFFF);
  static const textTertiary = Color(0x33FFFFFF);
  static const borderSubtle = Color(0x12FFFFFF);

  static const progressGradient = LinearGradient(
    colors: [accentPurple, accentIndigo, accentPink],
  );

  static const ctaGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7C3AED), accentPurple],
  );

  // Life seasons
  static const springColor = Color(0xFF34D399);
  static const summerColor = Color(0xFFFBBF24);
  static const autumnColor = Color(0xFFF97316);
  static const winterColor = Color(0xFF60A5FA);
}
