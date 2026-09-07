import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/constants/spacing/app_spacing.dart';
import 'package:rafeeq/core/constants/strings/app_strings.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/widgets/app_pressable.dart';
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
    const screenHorizontal = AppSpacing.screenHorizontal;

    return surahsAsync.when(
      data: (surahs) {
        final searchSurahText = ref.watch(searchSurahTextProvider);
        final q = searchSurahText.trim().toLowerCase();

        final filtered = q.isEmpty
            ? surahs
            : surahs.where((s) {
                return s.nameTransliteration.toLowerCase().contains(q) ||
                    s.nameEnglish.toLowerCase().contains(q) ||
                    s.id.toString() == q;
              }).toList();

        if (filtered.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(child: Text('No surahs found.')),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: screenHorizontal,
            vertical: 8,
          ),

          sliver: SliverSafeArea(
            top: false,
            sliver: SliverList.separated(
              separatorBuilder: (_, index) => const SizedBox(height: 24),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final surah = filtered[index];

                return AppPressableScale(
                  onTap: () {
                    AppNav.push(
                      context,
                      FullSurahPage(initialIndex: surah.id - 1),
                    );
                  },
                  child: SurahTile(surah: surah, index: index),
                );
              },
            ),
          ),
        );
      },
      error: (error, _) {
        return SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: AppStateView(
                icon: PhosphorIcons.warningCircle,
                title: "Something went wrong",
                message: "We couldn't load the surahs. Please try again Later.",
                buttonText: "Retry",
                onPressed: () => ref.refresh(surahsProvider),
              ),
            ),
          ),
        );
      },
      loading: () => const SliverToBoxAdapter(child: SurahTileShimmer()),
    );
  }
}

class SurahTile extends ConsumerStatefulWidget {
  final Surah surah;
  final int index;

  const SurahTile({super.key, required this.surah, required this.index});

  @override
  ConsumerState<SurahTile> createState() => _SurahTileState();
}

class _SurahTileState extends ConsumerState<SurahTile>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SurahTileNumber(surahId: widget.surah.id),

        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.surah.nameTransliteration,
                style: theme.textTheme.labelLarge,
              ),
              const SizedBox(height: 6),

              Text(
                widget.surah.nameEnglish,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),

        Text(
          "${widget.surah.versesCount} ayahs",
          style: theme.textTheme.labelSmall,
        ),
      ],
    );
  }
}

class SurahTileNumber extends ConsumerWidget {
  const SurahTileNumber({super.key, required this.surahId});

  final int surahId;

  @override
  Widget build(BuildContext context, ref) {
    final isDark = ref.watch(isDarkProvider);
    final theme = Theme.of(context);

    return SizedBox(
      width: 46,
      height: 46,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            isDark
                ? 'assets/images/quran/surah_badge_dark.png'
                : 'assets/images/quran/surah_badge_light.png',
            width: 48,
            height: 48,
            fit: BoxFit.contain,
          ),
          Text(
            surahId.toString(),
            textAlign: TextAlign.center,
            style: theme.textTheme.labelLarge?.copyWith(
              fontFamily: AppStrings.displayFont,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class SurahTileShimmer extends StatelessWidget {
  const SurahTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final baseColor = cs.surface.withAlpha(64);
    final highlightColor = cs.onSurface.withAlpha(64);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        children: List.generate(
          7,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                const SizedBox(width: 46, height: 46, child: CircleAvatar()),
                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14,
                        width: 140,
                        decoration: BoxDecoration(
                          color: cs.onSurface,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 11,
                        width: 90,
                        decoration: BoxDecoration(
                          color: cs.onSurface,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                Container(
                  height: 11,
                  width: 50,
                  decoration: BoxDecoration(
                    color: cs.onSurface,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
