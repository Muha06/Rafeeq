import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
              return Divider(color: theme.dividerColor.withAlpha(20));
            },
            itemCount: bookMarks.length,
            itemBuilder: (context, index) {
              final bookMark = bookMarks[index];
              final indexDisplay = index + 1;

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
                child: ListTile(
                  leading: Text(indexDisplay.toString()),
                  title: Text(bookMark.title),
                  trailing: IconButton(
                    onPressed: () {
                      ref.read(toggleDhikrBookmarkProvider(bookMark));
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ),
              );
            },
          );
  }
}
