import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/features/quran/domain/entities/last_read_ayah.dart';
import 'package:rafeeq/features/quran/presentation/pages/surah_page.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_surahs_provider.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/last_read_provider.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

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
            Text('Last read', style: theme.textTheme.titleMedium),
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
      showDragHandle: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final theme = Theme.of(context);
        final isDark = ref.watch(isDarkProvider);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          decoration: BoxDecoration(
            color: isDark
                ? AppDarkColors.bottomSheet
                : AppLightColors.lightSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.delete_outline,
                size: 72,
                color: isDark
                    ? AppDarkColors.iconPrimary
                    : AppLightColors.iconPrimary,
              ),
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
                    child: ElevatedButton(
                      onPressed: () async {
                        await ref
                            .read(lastReadRepositoryProvider)
                            .removeLastRead(lastRead.surahId);

                        if (context.mounted) {
                          ref.invalidate(lastReadAyahsProvider);
                        }
                        Navigator.pop(context);
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
    final isDark = ref.watch(isDarkProvider);

    return GestureDetector(
      onTap: () {
        // Fetch the Surah from the cached surahs in hive
        final surah = ref
            .watch(surahsFutureProvider)
            .maybeWhen(
              data: (surahs) => surahs.firstWhere(
                (s) => s.id == widget.lastRead.surahId,
                orElse: () => throw Exception('Surah not found in cache'),
              ),
              orElse: () => throw Exception('Failed to fetch surahs'),
            );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullSurahPage(
              surah: surah,
              autoScrollAyah: widget.lastRead.ayahNumber,
            ),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark
              ? _isSelected
                    ? AppDarkColors.divider
                    : AppDarkColors.darkSurface
              : _isSelected
              ? AppLightColors.buttonSecondaryBorder
              : AppLightColors.lightSurface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.lastRead.surahName, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
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
