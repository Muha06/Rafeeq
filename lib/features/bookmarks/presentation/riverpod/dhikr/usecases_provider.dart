 import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
 import 'package:rafeeq/features/bookmarks/data/datasources/dhikr_local_ds.dart';
import 'package:rafeeq/features/bookmarks/data/models/dhikr_bookmark_hive_model.dart';
import 'package:rafeeq/features/bookmarks/data/repos_impl/dhikr_bookmark_repo_impl.dart';
import 'package:rafeeq/features/bookmarks/domain/repos/dhikr_bookmark_repo.dart';
import 'package:rafeeq/features/bookmarks/domain/usecases/add_bookmark.dart';
import 'package:rafeeq/features/bookmarks/domain/usecases/clear_bookmarks.dart';
import 'package:rafeeq/features/bookmarks/domain/usecases/get_bookmark.dart';
import 'package:rafeeq/features/bookmarks/domain/usecases/is_bookmarked.dart';
import 'package:rafeeq/features/bookmarks/domain/usecases/remove_bookmark.dart';
 
//BOX PROVIDER
final dhikrBoxProvider = Provider<Box<DhikrBookmarkHiveModel>>((ref) {
  return Hive.box<DhikrBookmarkHiveModel>('dhikr_bookmarks_box');
});

//LOCAL DS PROVIDER
final dhikrLocalDsProvider = Provider<DhikrBookmarksLocalDataSource>((ref) {
  final box = ref.read(dhikrBoxProvider);
  return DhikrBookmarksLocalDataSourceImpl(box);
});

//REPO PROVIDER
final dhikrBookmarksRepoProvider = Provider<DhikrBookmarksRepository>((ref) {
  final local = ref.read(dhikrLocalDsProvider);
  return DhikrBookmarksRepositoryImpl(local);
});

//ADD BOOKMARK USECASE
final addDhikrBookmarkUseCaseProvider = Provider<AddDhikrBookMarkUsecase>((
  ref,
) {
  final repo = ref.read(dhikrBookmarksRepoProvider);
  return AddDhikrBookMarkUsecase(repo);
});

//REMOVE BOOKMARK USECASE
final removeDhikrBookmarkUseCaseProvider = Provider<RemoveDhikrBookmarkUseCase>(
  (ref) {
    final repo = ref.read(dhikrBookmarksRepoProvider);
    return RemoveDhikrBookmarkUseCase(repo);
  },
);

//IS BOOKMARKED USECASE
final isDhikrBookmarkedUseCaseProvider = Provider<IsDhikrBookmarked>((ref) {
  final repo = ref.read(dhikrBookmarksRepoProvider);
  return IsDhikrBookmarked(repo);
});

//CLEAR DHIKR USECASE
final clearDhikrBookmarksUseCaseProvider = Provider<ClearDhikrBookmarksUseCase>(
  (ref) {
    final repo = ref.read(dhikrBookmarksRepoProvider);
    return ClearDhikrBookmarksUseCase(repo);
  },
);

//GET ALL DHIKR USECASE
final getAllDhikrBookmarksUseCaseProvider =
    Provider<GetAllDhikrBookmarksUseCase>((ref) {
      final repo = ref.read(dhikrBookmarksRepoProvider);
      return GetAllDhikrBookmarksUseCase(repo);
    });

