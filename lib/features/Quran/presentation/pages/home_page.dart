import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri_date/hijri.dart';
import 'package:rafeeq/core/animations/navigation_animations.dart';
import 'package:rafeeq/core/themes/app_colors.dart';
import 'package:rafeeq/features/Quran/domain/entities/surah.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/ayah_of_the_day.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/fetch_surahs_provider.dart';
import 'package:rafeeq/features/Quran/presentation/widgets/ayah_of_the_day.dart';
import 'package:rafeeq/features/settings/presentation/pages/settings_page.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';
import 'package:rafeeq/features/Quran/presentation/pages/full_surah_page.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final todayHijri = HijriDate.now();
  String get formattedHijri => todayHijri.toFormat('MMMM dd, yyyy h');
  final ScrollController scrollController = ScrollController();

  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: Durations.short4,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            return await Future.delayed(const Duration(seconds: 3));
          },
          child: CustomScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: false,
                floating: true,
                snap: false,
                title: GestureDetector(
                  onTap: scrollToTop,
                  child: Text('Rafiq', style: theme.appBarTheme.titleTextStyle),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      pushLeftPage(context, const SettingsPage());
                    },
                    icon: const Icon(CupertinoIcons.settings),
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Divider(
                    thickness: 1,
                    color: theme.dividerColor.withAlpha(20),
                  ),
                ),
              ),

              //GREETINGS
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: GreetingsRow(formattedHijri: formattedHijri),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              //AYAH OF THE DAY
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.0),
                  child: AyahOfTheDay(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // STICKY QUICKSURAHLINK
              SliverPersistentHeader(
                pinned: true,
                delegate: SimpleSliverHeaderDelegate(
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.0,
                      vertical: 8,
                    ),
                    child: QuickSurahLinks(),
                  ),
                  height: 80, // adjust to match QuickSurahLinks height
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                sliver: Consumer(
                  builder: (context, ref, _) {
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
                      data: (surahs) => SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final surah = surahs[index];
                          return SurahTile(surah: surah);
                        }, childCount: surahs.length),
                      ),
                    );
                  },
                ),
              ),
              // AllSurahsList
            ],
          ),
        ),
      ),
    );
  }
}

class SimpleSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  SimpleSliverHeaderDelegate({required this.child, required this.height});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor, // keeps bg consistent
      child: child,
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SimpleSliverHeaderDelegate oldDelegate) => false;
}

class GreetingsRow extends ConsumerWidget {
  const GreetingsRow({super.key, required this.formattedHijri});

  final String formattedHijri;

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context); 

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset('assets/images/salam_amber.png', height: 50, width: 100),

        Text(
          formattedHijri,
          style: theme.textTheme.bodySmall!.copyWith(
            color: AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}

class AllSurahsList extends ConsumerWidget {
  const AllSurahsList({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context, ref) {
    final surahAsync = ref.watch(surahsFutureProvider);

    return surahAsync.when(
      error: (error, stackTrace) => const Center(child: Text('Error ')),
      loading: () => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8,
        itemBuilder: (_, __) => const SurahTileShimmer(),
      ),
      data: (data) {
        final surahs = data;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: surahs.length,
          itemBuilder: (context, index) {
            final surah = surahs[index];

            return SlideFadeWrapper(
              index: index,
              child: SurahTile(surah: surah),
              // child: const SurahTileShimmer(),
            );
          },
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
    final isDark = ref.watch(isDarkProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.hardEdge,
        child: ListTile(
          splashColor: isDark
              ? AppColors.lightTextSecondary.withAlpha(50)
              : AppColors.darkSurface.withAlpha(50),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullSurahPage(surah: surah),
              ),
            );
          },
          leading: CircleAvatar(
            backgroundColor: AppColors.amber,
            child: Text(
              surah.id.toString(),
              style: const TextStyle(
                color: AppColors.darkBackground,
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.darkSurface),
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

class SurahLink extends ConsumerWidget {
  final Surah surah;

  const SurahLink({super.key, required this.surah});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Material(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: isDark
              ? AppColors.lightTextSecondary.withAlpha(50)
              : AppColors.darkSurface.withAlpha(50),
          highlightColor: Colors.transparent,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullSurahPage(surah: surah),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Center(
              child: Text(
                surah.nameTransliteration,
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextBody,
                ),
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
