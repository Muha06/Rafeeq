import 'package:rafeeq/features/bookmarks/domain/entities/dhikr_bookmark.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/quran_bookmark.dart';
import 'package:rafeeq/features/bookmarks/domain/repos/dhikr_bookmark_repo.dart';
import 'package:rafeeq/features/bookmarks/domain/repos/quran_bookmark_repo.dart';

class AddBookmarkUseCase {
  final BookmarksRepository repository;
  AddBookmarkUseCase(this.repository);

  Future<void> call(QuranBookmarkEntity bookmark) {
    return repository.addBookmark(bookmark);
  }
}

class AddDhikrBookMarkUsecase {
  final DhikrBookmarksRepository dhikrRepo;
  AddDhikrBookMarkUsecase(this.dhikrRepo);

  Future<void> call(DhikrBookmark dhikrBookmark) {
    return dhikrRepo.addBookmark(dhikrBookmark);
  }
}
