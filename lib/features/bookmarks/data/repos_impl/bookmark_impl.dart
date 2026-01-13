import 'package:rafeeq/features/bookmarks/data/datasources/bookmarks_local_ds.dart';
import 'package:rafeeq/features/bookmarks/data/models/quran_bookmark_hive_model.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/quran_bookmark.dart';
import 'package:rafeeq/features/bookmarks/domain/repos/bookmark_repo.dart';

class BookmarksRepositoryImpl implements BookmarksRepository {
  final BookmarksLocalDataSource local;

  BookmarksRepositoryImpl(this.local);

  //ADD BOOKMARK
  @override
  Future<void> addBookmark(QuranBookmarkEntity bookmark) {
    return local.add(_toHive(bookmark));
  }

  //REMOVE BOOKMARK
  @override
  Future<void> removeBookmark(String bookmarkId) {
    return local.remove(bookmarkId);
  }

  @override
  bool isBookmarked(String bookmarkId) {
    return local.isBookMarked(bookmarkId);
  }

  //GET ALL BOOKMARKS
  @override
  List<QuranBookmarkEntity> getAllBookmarks() {
    return local.getAll().map((model) => _toEntity(model)).toList();
  }

  //CLEAR ALL BOOKMARKS
  @override
  Future<void> clearAllBookmarks() {
    return local.clear();
  }

  //MAPPERS
  QuranBookmarkHiveModel _toHive(QuranBookmarkEntity e) {
    return QuranBookmarkHiveModel(
      id: e.id,
      surahId: e.surahId,
      surahEnglishName: e.surahEnglishName,
      ayahNumber: e.ayahNumber,
      createdAtMillis: e.createdAt.millisecondsSinceEpoch,
    );
  }

  QuranBookmarkEntity _toEntity(QuranBookmarkHiveModel m) {
    return QuranBookmarkEntity(
      id: m.id,
      surahId: m.surahId,
      surahEnglishName: m.surahEnglishName,
      ayahNumber: m.ayahNumber,
      createdAt: DateTime.fromMillisecondsSinceEpoch(m.createdAtMillis),
    );
  }
}
