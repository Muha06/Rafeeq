import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/dhikr_bookmark.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/dhikr/wiring_providers.dart';

final dhikrBookmarksProvider =
    NotifierProvider<DhikrBookmarksNotifier, List<DhikrBookmark>>(
      DhikrBookmarksNotifier.new,
    );

class DhikrBookmarksNotifier extends Notifier<List<DhikrBookmark>> {
  @override
  List<DhikrBookmark> build() {
    final adhkar = ref.read(getAllDhikrBookmarksUseCaseProvider).call();

    adhkar.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return adhkar;
  }

  Future<void> add(DhikrBookmark bookmark) async {
    await ref.read(addDhikrBookmarkUseCaseProvider).call(bookmark);

    state = [bookmark, ...state];
  }

  Future<void> remove(String bookmarkId) async {
    await ref.read(removeDhikrBookmarkUseCaseProvider).call(bookmarkId);

    state = state.where((b) => b.dhikrId != bookmarkId).toList();
  }

  Future<void> toggle(DhikrBookmark bookmark) async {
    final exists = state.any((b) => b.dhikrId == bookmark.dhikrId);

    if (exists) {
      await remove(bookmark.dhikrId);
      RafeeqAnalytics.logFeature('remove_bookmarked_dhikr');
    } else {
      await add(bookmark);
      RafeeqAnalytics.logFeature('bookmarked_dhikr');
    }
  }
}

final isDhikrBookmarkedProvider = Provider.family<bool, String>((ref, id) {
  final bookmarks = ref.watch(dhikrBookmarksProvider);
  return bookmarks.any((b) => b.dhikrId == id);
});
