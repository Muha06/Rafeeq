import 'package:rafeeq/features/bookmarks/domain/entities/dhikr_bookmark.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/quran_bookmark.dart';
import 'package:rafeeq/features/bookmarks/domain/repos/dhikr_bookmark_repo.dart';
import 'package:rafeeq/features/bookmarks/domain/repos/quran_bookmark_repo.dart';

class GetAllQuranBookmarksUseCase {
  final BookmarksRepository repo;
  GetAllQuranBookmarksUseCase(this.repo);

  List<QuranBookmarkEntity> call() {
    return repo.getAllBookmarks();
  }
}

class GetAllDhikrBookmarksUseCase {
  final DhikrBookmarksRepository dhikrRepo;
  GetAllDhikrBookmarksUseCase(this.dhikrRepo);

  List<DhikrBookmark> call() {
    return dhikrRepo.getAllBookmarks();
  }
}
