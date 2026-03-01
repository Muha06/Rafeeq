import 'package:rafeeq/features/bookmarks/domain/repos/dhikr_bookmark_repo.dart';
import 'package:rafeeq/features/bookmarks/domain/repos/quran_bookmark_repo.dart';

class RemoveQuranBookmarkUseCase {
  final BookmarksRepository repo;
  RemoveQuranBookmarkUseCase(this.repo);

  Future<void> call(String bookmarkId) {
    return repo.removeBookmark(bookmarkId);
  }
}

class RemoveDhikrBookmarkUseCase {
  final DhikrBookmarksRepository repo;
  RemoveDhikrBookmarkUseCase(this.repo);

  Future<void> call(int dhikrId) {
    return repo.removeBookmark(dhikrId);
  }
}
