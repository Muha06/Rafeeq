import 'package:flutter/services.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
import 'package:rafeeq/features/quran/domain/entities/ayah.dart';
import 'package:quran/quran.dart' as quran;

class AppClipboard {
  const AppClipboard._();

  static Future<void> copyAyah({required Ayah ayah}) async {
    final surahName = quran.getSurahName(ayah.surahId);

    final buffer = StringBuffer();

    buffer.writeln(ayah.textArabic);
    buffer.writeln();

    // Transliteration
    buffer.writeln(ayah.transliteration);
    buffer.writeln();

    // Ref
    buffer.writeln('$surahName ${ayah.surahId}:${ayah.ayahNumber}');
    await Clipboard.setData(ClipboardData(text: buffer.toString().trim()));

    RafeeqAnalytics.logFeature('copy_ayah');
  }
}
