import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/features/adhkar/presentation/pages/adhkar_details_page.dart';
import 'package:rafeeq/features/adhkar/presentation/riverpod/get_adhkars_provider.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/dhikr/execution_providers.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class AdhkarBookmarksTab extends ConsumerStatefulWidget {
  const AdhkarBookmarksTab({super.key});

  @override
  ConsumerState<AdhkarBookmarksTab> createState() => _AdhkarBookmarksTabState();
}

class _AdhkarBookmarksTabState extends ConsumerState<AdhkarBookmarksTab> {
  @override
  Widget build(BuildContext context) {
    final bookMarks = ref.watch(getAllDhikrBookmarksProvider);
    final isDark = ref.watch(isDarkProvider);
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
                onTap: () async {
                  final adhkars = await ref.read(
                    getAdhkarsProvider(bookMark.assetPath).future,
                  );

                  final initialIndex = adhkars.indexWhere(
                    (d) => d.id == bookMark.dhikrId,
                  );
                  if (initialIndex == -1) return;

                  final dhikr = adhkars[initialIndex];

                  if (!context.mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdhkarDetailsPage(
                        dhikr: dhikr,
                        adhkars: adhkars,
                        assetPath: bookMark.assetPath,
                        initialIndex: initialIndex,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 28, child: Text(indexDisplay.toString())),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          bookMark.title,
                          style: theme.textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: () async {
                          await ref.read(
                            removeDhikrBookmarkActionProvider(bookMark.dhikrId),
                          )();
                        },
                        icon: Icon(
                          Icons.delete,
                          color: isDark
                              ? AppDarkColors.iconSecondary
                              : AppLightColors.iconSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
