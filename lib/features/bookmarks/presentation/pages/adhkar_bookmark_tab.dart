import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/app/providers/tabs_screen_provider.dart';
import 'package:rafeeq/features/adhkar/presentation/pages/adhkar_details_page.dart';
import 'package:rafeeq/features/adhkar/presentation/riverpod/get_adhkars_provider.dart';
import 'package:rafeeq/features/bookmarks/presentation/pages/bookmark_page.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/dhikr/execution_providers.dart';
import 'package:rafeeq/features/bookmarks/widgets/bookmark_tile.dart';

class AdhkarBookmarksTab extends ConsumerStatefulWidget {
  const AdhkarBookmarksTab({super.key});

  @override
  ConsumerState<AdhkarBookmarksTab> createState() => _AdhkarBookmarksTabState();
}

class _AdhkarBookmarksTabState extends ConsumerState<AdhkarBookmarksTab> {
  @override
  Widget build(BuildContext context) {
    final bookMarks = ref.watch(getAllDhikrBookmarksProvider);
    final theme = Theme.of(context);

    return bookMarks.isEmpty
        ? Center(
            child: EmptyState(
              icon: PhosphorIcons.handsPraying(),
              subtitle:
                  "You haven't bookmarked any Dhikr yet. bookmark your best Adhkars to find them instantly.",
              buttonText: 'Explore Adhkars',
              onPressed: () {
                ref.read(tabsScreenIndexProvider.notifier).state = 2;
              },
            ),
          )
        : ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(color: theme.dividerColor);
            },
            itemCount: bookMarks.length,
            itemBuilder: (context, index) {
              final bookMark = bookMarks[index];
              final indexDisplay = index + 1;

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                // onTap: () {
                //   //fetching adhkars
                //   final adhkars = ref
                //       .read(getAdhkarsProvider(bookMark.dhikrId))
                //       .value;

                //   //fetching actual dhikr
                //   if (adhkars != null) {
                //     final dhikr = adhkars.firstWhere(
                //       (dhikr) => dhikr. == bookMark.dhikrId,
                //     );

                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => AdhkarDetailsPage(
                //           dhikr: dhikr,
                //           assetPath: bookMark.assetPath,
                //         ),
                //       ),
                //     );
                //   }
                // },
                child: BookmarkTile(
                  dhikrBookmark: bookMark,
                  indexDisplay: indexDisplay,
                ),
              );
            },
          );
  }
}
