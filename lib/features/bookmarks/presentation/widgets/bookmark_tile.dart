import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/helpers/app_text_style.dart';
import 'package:rafeeq/core/helpers/app_toast.dart';
import 'package:rafeeq/core/widgets/app_icon_container.dart';
import 'package:rafeeq/features/adhkar/presentation/pages/adhkar_details_page.dart';
import 'package:rafeeq/features/adhkar/presentation/providers/adhkar_providers.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/dhikr_bookmark.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/quran_bookmark.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/Quran/quran_notifier_provider.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/dhikr/dhikr_notifier_provider.dart';
import 'package:rafeeq/features/bookmarks/presentation/widgets/bookmark_action_sheet.dart';
import 'package:rafeeq/features/quran/presentation/pages/surah_page.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/ayah_of_the_day.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_surahs_provider.dart';

class BookmarkTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final quranBookmark = quranBookMark;

    final isQuran = quranBookmark != null;

    if (isQuran) {
      return _QuranBookmarkTile(
        bookmark: quranBookMark!,
        indexDisplay: indexDisplay,
      );
    }

    return _DhikrBookmarkTile(
      bookmark: dhikrBookmark!,
      indexDisplay: indexDisplay,
    );
  }
}

class _QuranBookmarkTile extends ConsumerWidget {
  const _QuranBookmarkTile({
    required this.bookmark,
    required this.indexDisplay,
  });

  final QuranBookmarkEntity bookmark;
  final int indexDisplay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final cs = theme.colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final bookMarkSurah = ref.read(ayahSurahProvider(bookmark.surahId));

        final surahs = ref.read(surahsProvider).value ?? [];

        final s = surahs.firstWhere((s) => s.id == bookmark.surahId);

        final index = surahs.indexOf(s);

        if (bookMarkSurah != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullSurahPage(
                initialIndex: index,
                autoScrollAyah: bookmark.ayahNumber,
              ),
            ),
          );
        }
      },
      onLongPress: () {
        _showActions(context, ref, quranBookmark: bookmark);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: cs.surface,
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Arabic
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                bookmark.ayahArabic,
                maxLines: 2,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.quranAyah.copyWith(
                  fontFamily: 'Amiri',
                  color: cs.onSurface,
                  fontSize: 18.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                bookmark.ayahTranslation,
                maxLines: 2,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: tt.bodyLarge,
              ),
            ),

            const SizedBox(height: 8),

            // Actions & refrence
            const Divider(),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppIconContainer(
                  backgroundColor: cs.tertiaryContainer,
                  child: Icon(
                    HugeIconsSolid.bookmark01,
                    color: cs.onTertiaryContainer,
                    size: 14,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bookmark.surahName,
                        style: tt.titleLarge?.copyWith(fontSize: 13),
                      ),
                      const SizedBox(height: 0),

                      Text("Ayah ${bookmark.ayahNumber}", style: tt.bodySmall),
                    ],
                  ),
                ),

                IconButton(
                  onPressed: () =>
                      _showActions(context, ref, quranBookmark: bookmark),
                  icon: Icon(
                    HugeIconsSolid.moreHorizontal,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DhikrBookmarkTile extends ConsumerWidget {
  const _DhikrBookmarkTile({
    required this.bookmark,
    required this.indexDisplay,
  });

  final DhikrBookmark bookmark;
  final int indexDisplay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        //fetching adhkars

        final adhkar = await ref.read(
          fetchAllAdhkarProvider(bookmark.categoryId).future,
        );
        final dhikr = adhkar.firstWhere((e) => e.id == bookmark.dhikrId);

        if (!context.mounted) return;

        final index = adhkar.indexOf(dhikr);

        AppNav.push(
          context,
          AdhkarDetailsPage(adhkars: adhkar, initialIndex: index),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(indexDisplay.toString(), style: theme.textTheme.labelSmall),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              bookmark.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelLarge,
            ),
          ),

          IconButton(
            onPressed: () {
              _showActions(context, ref, dhikrBookmark: bookmark);
            },
            icon: Icon(Icons.more_horiz, color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

void _showActions(
  BuildContext context,
  WidgetRef ref, {
  QuranBookmarkEntity? quranBookmark,
  DhikrBookmark? dhikrBookmark,
}) {
  AppSheets.showBottomSheet(
    context: context,
    useSafeArea: true,
    child: BookmarkActionBottomSheet(
      quranBookmark: quranBookmark,
      dhikrBookmark: dhikrBookmark,
      onDeleteBookmark: () async {
        AppNav.pop(context);

        try {
          if (dhikrBookmark != null) {
            await ref
                .read(dhikrBookmarksProvider.notifier)
                .remove(dhikrBookmark.dhikrId);
          } else {
            await ref
                .read(quranBookmarksProvider.notifier)
                .removeBookmark(quranBookmark!.id);
          }

          if (!context.mounted) return;

          AppToast.showCompact(
            context: context,
            message: 'Bookmark removed',
            duration: const Duration(seconds: 2),
          );
        } catch (_) {
          if (!context.mounted) return;

          AppToast.showCompact(
            context: context,
            message: 'Delete failed. Please try again.',
            duration: const Duration(seconds: 2),
          );
        }
      },
    ),
  );
}
