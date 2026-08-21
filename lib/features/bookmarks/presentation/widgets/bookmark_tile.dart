import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/helpers/app_toast.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/dhikr_bookmark.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/quran_bookmark.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/Quran/quran_notifier_provider.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/dhikr/dhikr_notifier_provider.dart';
import 'package:rafeeq/features/bookmarks/presentation/widgets/bookmark_action_sheet.dart';
import 'package:rafeeq/features/quran/presentation/widgets/QURAN_PAGE/surah_listview.dart';

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
        await ref
            .read(quranBookmarksProvider.notifier)
            .removeBookmark(quranBookmark!.id);
      }
      if (!mounted) return;

      AppToast.showCompact(
        context: context,
        message: 'Bookmark removed',
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      if (context.mounted) {
        AppToast.showCompact(
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
    final cs = theme.colorScheme;
    final dhikrBookmark = widget.dhikrBookmark;
    final quranBookmark = widget.quranBookMark;

    final title = quranBookmark?.surahEnglishName ?? dhikrBookmark!.title;

    final isQuran = quranBookmark != null;

    if (isQuran) {
      return const _QuranBookmarkTile();
    }

    return Row(
      children: [
        if (isQuran)
          SurahTileNumber(surahId: quranBookmark.surahId)
        else
          const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isQuran) ...[
                const SizedBox(height: 4),
                Text(
                  'Ayah ${quranBookmark.ayahNumber}',
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ],
          ),
        ),

        IconButton(
          onPressed: () {
            AppSheets.showBottomSheet(
              context: context,
              useSafeArea: true,
              child: BookmarkActionBottomSheet(
                quranBookmark: quranBookmark,
                dhikrBookmark: dhikrBookmark,
                onDeleteBookmark: () async {
                  AppNav.pop(context);
                  if (quranBookmark != null) {
                    await deleteBookmark(ref, quranBookmark: quranBookmark);
                  } else {
                    await deleteBookmark(ref, dhikrBookmark: dhikrBookmark);
                  }
                },
              ),
            );
          },
          icon: Icon(Icons.more_horiz, color: cs.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _QuranBookmarkTile extends StatelessWidget {
  const _QuranBookmarkTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _DhikrBookmarkTile extends StatelessWidget {
  const _DhikrBookmarkTile({
    super.key,
    required this.indexDisplay,
    required this.title,
  });
  final int indexDisplay;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(indexDisplay.toString(), style: theme.textTheme.labelSmall),

        const SizedBox(width: 8),

        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelLarge,
        ),
        const SizedBox(width: 8),

        //  IconButton(
        //   onPressed: () {
        //     AppSheets.showBottomSheet(
        //       context: context,
        //       useSafeArea: true,
        //       child: BookmarkActionBottomSheet(
        //         quranBookmark: quranBookmark,
        //         dhikrBookmark: dhikrBookmark,
        //         onDeleteBookmark: () async {
        //           AppNav.pop(context);
        //           if (quranBookmark != null) {
        //             await deleteBookmark(ref, quranBookmark: quranBookmark);
        //           } else {
        //             await deleteBookmark(ref, dhikrBookmark: dhikrBookmark);
        //           }
        //         },
        //       ),
        //     );
        //   },
        //   icon: Icon(Icons.more_horiz, color: cs.onSurfaceVariant),
        // ),
      ],
    );
  }
}
