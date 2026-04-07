import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/dhikr_bookmark.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/dhikr/wiring_providers.dart';

final dhikrBookmarksProvider =
    NotifierProvider<DhikrBookmarksNotifier, List<DhikrBookmark>>(
      DhikrBookmarksNotifier.new,
    );

class DhikrBookmarksNotifier extends Notifier<List<DhikrBookmark>> {
  @override
  List<DhikrBookmark> build() {
    return ref.read(getAllDhikrBookmarksUseCaseProvider).call();
  }

  Future<void> add(DhikrBookmark bookmark) async {
    await ref.read(addDhikrBookmarkUseCaseProvider).call(bookmark);

    state = [...state, bookmark];
  }

  Future<void> remove(int bookmarkId) async {
    await ref.read(removeDhikrBookmarkUseCaseProvider).call(bookmarkId);

    state = state.where((b) => b.dhikrId != bookmarkId).toList();
  }

  Future<void> toggle(DhikrBookmark bookmark) async {
    final exists = state.any((b) => b.dhikrId == bookmark.dhikrId);

    if (exists) {
      await remove(bookmark.dhikrId);
    } else {
      await add(bookmark);
    }
  }

   
}

final isDhikrBookmarkedProvider = Provider.family<bool, int>((ref, id) {
  final bookmarks = ref.watch(dhikrBookmarksProvider);
  return bookmarks.any((b) => b.dhikrId == id);
});
 
