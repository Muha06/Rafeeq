import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/app/providers/tabs_screen_provider.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/features/adhkar/presentation/pages/adhkar_details_page.dart';
import 'package:rafeeq/features/adhkar/presentation/riverpod/get_adhkars_provider.dart';
import 'package:rafeeq/features/bookmarks/presentation/pages/bookmark_page.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/dhikr/dhikr_notifier_provider.dart';
import 'package:rafeeq/features/bookmarks/widgets/bookmark_tile.dart';

class AdhkarBookmarksTab extends ConsumerStatefulWidget {
  const AdhkarBookmarksTab({super.key});

  @override
  ConsumerState<AdhkarBookmarksTab> createState() => _AdhkarBookmarksTabState();
}

class _AdhkarBookmarksTabState extends ConsumerState<AdhkarBookmarksTab> {
  @override
  Widget build(BuildContext context) {
    final bookMarks = ref.watch(dhikrBookmarksProvider);
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
                onTap: () async {
                  //fetching adhkars
                  final adhkars = await ref.read(
                    getAdhkarsProvider([bookMark.categoryId]).future,
                  );

                  // //fetching actual dhikr
                  final dhikr = adhkars.firstWhere(
                    (dhikr) => dhikr.id == bookMark.dhikrId,
                  );
                  
                  if (!context.mounted) return;

                  AppNav.push(
                    context,
                    AdhkarDetailsPage(
                      adhkars: [dhikr],
                      title: dhikr.categoryTitle,
                    ),
                  );
                },
                child: BookmarkTile(
                  dhikrBookmark: bookMark,
                  indexDisplay: indexDisplay,
                ),
              );
            },
          );
  }
}
