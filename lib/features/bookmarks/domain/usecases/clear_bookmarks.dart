import 'package:rafeeq/features/bookmarks/domain/repos/bookmark_repo.dart';

class ClearBookmarksUseCase {
  final BookmarksRepository repo;
  ClearBookmarksUseCase(this.repo);

  Future<void> call() {
    return repo.clearAllBookmarks();
  }
}
