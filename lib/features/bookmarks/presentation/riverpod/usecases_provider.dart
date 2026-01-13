import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rafeeq/features/bookmarks/data/datasources/bookmarks_local_ds.dart';
import 'package:rafeeq/features/bookmarks/data/models/quran_bookmark_hive_model.dart';
import 'package:rafeeq/features/bookmarks/data/repos_impl/bookmark_impl.dart';
import 'package:rafeeq/features/bookmarks/domain/repos/bookmark_repo.dart';
import 'package:rafeeq/features/bookmarks/domain/usecases/add_bookmark.dart';
import 'package:rafeeq/features/bookmarks/domain/usecases/clear_bookmarks.dart';
import 'package:rafeeq/features/bookmarks/domain/usecases/get_bookmark.dart';
import 'package:rafeeq/features/bookmarks/domain/usecases/is_bookmarked.dart';
import 'package:rafeeq/features/bookmarks/domain/usecases/remove_bookmark.dart';

//BOX PROVIDER
final boxProvider = Provider<Box<QuranBookmarkHiveModel>>((ref) {
  return Hive.box<QuranBookmarkHiveModel>('quran_bookmarks_box');
});

// LOCAL DATA SOURCE
final localDsProvider = Provider<BookmarksLocalDataSource>((ref) {
  final box = ref.watch(boxProvider);
  // Assume BookmarksLocalDataSourceImpl has a default constructor
  return BookmarksLocalDataSourceImpl(box);
});

//REPOSITORY PROVIDER
final bookmarksRepositoryProvider = Provider<BookmarksRepository>((ref) {
  final local = ref.watch(localDsProvider);
  return BookmarksRepositoryImpl(local);
});

/// ------------------------------------------------------------
///  Usecase providers
/// ------------------------------------------------------------

final addQuranBookmarkUseCaseProvider = Provider<AddBookmarkUseCase>((ref) {
  final repo = ref.watch(bookmarksRepositoryProvider);
  return AddBookmarkUseCase(repo);
});

final removeQuranBookmarkUseCaseProvider = Provider<RemoveQuranBookmarkUseCase>(
  (ref) {
    final repo = ref.watch(bookmarksRepositoryProvider);
    return RemoveQuranBookmarkUseCase(repo);
  },
);

final isBookmarkedUseCaseProvider = Provider<IsBookmarked>((ref) {
  final repo = ref.watch(bookmarksRepositoryProvider);
  return IsBookmarked(repo);
});

final clearBookmarksUseCaseProvider = Provider<ClearBookmarksUseCase>((ref) {
  final repo = ref.watch(bookmarksRepositoryProvider);
  return ClearBookmarksUseCase(repo);
});

final getAllQuranBookmarksUseCaseProvider =
    Provider<GetAllQuranBookmarksUseCase>((ref) {
      final repo = ref.watch(bookmarksRepositoryProvider);
      return GetAllQuranBookmarksUseCase(repo);
    });

