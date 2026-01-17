import 'package:rafeeq/features/bookmarks/domain/repos/dhikr_bookmark_repo.dart';
import 'package:rafeeq/features/bookmarks/domain/repos/quran_bookmark_repo.dart';

class IsBookmarked {
  final BookmarksRepository repo;
  IsBookmarked(this.repo);

  bool call(String surahId) {
    return repo.isBookmarked(surahId);
  }
}

class IsDhikrBookmarked {
  final DhikrBookmarksRepository repo;
  IsDhikrBookmarked(this.repo);

  bool call(String dhikrId) {
    return repo.isBookmarked(dhikrId);
  }
}
