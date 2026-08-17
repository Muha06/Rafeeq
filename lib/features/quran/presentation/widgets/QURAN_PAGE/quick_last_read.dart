import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:rafeeq/core/constants/spacing/app_spacing.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/features/quran/domain/entities/last_read_ayah.dart';
import 'package:rafeeq/features/quran/presentation/pages/surah_page.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_surahs_provider.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/last_read_provider.dart';

class QuickLastReadList extends ConsumerWidget {
  const QuickLastReadList({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);

    final lastReadAyahsAsync = ref.watch(
      lastReadAyahsProvider,
    ); // Fetch last read ayahs

    if (lastReadAyahsAsync.isLoading) {
      return const SizedBox(height: 120); // hide if nothing to show
    }

    return lastReadAyahsAsync.when(
      error: (error, stack) {
        return const SizedBox.shrink(); // hide if error
      },
      loading: () => const SizedBox.shrink(), // hide if loading
      data: (lastReadAyahs) {
        if (lastReadAyahs.isEmpty) {
          return const SizedBox.shrink(); // hide if nothing to show
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text('Last read', style: theme.textTheme.labelSmall),
            const SizedBox(height: 8),

            // Horizontal scrollable cards
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: lastReadAyahs.length,
                itemBuilder: (context, index) {
                  final lastRead = lastReadAyahs[index];
                  return QuickLastReadCard(
                    lastRead: lastRead,
                    key: ValueKey(lastRead.surahId),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class QuickLastReadCard extends ConsumerStatefulWidget {
  final LastReadAyah lastRead;

  const QuickLastReadCard({super.key, required this.lastRead});

  @override
  ConsumerState<QuickLastReadCard> createState() => _QuickLastReadCardState();
}

class _QuickLastReadCardState extends ConsumerState<QuickLastReadCard> {
  bool _isSelected = false;

  Future<void> _showDeleteLastReadSheet(
    BuildContext context,
    WidgetRef ref,
    LastReadAyah lastRead,
  ) {
    setState(() {
      _isSelected = true;
    });

    return AppSheets.showConfirmSheet(
      context: context,
      icon: HugeIconsSolid.delete02,
      title: 'Remove last read?',
      useSafeArea: true,
      destructive: true,
      onConfirm: () async {
        await ref
            .read(lastReadRepositoryProvider)
            .removeLastRead(lastRead.surahId);

        if (context.mounted) {
          ref.invalidate(lastReadAyahsProvider);
          AppNav.pop(context);
        }
      },
      description: "Are you sure you want to delete last read?",
      confirmText: 'Yes, delete',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final progress =
        widget.lastRead.ayahNumber.toDouble() /
        widget.lastRead.verseCount.toDouble();

    return GestureDetector(
      onTap: () {
        final surahs = ref.read(surahsProvider).value ?? [];
        final surah = surahs.firstWhere((s) => s.id == widget.lastRead.surahId);

        final index = surahs.indexOf(surah);
        AppNav.push(
          context,
          FullSurahPage(
            autoScrollAyah: widget.lastRead.ayahNumber,
            initialIndex: index,
          ),
        );
      },

      //delete
      onLongPress: () async {
        HapticFeedback.vibrate();
        setState(() {
          _isSelected = true;
        });

        await _showDeleteLastReadSheet(context, ref, widget.lastRead);

        if (mounted) {
          setState(() => _isSelected = false);
        }
      },
      child: IntrinsicWidth(
        child: Container(
          margin: const EdgeInsets.only(top: 8, bottom: 8, right: 16),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: _isSelected ? cs.surfaceContainerHighest : cs.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.lastRead.surahName,
                style: theme.textTheme.labelLarge,
              ),
              Text(
                'Ayah ${widget.lastRead.ayahNumber} of ${widget.lastRead.verseCount}',
                style: theme.textTheme.labelSmall,
              ),

              const SizedBox(height: 4),

              LinearProgressIndicator(
                value: progress.clamp(0, 1),
                color: cs.primary,
                backgroundColor: cs.onSurface.withValues(alpha: 0.1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
