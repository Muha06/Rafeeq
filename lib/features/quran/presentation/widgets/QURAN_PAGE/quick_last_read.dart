import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
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
            Text('Last read', style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),

            // Horizontal scrollable cards
            SizedBox(
              height: 80,
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
  bool _isSelected = false; //for long press style

  Future<void> _showDeleteLastReadSheet(
    BuildContext context,
    WidgetRef ref,
    LastReadAyah lastRead,
  ) {
    setState(() {
      _isSelected = true;
    });
    return showModalBottomSheet(
      context: context,
      builder: (_) {
        final theme = Theme.of(context);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.delete_outline, size: 72),
              const SizedBox(height: 16),

              Text('Remove last read?', style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),

              Text(
                '${lastRead.surahName} • Ayah ${lastRead.ayahNumber}',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        await ref
                            .read(lastReadRepositoryProvider)
                            .removeLastRead(lastRead.surahId);

                        if (context.mounted) {
                          ref.invalidate(lastReadAyahsProvider);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Delete'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        final surahs = ref.read(surahsProvider).value ?? [];
        final surah = surahs.firstWhere((s) => s.id == widget.lastRead.surahId);

        AppNav.push(
          context,
          FullSurahPage(
            autoScrollAyah: widget.lastRead.ayahNumber,
            surah: surah,
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

        setState(() {
          _isSelected = false;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _isSelected ? cs.surfaceContainerHighest : cs.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.lastRead.surahName, style: theme.textTheme.labelLarge),
            Text(
              'Ayah ${widget.lastRead.ayahNumber} of ${widget.lastRead.verseCount}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
