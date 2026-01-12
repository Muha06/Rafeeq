import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/features/Quran/domain/entities/last_read_ayah.dart';
import 'package:rafeeq/features/Quran/presentation/pages/surah_page.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/fetch_surahs_provider.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/last_read_provider.dart';

class QuickLastReadList extends ConsumerWidget {
  const QuickLastReadList({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);

    final lastReadAyahsAsync = ref.watch(
      lastReadAyahsProvider,
    ); // Fetch last read ayahs

    if (lastReadAyahsAsync.isLoading) {
      return const SizedBox(); // hide if nothing to show
    }

    return lastReadAyahsAsync.when(
      error: (error, stack) { 
        return const SizedBox.shrink(); // hide if error
      },
      loading: () => const SizedBox.shrink(),
      data: (lastReadAyahs) {
        if (lastReadAyahs.isEmpty) {
          return const SizedBox.shrink(); // hide if nothing to show
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text('Last Read', style: theme.textTheme.bodySmall!.copyWith()),
            const SizedBox(height: 8),

            // Horizontal scrollable cards
            SizedBox(
              height: 100, // adjust based on card height
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: lastReadAyahs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final lastRead = lastReadAyahs[index];
                  return SizedBox(
                    // width: 250, // card width
                    child: QuickLastReadCard(lastRead: lastRead),
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

class QuickLastReadCard extends ConsumerWidget {
  final LastReadAyah lastRead;

  const QuickLastReadCard({super.key, required this.lastRead});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        // Fetch the Surah from the cached surahs in hive
        final surah = ref
            .watch(surahsFutureProvider)
            .maybeWhen(
              data: (surahs) => surahs.firstWhere(
                (s) => s.id == lastRead.surahId,
                orElse: () => throw Exception('Surah not found in cache'),
              ),
              orElse: () => throw Exception('Failed to fetch surahs'),
            );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FullSurahPage(surah: surah)),
        );
      },
      child: Stack(
        children: [
          Container(
            width: 200,
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: isDark
                  ? AppDarkColors.darkSurface
                  : AppLightColors.lightSurface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withAlpha(120)
                      : Colors.black.withAlpha(10),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lastRead.surahName,
                  style: theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ayah ${lastRead.ayahNumber} of ${lastRead.verseCount}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Image.asset(
              'assets/images/quran_book.png',
              height: 26,
              width: 26,
            ),
          ),
        ],
      ),
    );
  }
}
