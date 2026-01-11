import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/features/Quran/domain/entities/surah.dart';
import 'package:rafeeq/features/Quran/presentation/pages/surah_page.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/fetch_surahs_provider.dart';
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

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final surah = surahs[index];
            return SurahTile(surah: surah);
          }, childCount: surahs.length),
        );
      },
    );
  }
}

class SurahTile extends ConsumerWidget {
  final Surah surah;

  const SurahTile({super.key, required this.surah});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.hardEdge,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: theme.cardColor,
          ),
          child: ListTile(
            splashColor: null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullSurahPage(surah: surah),
                ),
              );
            },
            leading: CircleAvatar(
              backgroundColor: AppLightColors.amber,
              radius: 16,
              child: Text(
                surah.id.toString(),
                style: const TextStyle(
                  color: AppLightColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            title: Text(
              surah.nameTransliteration,
              style: theme.textTheme.titleMedium,
            ),
            subtitle: Text(surah.nameEnglish, style: theme.textTheme.bodySmall),
            trailing: Text(
              surah.versesCount.toString(),
              style: theme.textTheme.bodySmall,
            ),
          ),
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
            border: Border.all(color: AppDarkColors.darkSurface),
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
