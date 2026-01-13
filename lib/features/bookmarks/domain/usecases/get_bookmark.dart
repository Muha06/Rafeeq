import 'package:rafeeq/features/bookmarks/domain/entities/quran_bookmark.dart';
import 'package:rafeeq/features/bookmarks/domain/repos/bookmark_repo.dart';

class GetAllQuranBookmarksUseCase {
  final BookmarksRepository repo;
  GetAllQuranBookmarksUseCase(this.repo);

  List<QuranBookmarkEntity> call() {
    return repo.getAllBookmarks();
  }
}
