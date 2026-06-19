import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/app/providers/tabs_screen_provider.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/widgets/app_state_view.dart';
import 'package:rafeeq/features/adhkar_02/presentation/pages/adhkar_details_page.dart';
import 'package:rafeeq/features/adhkar_02/presentation/providers/adhkar_providers.dart';
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
            child: AppStateView(
              icon: PhosphorIcons.handsPraying(),
              title: 'No Bookmarks',
              message:
                  "You haven't bookmarked any Dhikr yet. bookmark your best Adhkars to find them instantly.",
              buttonText: "Explore Adhkars",
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

                  final adhkar = await ref.read(
                    fetchAllAdhkarProvider(bookMark.categoryId).future,
                  );
                  final dhikr = adhkar.firstWhere(
                    (d) => d.id == bookMark.dhikrId,
                  );

                  if (!context.mounted) return;

                  AppNav.push(context, AdhkarDetailsPage(dhikr: dhikr));
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
