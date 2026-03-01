 import 'package:rafeeq/features/bookmarks/domain/entities/dhikr_bookmark.dart';

abstract class DhikrBookmarksRepository {
  //ADD BOOKMARK
  Future<void> addBookmark(DhikrBookmark dhikrHiveModel);

  //REMOVE BOOKMARK
  Future<void> removeBookmark(int dhikrId);

  //is bookmarked
  bool isBookmarked(int dhikrId);

  //GET ALL BOOKMARKS
  List<DhikrBookmark> getAllBookmarks();

  //CLEAR ALL BOOKMARKS
  Future<void> clearAllBookmarks();
}
