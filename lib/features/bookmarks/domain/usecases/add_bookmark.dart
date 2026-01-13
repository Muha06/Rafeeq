import 'package:rafeeq/features/bookmarks/domain/entities/quran_bookmark.dart';
import 'package:rafeeq/features/bookmarks/domain/repos/bookmark_repo.dart';

class AddBookmarkUseCase {
  final BookmarksRepository repository;
  AddBookmarkUseCase(this.repository);

  Future<void> call(QuranBookmarkEntity bookmark) {
    return repository.addBookmark(bookmark);
  }
}
