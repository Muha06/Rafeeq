import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/widgets/app_drag_handle.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/dhikr_bookmark.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/quran_bookmark.dart';

class BookmarkActionBottomSheet extends ConsumerWidget {
  const BookmarkActionBottomSheet({
    super.key,
    this.quranBookmark,
    this.dhikrBookmark,
    required this.onDeleteBookmark,
  });

  final QuranBookmarkEntity? quranBookmark;
  final DhikrBookmark? dhikrBookmark;
  final VoidCallback onDeleteBookmark;
  @override
  Widget build(BuildContext context, ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 120,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppDragHandle(),

              _ActionTile(
                icon: HugeIconsStroke.delete03,
                title: 'Delete',
                subtitle: 'This can’t be undone',
                onTap: onDeleteBookmark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends ConsumerWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          PhosphorIcon(icon),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.labelLarge),
                const SizedBox(height: 2),

                if (subtitle != null)
                  Text(subtitle!, style: theme.textTheme.bodySmall?.copyWith()),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}
