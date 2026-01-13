import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/quran_bookmark.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/usecases_provider.dart';

//Add bookmark
final addQuranBookmarkProvider =
    Provider.family<Function(), QuranBookmarkEntity>((ref, bookmark) {
      final userCase = ref.read(addQuranBookmarkUseCaseProvider);

      return () async {
        await userCase.call(bookmark);
        ref.invalidate(getAllQuranBookmarksProvider); //refresh
      };
    });

//REMOVE BOOKMARK
final removeQuranBookmarkProvider =
    Provider.family<Future<void> Function(), String>((ref, bookmarkId) {
      final userCase = ref.read(removeQuranBookmarkUseCaseProvider);

      return () async {
        await userCase.call(bookmarkId);
        ref.invalidate(getAllQuranBookmarksProvider); //refresh
      };
    });

// GET ALL BOOKMARKS (sync)
final getAllQuranBookmarksProvider = Provider<List<QuranBookmarkEntity>>((ref) {
  final useCase = ref.read(getAllQuranBookmarksUseCaseProvider);
  return useCase.call();
});

// IS BOOKMARKED
final isBookmarkedProvider = Provider.family<bool, String>((ref, bookmarkId) {
  final useCase = ref.read(isBookmarkedUseCaseProvider);
  ref.watch(getAllQuranBookmarksProvider); //to refresh when cleared

  return useCase.call(bookmarkId);
});

// BOOKMARKED IDS (stores all ids of bookmarked ayahs)
final bookmarkedIdsProvider = Provider<Set<String>>((ref) {
  final list = ref.watch(getAllQuranBookmarksProvider);
  return list.map((b) => b.id).toSet();
});

// CLEAR ALL BOOKMARKS
final clearAllBookmarksActionProvider = Provider<Future<void> Function()>((
  ref,
) {
  final useCase = ref.read(clearBookmarksUseCaseProvider);

  return () async {
    await useCase.call();
    ref.invalidate(getAllQuranBookmarksProvider); //refresh
  };
});
