import 'package:rafeeq/features/bookmarks/domain/repos/bookmark_repo.dart';

class IsBookmarked {
  final BookmarksRepository repo;
  IsBookmarked(this.repo);

  bool call(String surahId) {
    return repo.isBookmarked(surahId);
  }
}
