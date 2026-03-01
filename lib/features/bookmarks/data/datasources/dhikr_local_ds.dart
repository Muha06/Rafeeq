import 'package:hive/hive.dart';
import 'package:rafeeq/features/bookmarks/data/models/dhikr_bookmark_hive_model.dart';

abstract class DhikrBookmarksLocalDataSource {
  Future<void> add(DhikrBookmarkHiveModel hiveModel); //add

  Future<void> remove(int dhikrId); //remove

  Future<void> clear(); //clear all

  bool isBookMarked(int dhikrId); //check if bookmark exists

  List<DhikrBookmarkHiveModel> getAll(); //get all bookmarks
}

class DhikrBookmarksLocalDataSourceImpl
    implements DhikrBookmarksLocalDataSource {
  final Box<DhikrBookmarkHiveModel> box;
  DhikrBookmarksLocalDataSourceImpl(this.box);

  //ADD BOOKMARK
  @override
  Future<void> add(DhikrBookmarkHiveModel hiveModel) async {
    await box.put(hiveModel.dhikrId, hiveModel);
  }

  //REMOVE BOOKMARK
  @override
  Future<void> remove(int dhikrId) async {
    await box.delete(dhikrId);
  }

  @override
  bool isBookMarked(int dhikrId) {
    return box.containsKey(dhikrId);
  }

  //CLEAR ALL BOOKMARKS
  @override
  Future<void> clear() async {
    await box.clear();
  }

  //GET ALL BOOKMARKS
  @override
  List<DhikrBookmarkHiveModel> getAll() {
    final items = box.values.toList();
    items.sort((a, b) => b.createdAtMillis.compareTo(a.createdAtMillis));
    return items;
  }
}
