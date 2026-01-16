import 'package:rafeeq/features/bookmarks/domain/repos/dhikr_bookmark_repo.dart';
import 'package:rafeeq/features/bookmarks/domain/repos/quran_bookmark_repo.dart';

class ClearBookmarksUseCase {
  final BookmarksRepository repo;
  ClearBookmarksUseCase(this.repo);

  Future<void> call() {
    return repo.clearAllBookmarks();
  }
}

class ClearDhikrBookmarksUseCase {
  final DhikrBookmarksRepository repo;
  ClearDhikrBookmarksUseCase(this.repo);

  Future<void> call() {
    return repo.clearAllBookmarks();
  }
}
