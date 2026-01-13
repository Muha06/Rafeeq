import 'package:rafeeq/features/bookmarks/domain/repos/bookmark_repo.dart';

class RemoveQuranBookmarkUseCase {
  final BookmarksRepository repo;
  RemoveQuranBookmarkUseCase(this.repo);

  Future<void> call(String bookmarkId) {
    return repo.removeBookmark(bookmarkId);
  }
}
