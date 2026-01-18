import 'package:hive/hive.dart';
import 'package:rafeeq/features/bookmarks/data/models/quran_bookmark_hive_model.dart';

abstract class BookmarksLocalDataSource {
  Future<void> add(QuranBookmarkHiveModel hiveModel); //add
  Future<void> remove(String bookmarkId); //remove
  Future<void> clear(); //clear all
  bool isBookMarked(String bookmarkId); //check if bookmark exists
  List<QuranBookmarkHiveModel> getAll(); //get all bookmarks
}

class BookmarksLocalDataSourceImpl implements BookmarksLocalDataSource {
  final Box<QuranBookmarkHiveModel> box;
  BookmarksLocalDataSourceImpl(this.box);

  //ADD BOOKMARK
  @override
  Future<void> add(QuranBookmarkHiveModel hiveModel) async {
    await box.put(hiveModel.id, hiveModel);
  }

  //REMOVE BOOKMARK
  @override
  Future<void> remove(String bookmarkId) async {
    await box.delete(bookmarkId);
  }

  @override
  bool isBookMarked(String bookmarkId)   {
    return box.containsKey(bookmarkId);
  }

  //CLEAR ALL BOOKMARKS
  @override
  Future<void> clear() async {
    await box.clear();
  }

  //GET ALL BOOKMARKS
  @override
  List<QuranBookmarkHiveModel> getAll() {
    final items = box.values.toList();
    items.sort((a, b) => b.createdAtMillis.compareTo(a.createdAtMillis));
    return items;
  }
}
