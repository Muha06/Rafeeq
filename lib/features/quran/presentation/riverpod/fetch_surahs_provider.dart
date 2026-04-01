import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/data/dataSources/quran_auth_client.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/wiring_providers.dart';
import 'package:riverpod/legacy.dart';

//auth client
final quranAuthClientProvider = Provider<QuranAuthClient>((ref) {
  final client = ref.read(httpClientProvider);
  return QuranAuthClient(
    clientId: quranClientId,
    clientSecret: quranClientSecret,
    httpClient: client,
  );
});

// Surahs Provider
final surahsProvider = FutureProvider<List<Surah>>((ref) async {
  final usecase = ref.read(getSurahsUseCaseProvider);

  return await usecase.call();
});

//Quick surah links
final quickSurahLinksProvider = Provider<List<Surah>>((ref) {
  final surahs = ref.watch(surahsProvider).value ?? [];
  const quickSurahIds = [1, 18, 36, 55, 67];

  return surahs.where((s) => quickSurahIds.contains(s.id)).toList();
});

final searchSurahTextProvider = StateProvider.autoDispose((ref) {
  return '';
});
