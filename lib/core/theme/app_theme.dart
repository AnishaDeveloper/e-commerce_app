import 'package:flutter/material.dart';

class AppColors {
  // Amazon & Flipkart inspired primary tones
  static const Color headerDark = Color(0xFF131921); // Amazon Dark Slate
  static const Color headerNavy = Color(0xFF232F3E); // Amazon Secondary Navy
  static const Color flipkartBlue = Color(0xFF2874F0); // Flipkart Brand Blue
  static const Color locationBar = Color(0xFF37475A); // Location Subheader

  // Action Buttons & Deals
  static const Color amazonYellow = Color(0xFFFFD814); // "Add to Cart" button
  static const Color amazonOrange = Color(0xFFFFA41C); // "Buy Now" button
  static const Color dealRed = Color(0xFFCC0C39); // Amazon "Deal" red badge
  static const Color discountGreen = Color(0xFF388E3C); // Flipkart green savings

  // Aliases for compatibility
  static const Color primary = headerNavy;
  static const Color secondary = amazonOrange;
  static const Color error = dealRed;
  static const Color border = Color(0xFFD5D9D9);
  static const Color cardBorder = Color(0xFFD5D9D9);

  // Neutrals & Surfaces
  static const Color background = Color(0xFFEAEDED); // Amazon soft light grey
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF0F1111);
  static const Color textSecondary = Color(0xFF565959);
  static const Color textMuted = Color(0xFF888888);
  static const Color ratingStar = Color(0xFFDE7921); // Amazon Orange Rating Star
  static const Color linkBlue = Color(0xFF007185); // Amazon hyperlink cyan/blue
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.headerNavy,
        primary: AppColors.headerNavy,
        secondary: AppColors.amazonOrange,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.headerNavy,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
