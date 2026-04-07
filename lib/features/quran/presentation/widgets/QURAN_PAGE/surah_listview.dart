import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/clean_arabic_text.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
import 'package:rafeeq/core/themes/app_text_style.dart';
import 'package:rafeeq/core/widgets/app_state_view.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/presentation/pages/surah_page.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_surahs_provider.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';
import 'package:shimmer/shimmer.dart';

class AllSurahsList extends ConsumerWidget {
  const AllSurahsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(surahsProvider);

    return surahsAsync.when(
      data: (surahs) {
        if (surahs.isEmpty) {
          return const Center(child: Text('No surahs found.'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: surahs.length,
          itemBuilder: (context, index) {
            final surah = surahs[index];

            return SurahTile(surah: surah, surahs: surahs, index: index);
          },
        );
      },
      error: (error, stackTrace) {
        RafeeqAnalytics.logError(error.toString(), stack: stackTrace);

        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: AppStateView(
              icon: PhosphorIcons.warningCircle(),
              title: "Something went wrong",
              message: "We couldn't load the surahs. Please try again Later.",
              buttonText: "Retry",
              onPressed: () => ref.refresh(surahsProvider),
            ),
          ),
        );
      },
      loading: () => const SurahTileShimmer(),
    );
  }
}

class SurahTile extends ConsumerWidget {
  final Surah surah;
  final List<Surah> surahs;
  final int index;

  const SurahTile({
    super.key,
    required this.surah,
    required this.surahs,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          AppNav.push(
            context,
            FullSurahPage(surah: surah),
          ).then((value) => RafeeqAnalytics.logScreenView('surah_page'));
        },
        child: Row(
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    isDark
                        ? 'assets/images/quran/surah_badge_dark.png'
                        : 'assets/images/quran/surah_badge_light.png',
                    width: 44,
                    height: 44,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    surah.id.toString(),
                    style: theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  surah.nameTransliteration,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 6),

                Text(
                  "${surah.nameTransliteration} • Verses ${surah.versesCount} ",
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),

            const Spacer(),

            Text(
              cleanAyah(surah.nameArabic),
              style: AppTextStyles.quranAyah.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SurahTileShimmer extends StatelessWidget {
  const SurahTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final baseColor = theme.colorScheme.surface.withAlpha(64);
    final highlightColor = theme.colorScheme.onSurface.withAlpha(64);

    return ListView.builder(
      itemCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(),
              //color: isDark ? AppColors.darkSurface : AppColors.darkSurface,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),

              // Leading circle (surah number)
              leading: const CircleAvatar(backgroundColor: Colors.white),

              // Title shimmer
              title: Container(
                height: 16,
                width: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),

              // Subtitle shimmer
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  height: 12,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),

              // Trailing ayah count
              trailing: Container(
                height: 12,
                width: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
