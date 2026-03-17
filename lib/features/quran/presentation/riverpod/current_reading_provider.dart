import 'package:riverpod/legacy.dart';

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

final mushafModeProvider = StateProvider<bool>((ref) {
  return false;
});
