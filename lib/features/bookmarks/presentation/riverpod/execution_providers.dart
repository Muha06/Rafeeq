//ADD BOOKMARK
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/quran_bookmark.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/usecases_provider.dart';

final addQuranBookmarkProvider =
    FutureProvider.family<void, QuranBookmarkEntity>((ref, bookmark) async {
      final userCase = ref.read(addQuranBookmarkUseCaseProvider);

      await userCase.call(bookmark);

      ref.invalidate(getAllQuranBookmarksProvider); //refresh
    });

//REMOVE BOOKMARK
final removeQuranBookmarkProvider = FutureProvider.family<void, String>((
  ref,
  bookmarkId,
) async {
  final userCase = ref.read(removeQuranBookmarkUseCaseProvider);

  await userCase.call(bookmarkId);

  ref.invalidate(getAllQuranBookmarksProvider); //refresh
});

// GET ALL BOOKMARKS (sync)
final getAllQuranBookmarksProvider = Provider<List<QuranBookmarkEntity>>((ref) {
  final useCase = ref.read(getAllQuranBookmarksUseCaseProvider);
  return useCase.call();
});

final isBookmarkedProvider =  Provider.family<bool, String>((
  ref,
  bookmarkId,
)   {
  final useCase = ref.read(isBookmarkedUseCaseProvider);
  return useCase.call(bookmarkId);
});

// CLEAR ALL BOOKMARKS
final clearAllQuranBookmarksProvider = FutureProvider<void>((ref) async {
  final useCase = ref.read(clearBookmarksUseCaseProvider);

  await useCase.call();

  ref.invalidate(getAllQuranBookmarksProvider); //refresh
});
