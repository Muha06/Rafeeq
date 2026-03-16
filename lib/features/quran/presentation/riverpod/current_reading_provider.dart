import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';
import 'package:quran/quran.dart' as quran;

class QuranReadingPosition {
  final int surahId;
  final int ayahNumber;
  final int page;

  const QuranReadingPosition({
    required this.surahId,
    required this.ayahNumber,
    required this.page,
  });

  QuranReadingPosition copyWith({int? surahId, int? ayahNumber, int? page}) {
    return QuranReadingPosition(
      surahId: surahId ?? this.surahId,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      page: page ?? this.page,
    );
  }
}

final currentReadingProvider = StateProvider<QuranReadingPosition?>(
  (ref) => null,
);

// Provider that returns all verses as strings
final pageVersesProvider = Provider<List<String>>((ref) {
  final page = ref.watch(currentReadingProvider)?.page;

  return quran.getVersesTextByPage(
    page ?? 1,
    verseEndSymbol: true,
    surahSeperator: quran.SurahSeperator.none,
  );
});
