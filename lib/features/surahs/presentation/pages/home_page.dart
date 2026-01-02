import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri_date/hijri.dart';
import 'package:rafeeq/core/animations/navigation_animations.dart';
import 'package:rafeeq/core/themes/app_colors.dart';
import 'package:rafeeq/features/settings/presentation/pages/settings_page.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';
import 'package:rafeeq/features/surahs/presentation/pages/full_surah_page.dart';

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

              //quick links
              Text('Quick links', style: theme.textTheme.bodySmall),
              const SizedBox(height: 16),

              //horizontal listview
              quickSurahLinks(context),
              const SizedBox(height: 16),

              //all surahs
              AllSurahsList(theme: theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget quickSurahLinks(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildSurahLink(surah: 'Surah Al-Fatiha', context: context),
          _buildSurahLink(surah: 'Surah Mulk', context: context),
          _buildSurahLink(surah: 'Surah Kahf', context: context),
          _buildSurahLink(surah: 'Surah Ar-Rahman', context: context),
        ],
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

class AllSurahsList extends StatelessWidget {
  const AllSurahsList({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('All Surahs', style: theme.textTheme.bodySmall!),
        const SizedBox(height: 16),

        _buildSurahTile(
          context: context,
          index: '1',
          surahName: 'Al Fatiha',
          englName: 'The Opener',
          verses: '7',
        ),
        _buildSurahTile(
          context: context,
          index: '2',
          surahName: 'Al Baqarah',
          englName: 'The Cow',
          verses: '286',
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
    final isDark = ref.watch(isDarkProvider);

    return Card(
      shadowColor: isDark ? Colors.white38 : Colors.grey[400],
      child: Container(
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
      ),
    );
  }
}

Widget _buildSurahTile({
  required BuildContext context,
  required String index,
  required String surahName,
  required String verses,
  required String englName,
}) {
  final theme = Theme.of(context);
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Material(
      color: theme.cardColor, //list tile color
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.hardEdge,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          splashColor: isDark
              ? AppColors.lightTextSecondary.withAlpha(50)
              : AppColors.darkSurface.withAlpha(50),
          onTap: () {
            //navigate to full surah page
            pushZoomPage(context, FullSurahPage(surahName: surahName));
          },
          leading: CircleAvatar(
            backgroundColor: AppColors.amber,
            child: Text(
              index,
              style: const TextStyle(color: AppColors.darkBackground),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          title: Text(surahName, style: theme.textTheme.titleMedium),
          subtitle: Text(englName, style: theme.textTheme.bodySmall),
          trailing: Text(verses, style: theme.textTheme.bodySmall),
        ),
      ),
    ),
  );
}

Widget _buildSurahLink({required String surah, required BuildContext context}) {
  final theme = Theme.of(context);
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Padding(
    padding: const EdgeInsets.only(right: 8.0),
    child: Material(
      color: theme.cardColor, //container color
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: isDark
            ? AppColors.lightTextSecondary.withAlpha(50)
            : AppColors.darkSurface.withAlpha(50),
        highlightColor: Colors.transparent,
        onTap: () {
          //navigate to full surah page
          pushZoomPage(context, FullSurahPage(surahName: surah));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: theme.cardColor,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Center(
            child: Text(
              surah,
              style: theme.textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.lightTextBody,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
