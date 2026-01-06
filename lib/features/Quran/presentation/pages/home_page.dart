import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri_date/hijri.dart';
import 'package:rafeeq/core/animations/navigation_animations.dart';
import 'package:rafeeq/core/themes/app_colors.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/fetch_surahs_provider.dart';
import 'package:rafeeq/features/settings/presentation/pages/settings_page.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';
import 'package:rafeeq/features/Quran/presentation/pages/full_surah_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final todayHijri = HijriDate.now();

  String get formattedHijri => todayHijri.toFormat('MMMM dd, yyyy h');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Rafiq', style: theme.appBarTheme.titleTextStyle),
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
          child: Divider(thickness: 1, color: theme.dividerColor.withAlpha(20)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: RefreshIndicator(
          onRefresh: () async {
            return await Future.delayed(const Duration(seconds: 3));
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              //greetings date row
              greetingRow(theme),
              const SizedBox(height: 16),

              //Daily ayah card
              AyahOfTheDay(theme: theme),
              const SizedBox(height: 16),

              //horizontal listview
              const QuickSurahLinks(),
              const SizedBox(height: 16),

              //all surahs
              AllSurahsList(theme: theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget greetingRow(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset('assets/images/salam_amber.png', height: 50, width: 100),

        Text(
          formattedHijri,
          style: theme.textTheme.bodySmall!.copyWith(
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

class AyahOfTheDay extends ConsumerWidget {
  const AyahOfTheDay({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context, ref) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      //contant padding
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //title
            Text(
              '==== Ayah of the day ====',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall!,
            ),
            const SizedBox(height: 16),

            //arabic
            Text(
              'يَـٰٓأَيُّهَا ٱلَّذِينَ ءَامَنُوا۟ ٱسْتَعِينُوا۟ بِٱلصَّبْرِ وَٱلصَّلَوٰةِ ۚ إِنَّ ٱللَّهَ مَعَ ٱلصَّـٰبِرِينَ',
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: theme.textTheme.bodyLarge!,
            ),
            const SizedBox(height: 8),

            //translation
            Text(
              "'O believers! Seek comfort in patience and prayer. Allah is truly with those who are patient.'",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium!.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              '2:128',
              style: theme.textTheme.bodySmall!.copyWith(
                color: const Color.fromRGBO(255, 195, 106, 1),
              ),
            ),
          ],
        ),
      ),
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
      loading: () => const Center(child: CircularProgressIndicator()),
      data: (data) {
        final surahs = data;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: surahs.length,
          itemBuilder: (context, index) {
            final surah = surahs[index];

            return SurahTile(
              index: surah.id.toString(),
              nameTransliteration: surah.nameTransliteration,
              englName: surah.nameEnglish,
              verses: surah.versesCount.toString(),
            );
          },
        );
      },
    );
  }
}

class SurahTile extends ConsumerWidget {
  final String index;
  final String nameTransliteration;
  final String englName;
  final String verses;

  const SurahTile({
    super.key,
    required this.index,
    required this.nameTransliteration,
    required this.englName,
    required this.verses,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.hardEdge,
        child: ListTile(
          splashColor: isDark
              ? AppColors.lightTextSecondary.withAlpha(50)
              : AppColors.darkSurface.withAlpha(50),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FullSurahPage()),
            );
          },
          leading: CircleAvatar(
            backgroundColor: AppColors.amber,
            child: Text(
              index,
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
          title: Text(nameTransliteration, style: theme.textTheme.titleMedium),
          subtitle: Text(englName, style: theme.textTheme.bodySmall),
          trailing: Text(verses, style: theme.textTheme.bodySmall),
        ),
      ),
    );
  }
}

class SurahLink extends ConsumerWidget {
  final String surah;

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
              MaterialPageRoute(builder: (context) => const FullSurahPage()),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Center(
              child: Text(
                surah,
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
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

class QuickSurahLinks extends StatelessWidget {
  const QuickSurahLinks({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final quickSurahs = ['Al Fatiha', 'Al Baqarah', 'Yaseen', 'Ar Rahman'];

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
