import 'package:flutter/material.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/features/Quran/domain/entities/last_read_ayah.dart';

class QuickLastReadList extends StatelessWidget {
  const QuickLastReadList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (sampleLastReadAyahs.isEmpty) {
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
            itemCount: sampleLastReadAyahs.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final lastRead = sampleLastReadAyahs[index];
              return SizedBox(
                // width: 250, // card width
                child: QuickLastReadCard(lastRead: lastRead),
              );
            },
          ),
        ),
      ],
    );
  }
}

class QuickLastReadCard extends StatelessWidget {
  final LastReadAyah lastRead;

  const QuickLastReadCard({super.key, required this.lastRead});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {},
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

final List<LastReadAyah> sampleLastReadAyahs = [
  const LastReadAyah(
    surahId: 1,
    surahName: 'Al-Fātiḥah',
    ayahNumber: 7,
    verseCount: 7,
  ),
  const LastReadAyah(
    surahId: 2,
    surahName: 'Al-Baqarah',
    ayahNumber: 255,
    verseCount: 286,
  ),
  const LastReadAyah(
    surahId: 36,
    surahName: 'Yā Sīn',
    ayahNumber: 12,
    verseCount: 83,
  ),
  const LastReadAyah(
    surahId: 112,
    surahName: 'Al-Ikhlāṣ',
    ayahNumber: 4,
    verseCount: 4,
  ),
  const LastReadAyah(
    surahId: 18,
    surahName: 'Al-Kahf',
    ayahNumber: 10,
    verseCount: 110,
  ),
];
