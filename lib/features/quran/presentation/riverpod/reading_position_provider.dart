import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran/quran.dart' as quran;
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_surahs_provider.dart';

class ReadingPosition {
  final int surahId;
  final int ayahNumber;

  const ReadingPosition({required this.surahId, required this.ayahNumber});

  int get page => quran.getPageNumber(surahId, ayahNumber);
}

final readingPositionProvider =
    NotifierProvider<ReadingPositionNotifier, ReadingPosition?>(
      ReadingPositionNotifier.new,
    );

class ReadingPositionNotifier extends Notifier<ReadingPosition?> {
  @override
  ReadingPosition? build() {
    return null; // no initial position
  }

  Surah? get currentSurah {
    final pos = state;
    if (pos == null) return null;

    return ref.read(surahsProvider).firstWhere((s) => s.id == pos.surahId);
  }

  // 🔄 Main update (list mode)
  void update({required int surahId, required int ayahNumber}) {
    if (state?.surahId == surahId && state?.ayahNumber == ayahNumber) return;

    state = ReadingPosition(surahId: surahId, ayahNumber: ayahNumber);
  }

  // 📖 From mushaf page
  void updateFromPage(int page) {
    final List<dynamic> segments = quran.getPageData(page);

    if (segments.isEmpty) return; // safety

    // Take the first surah segment on the page
    final firstSegment = segments.first;

    final surah = firstSegment['surah'] as int;
    final ayah = firstSegment['start'] as int;

    state = ReadingPosition(surahId: surah, ayahNumber: ayah);
  }
}
