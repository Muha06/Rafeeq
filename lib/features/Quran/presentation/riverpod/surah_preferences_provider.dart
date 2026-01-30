// Show/hide translation
import 'package:riverpod/legacy.dart';

final showTranslationProvider = StateProvider<bool>((ref) => true);

// Font size (for Arabic text)
final arabicFontSizeProvider = StateProvider<double>((ref) => 20.0);

// Font size (for translation)
final translationFontSizeProvider = StateProvider<double>((ref) => 16.0);
