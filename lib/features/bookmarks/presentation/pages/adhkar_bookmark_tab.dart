import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/adhkar/presentation/pages/adhkar_details_page.dart';
import 'package:rafeeq/features/adhkar/presentation/riverpod/get_adhkars_provider.dart';
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
            child: Text(
              'No bookmarks yet',
              style: theme.textTheme.bodySmall!.copyWith(fontSize: 16),
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
                onTap: () {
                  //fetching adhkars
                  final adhkars = ref
                      .read(getAdhkarsProvider(bookMark.assetPath))
                      .value;

                  //fetching actual dhikr
                  if (adhkars != null) {
                    final dhikr = adhkars.firstWhere(
                      (dhikr) => dhikr.id == bookMark.dhikrId,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdhkarDetailsPage(
                          dhikr: dhikr,
                          assetPath: bookMark.assetPath,
                        ),
                      ),
                    );
                  }
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
