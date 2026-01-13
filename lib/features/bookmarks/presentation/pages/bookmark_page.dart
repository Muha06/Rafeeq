import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/execution_providers.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class BookmarkPage extends ConsumerStatefulWidget {
  const BookmarkPage({super.key});

  @override
  ConsumerState<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends ConsumerState<BookmarkPage> {
  @override
  Widget build(BuildContext context) {
    final bookMarks = ref.watch(getAllQuranBookmarksProvider);
    final isDark = ref.watch(isDarkProvider);

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(clearAllQuranBookmarksProvider.future);
            },
            icon: const Icon(Icons.delete_forever),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(thickness: 1, color: theme.dividerColor.withAlpha(20)),
        ),
      ),

      body: ListView.builder(
        itemCount: bookMarks.length,
        itemBuilder: (context, index) {
          final bookMark = bookMarks[index];
          final indexDisplay = index + 1;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerColor.withAlpha(20),
                    width: 1,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Text(indexDisplay.toString()),
                  const SizedBox(width: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ' ${bookMark.surahEnglishName}',
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),

                      Text(
                        ' ${bookMark.surahId}:${bookMark.ayahNumber}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const Spacer(),

                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: isDark
                              ? AppDarkColors.iconPrimary
                              : AppLightColors.iconPrimary,
                        ),
                        onPressed: () {
                          ref.read(
                            removeQuranBookmarkProvider(bookMark.id).future,
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.share),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
