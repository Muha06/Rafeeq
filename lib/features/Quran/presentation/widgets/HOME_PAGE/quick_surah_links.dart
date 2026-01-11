import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/features/Quran/domain/entities/surah.dart';
import 'package:rafeeq/features/Quran/presentation/pages/surah_page.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/fetch_surahs_provider.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class SurahLink extends ConsumerWidget {
  final Surah surah;

  const SurahLink({super.key, required this.surah});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullSurahPage(surah: surah),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: theme.cardColor,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Center(
            child: Text(
              surah.nameTransliteration,
              style: theme.textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppDarkColors.textSecondary
                    : AppLightColors.textBody,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class QuickSurahLinks extends ConsumerWidget {
  const QuickSurahLinks({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);

    final quickSurahs = ref.watch(quickSurahLinksProvider);

    if (quickSurahs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick links', style: theme.textTheme.bodySmall),
        const SizedBox(height: 16),

        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: quickSurahs
                .map((surah) => SurahLink(surah: surah))
                .toList(),
          ),
        ),
      ],
    );
  }
}
