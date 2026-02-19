// 1️⃣ Provide repository (inject your remote DS here)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran_tempt/data/repositories/ayah_repo_impl.dart';
import 'package:rafeeq/features/quran_tempt/domain/entities/ayah.dart';
import 'package:rafeeq/features/quran_tempt/domain/repository/ayah_repo.dart';
import 'package:rafeeq/features/quran_tempt/presentation/riverpod/fetch_surahs_provider.dart';

final ayahRepositoryProvider = Provider<AyahRepository>((ref) {
  final remoteDS = ref.watch(
    quranremoteApiServiceProvider,
  ); // make sure you have this

  return AyahRepositoryImpl(remoteDS: remoteDS);
});

// 2️⃣ FutureProvider.family for fetching ayahs per surah
final ayahsFutureProvider = FutureProvider.family<List<Ayah>, int>((
  ref,
  surahId,
) async {
  final repository = ref.watch(ayahRepositoryProvider);

  return repository.fetchAyahs(surahId); // lazy-load next pages later
});
