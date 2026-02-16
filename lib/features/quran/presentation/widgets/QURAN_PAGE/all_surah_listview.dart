import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/clean_arabic_text.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/presentation/pages/surah_page.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_surahs_provider.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';
import 'package:shimmer/shimmer.dart';

class AllSurahsList extends ConsumerStatefulWidget {
  const AllSurahsList({super.key});

  @override
  ConsumerState<AllSurahsList> createState() => _AllSurahsListState();
}

class _AllSurahsListState extends ConsumerState<AllSurahsList> {
  @override
  Widget build(BuildContext context) {
    final surahAsync = ref.watch(surahsFutureProvider);

    return surahAsync.when(
      error: (e, st) => const SliverToBoxAdapter(
        child: Center(child: Text('Error loading surahs')),
      ),
      loading: () => SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => const SurahTileShimmer(),
          childCount: 8,
        ),
      ),
      data: (data) {
        final surahs = data;

        return SliverList.separated(
          itemCount: surahs.length,
          separatorBuilder: (context, index) =>
              Divider(thickness: 1, color: Theme.of(context).dividerColor),
          itemBuilder: (context, index) {
            final surah = surahs[index];
            return SurahTile(surah: surah, surahs: surahs, index: index);
          },
        );
      },
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
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 14),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullSurahPage(surah: surah),
            ),
          );
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
              cleanAyah(surah.nameArabic.toString()),
              style: theme.textTheme.bodyLarge!.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
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
    final isDark = theme.brightness == Brightness.dark;

    final baseColor = isDark
        ? theme.cardColor.withAlpha(150)
        : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.grey[800]! : Colors.grey.shade100;

    return Padding(
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
    );
  }
}
