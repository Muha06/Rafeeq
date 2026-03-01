import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/dhikr_bookmark.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/dhikr/wiring_providers.dart';

// GET ALL BOOKMARKS (sync)
final getAllDhikrBookmarksProvider = Provider<List<DhikrBookmark>>((ref) {
  final useCase = ref.watch(getAllDhikrBookmarksUseCaseProvider);
  return useCase.call();
});

//REMOVE DHIKR BOOKMARKS
final removeDhikrBookmarkActionProvider =
    Provider.family<Future<void> Function(), int>((ref, dhikrId) {
      final remove = ref.read(removeDhikrBookmarkUseCaseProvider);

      return () async {
        await remove.call(dhikrId);
        ref.invalidate(getAllDhikrBookmarksProvider);
      };
    });

// CLEAR ALL BOOKMARKS
final clearAllDhikrBookmarksProvider = Provider<Future<void> Function()>((ref) {
  final useCase = ref.read(clearDhikrBookmarksUseCaseProvider);

  return () async {
    await useCase.call();
    ref.invalidate(getAllDhikrBookmarksProvider); //refresh
  };
});
