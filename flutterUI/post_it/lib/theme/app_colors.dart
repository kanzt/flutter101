import 'dart:ui';

class AppColors {
  AppColors._();

  // Brand
  static const Color accent = Color(0xFFFDC962);
  static const Color accentDark = Color(0xFFE5A83D);
  static const Color accentLight = Color(0xFFFFE0A0);

  // Backgrounds
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFF1E1E1E);
  static const Color card = Color(0xFF181818);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color textTertiary = Color(0xFF616161);

  // Glass
  static const Color glass = Color(0x33FFFFFF);
  static const Color glassBorder = Color(0x22FFFFFF);
  static const Color glassHeavy = Color(0x55FFFFFF);

  // Feedback
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFEF5350);
  static const Color viewed = Color(0xFFFDC962);

  // Gradients
  static const List<Color> accentGradient = [
    Color(0xFFFDC962),
    Color(0xFFFF8A65),
  ];

  static const List<Color> darkGradient = [
    Color(0xFF1A1A2E),
    Color(0xFF16213E),
    Color(0xFF0F3460),
  ];

  static const List<List<Color>> postGradients = [
    [Color(0xFF667eea), Color(0xFF764ba2)],
    [Color(0xFFf093fb), Color(0xFFf5576c)],
    [Color(0xFF4facfe), Color(0xFF00f2fe)],
    [Color(0xFF43e97b), Color(0xFF38f9d7)],
    [Color(0xFFfa709a), Color(0xFFfee140)],
    [Color(0xFFa18cd1), Color(0xFFfbc2eb)],
    [Color(0xFFfccb90), Color(0xFFd57eeb)],
    [Color(0xFF0c3483), Color(0xFFa2b6df)],
  ];
}
