import 'package:rafeeq/features/bookmarks/domain/entities/quran_bookmark.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/Quran/usecases_provider.dart';
import 'package:riverpod/riverpod.dart';

final quranBookmarksProvider =
    NotifierProvider<QuranBookmarksNotifier, List<QuranBookmarkEntity>>(
      QuranBookmarksNotifier.new,
    );

class QuranBookmarksNotifier extends Notifier<List<QuranBookmarkEntity>> {
  @override
  List<QuranBookmarkEntity> build() {
    return ref.read(getAllQuranBookmarksUseCaseProvider).call();
  }

  //Add bookmarks
  Future<void> addBookmark(QuranBookmarkEntity bookmark) async {
    state = [...state, bookmark];

    return await ref.read(addQuranBookmarkUseCaseProvider).call(bookmark);
  }

  //remove
  Future<void> removeBookmark(String bookmarkId) async {
    state = state.where((b) => b.id != bookmarkId).toList();

    return await ref.read(removeQuranBookmarkUseCaseProvider).call(bookmarkId);
  }

  //is bookmarked
  bool isBookmarked(String bookmarkId) {
    return state.any((b) => b.id == bookmarkId);
  }

  //toggle
  Future<bool> toggle(QuranBookmarkEntity bookmark) async {
    final bookmarked = isBookmarked(bookmark.id);

    if (bookmarked) {
      await removeBookmark(bookmark.id);
      return false;
    } else {
      await addBookmark(bookmark);
      return true;
    }
  }

  Future<void> clearAllBookmarks() async {
    return await ref.read(clearBookmarksUseCaseProvider).call();
  }
}

final isQuranBookmarkedProvider = Provider.family<bool, String>((ref, id) {
  final bookmarks = ref.watch(quranBookmarksProvider);
  return bookmarks.any((b) => b.id == id);
});
