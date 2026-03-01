import 'package:rafeeq/features/bookmarks/data/datasources/dhikr_local_ds.dart';
import 'package:rafeeq/features/bookmarks/data/models/dhikr_bookmark_hive_model.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/dhikr_bookmark.dart';
import 'package:rafeeq/features/bookmarks/domain/repos/dhikr_bookmark_repo.dart';

class DhikrBookmarksRepositoryImpl implements DhikrBookmarksRepository {
  final DhikrBookmarksLocalDataSource local;

  DhikrBookmarksRepositoryImpl(this.local);

  //ADD BOOKMARK
  @override
  Future<void> addBookmark(DhikrBookmark dhikrBookmark) {
    return local.add(_toHive(dhikrBookmark));
  }

  //REMOVE BOOKMARK
  @override
  Future<void> removeBookmark(int dhikrId) {
    return local.remove(dhikrId);
  }

  @override
  bool isBookmarked(int dhikrId) {
    return local.isBookMarked(dhikrId);
  }

  //GET ALL BOOKMARKS
  @override
  List<DhikrBookmark> getAllBookmarks() {
    return local.getAll().map((model) => _toEntity(model)).toList();
  }

  //CLEAR ALL BOOKMARKS
  @override
  Future<void> clearAllBookmarks() {
    return local.clear();
  }

  //MAPPERS
  DhikrBookmarkHiveModel _toHive(DhikrBookmark e) {
    return DhikrBookmarkHiveModel(
      dhikrId: e.dhikrId,
      dhikrTitle: e.title,
      categoryId: e.categoryId,
      createdAtMillis: e.createdAt.millisecondsSinceEpoch,
    );
  }

  DhikrBookmark _toEntity(DhikrBookmarkHiveModel m) {
    return DhikrBookmark(
      dhikrId: m.dhikrId,
      categoryId: m.categoryId,
      title: m.dhikrTitle,
      createdAt: DateTime.fromMillisecondsSinceEpoch(m.createdAtMillis),
    );
  }
}
