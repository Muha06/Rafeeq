import 'package:rafeeq/features/bookmarks/domain/entities/quran_bookmark.dart';

abstract class BookmarksRepository {
  //ADD BOOKMARK
  Future<void> addBookmark(QuranBookmarkEntity bookmark);

  //REMOVE BOOKMARK
  Future<void> removeBookmark(String bookmarkId);

//is bookmarked
  bool isBookmarked(String bookmarkId);
  
  //GET ALL BOOKMARKS
  List<QuranBookmarkEntity> getAllBookmarks();

  //CLEAR ALL BOOKMARKS
  Future<void> clearAllBookmarks();
}
