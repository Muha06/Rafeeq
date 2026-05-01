import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/presentation/pages/surah_page.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_surahs_provider.dart';

class QuickSurahLinks extends ConsumerWidget {
  const QuickSurahLinks({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);

    final quickSurahs = ref.watch(quickSurahLinksProvider);

    if (quickSurahs.isEmpty) {
      return const SizedBox.shrink();
    }
    final hasData = quickSurahs.isNotEmpty;

    return SizedBox(
      height: hasData ? 85 : 0,
      child: hasData
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quick links', style: theme.textTheme.bodySmall),
                const SizedBox(height: 12),

                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: quickSurahs
                        .map((surah) => SurahLink(surah: surah))
                        .toList(),
                  ),
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }
}

class SurahLink extends ConsumerWidget {
  final Surah surah;

  const SurahLink({super.key, required this.surah});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        AppNav.push(context, FullSurahPage(surah: surah));
      },
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Center(
          child: Text(
            surah.nameTransliteration,
            style: theme.textTheme.labelMedium,
          ),
        ),
      ),
    );
  }
}
