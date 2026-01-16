 import 'package:rafeeq/features/bookmarks/domain/entities/dhikr_bookmark.dart';

abstract class DhikrBookmarksRepository {
  //ADD BOOKMARK
  Future<void> addBookmark(DhikrBookmark dhikrHiveModel);

  //REMOVE BOOKMARK
  Future<void> removeBookmark(String dhikrId);

  //is bookmarked
  bool isBookmarked(String dhikrId);

  //GET ALL BOOKMARKS
  List<DhikrBookmark> getAllBookmarks();

  //CLEAR ALL BOOKMARKS
  Future<void> clearAllBookmarks();
}
