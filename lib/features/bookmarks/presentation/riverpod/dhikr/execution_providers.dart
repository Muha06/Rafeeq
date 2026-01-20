import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/dhikr_bookmark.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/dhikr/usecases_provider.dart';

// GET ALL BOOKMARKS (sync)
final getAllDhikrBookmarksProvider = Provider<List<DhikrBookmark>>((ref) {
  final useCase = ref.read(getAllDhikrBookmarksUseCaseProvider);
  return useCase.call();
});

final removeDhikrBookmarkActionProvider =
    Provider.family<Future<void> Function(), String>((ref, dhikrId) {
      final remove = ref.read(removeDhikrBookmarkUseCaseProvider);

      return () async {
        await remove.call(dhikrId);
        ref.invalidate(getAllDhikrBookmarksProvider);
      };
    });

// BOOKMARKED IDS (stores all ids of bookmarked ayahs)
final bookmarkedDhikrIdsProvider = Provider<Set<String>>((ref) {
  final list = ref.watch(getAllDhikrBookmarksProvider);
  return list.map((b) => b.dhikrId).toSet();
});

// IS BOOKMARKED
final isDhikrBookmarkedProvider = Provider.family<bool, String>((ref, dhikrId) {
  final ids = ref.watch(bookmarkedDhikrIdsProvider);

  return ids.contains(dhikrId);
});

// CLEAR ALL BOOKMARKS
final clearAllDhikrBookmarksProvider = Provider<Future<void> Function()>((ref) {
  final useCase = ref.read(clearDhikrBookmarksUseCaseProvider);

  return () async {
    await useCase.call();
    ref.invalidate(getAllDhikrBookmarksProvider); //refresh
  };
});

//for UI buttons
final toggleDhikrBookmarkProvider =
    Provider.family<Future<bool> Function(), DhikrBookmark>((ref, b) {
      final add = ref.read(addDhikrBookmarkUseCaseProvider);
      final remove = ref.read(removeDhikrBookmarkUseCaseProvider);
      final isBookmarked = ref.read(isDhikrBookmarkedUseCaseProvider);

      return () async {
        final exists = isBookmarked.call(b.dhikrId);

        if (exists) {
          await remove.call(b.dhikrId);
        } else {
          await add.call(b);
        }

        ref.invalidate(getAllDhikrBookmarksProvider); //the list
        return !exists;
      };
    });
