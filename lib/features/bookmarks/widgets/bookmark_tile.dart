import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rafeeq/core/helpers/snackbars.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/dhikr_bookmark.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/quran_bookmark.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/Quran/execution_providers.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/dhikr/dhikr_notifier_provider.dart';
import 'package:rafeeq/features/bookmarks/widgets/bookmark_action_sheet.dart';

class BookmarkTile extends ConsumerStatefulWidget {
  const BookmarkTile({
    super.key,
    required this.indexDisplay,
    this.quranBookMark,
    this.dhikrBookmark,
  }) : assert(
         quranBookMark != null || dhikrBookmark != null,
         'Either quranBookMark or dhikrBookmark must be provided.',
       ),
       assert(
         !(quranBookMark != null && dhikrBookmark != null),
         'Provide only one bookmark type at a time.',
       );

  final QuranBookmarkEntity? quranBookMark;
  final DhikrBookmark? dhikrBookmark;
  final int indexDisplay;

  @override
  ConsumerState<BookmarkTile> createState() => _BookmarkTileState();
}

class _BookmarkTileState extends ConsumerState<BookmarkTile> {
  Future<void> deleteBookmark(
    WidgetRef ref, {
    QuranBookmarkEntity? quranBookmark,
    DhikrBookmark? dhikrBookmark,
  }) async {
    //delete bookmark
    try {
      //delete dhikr bookmark
      if (dhikrBookmark != null) {
        await ref
            .read(dhikrBookmarksProvider.notifier)
            .remove(dhikrBookmark.dhikrId);
      } else {
        await ref.read(removeQuranBookmarkProvider(quranBookmark!.id))();
      }
      if (context.mounted) {
        AppSnackBar.showSimple(
          context: context,
          message: 'Bookmark removed ❌',
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackBar.showSimple(
          context: context,
          message: 'Delete failed. Please try again.',
          duration: const Duration(seconds: 2),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dhikrBookmark = widget.dhikrBookmark;
    final quranBookmark = widget.quranBookMark;

    final title = quranBookmark?.surahEnglishName ?? dhikrBookmark!.title;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Text(
            widget.indexDisplay.toString(),
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium,
                ),

                if (quranBookmark != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    ' ${quranBookmark.surahId}:${quranBookmark.ayahNumber}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                showDragHandle: true,
                builder: (_) => BookmarkActionBottomSheet(
                  quranBookmark: quranBookmark,
                  dhikrBookmark: dhikrBookmark,
                  onDeleteBookmark: () async {
                    Navigator.pop(context); // close sheet once
                    if (quranBookmark != null) {
                      await deleteBookmark(ref, quranBookmark: quranBookmark);
                    } else {
                      await deleteBookmark(ref, dhikrBookmark: dhikrBookmark);
                    }
                  },
                ),
              );
            },
            icon: const FaIcon(FontAwesomeIcons.ellipsis),
          ),
        ],
      ),
    );
  }
}
