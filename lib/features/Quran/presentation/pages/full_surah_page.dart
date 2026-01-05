import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/app_colors.dart';
import 'package:rafeeq/features/Quran/domain/entities/ayah.dart';
import 'package:rafeeq/features/Quran/domain/entities/surah.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/surah_preferences_provider.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class FullSurahPage extends ConsumerWidget {
  const FullSurahPage({super.key, required this.surah, required this.ayahs});
  final List<Ayah> ayahs;
  final Surah surah;

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              surah.nameEnglish,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: isDark ? AppColors.textPrimary : AppColors.darkSurface,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
            const SizedBox(height: 4),

            Text(surah.nameArabic, style: theme.textTheme.bodySmall),
          ],
        ),
        toolbarHeight: 58,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: theme.dividerColor),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) {
                  return const SurahSettingsSheet();
                },
              );
            },
            icon: const Icon(Icons.tune),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: ayahs.length + 1, // +1 for SurahDetails
          itemBuilder: (context, index) {
            if (index == 0) {
              // First item = Surah header
              return SurahDetails(surah: surah, isDark: isDark);
            }

            // Rest = Ayah tiles
            final ayah = ayahs[index - 1];
            final isLast = index == ayahs.length;

            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 16.0 : 0),
              child: AyahTile(ayah: ayah),
            );
          },
        ),
      ),
    );
  }
}

class SurahSettingsSheet extends StatelessWidget {
  const SurahSettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer(
      builder: (context, ref, _) {
        final showTranslation = ref.watch(showTranslationProvider);
        final arabicFontSize = ref.watch(arabicFontSizeProvider);
        final translationFontSize = ref.watch(translationFontSizeProvider);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  height: 6,
                  width: 48,
                  decoration: BoxDecoration(
                    color: AppColors.lightTextSecondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: Text(
                  'Full Surah Settings',
                  style: theme.textTheme.titleMedium,
                ),
              ),

              Divider(color: theme.dividerColor),
              const SizedBox(height: 16),

              // Show/hide translation
              SwitchListTile(
                value: showTranslation,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Show Translation',
                  style: theme.textTheme.bodyLarge!.copyWith(
                    // color: isDark ? Colors.white : Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                onChanged: (value) {
                  ref.read(showTranslationProvider.notifier).state = value;
                },
              ),

              const SizedBox(height: 8),

              // Font size slider (Arabic)
              Text(
                'Arabic Font Size: ${arabicFontSize.toInt()}',
                style: theme.textTheme.bodySmall!.copyWith(fontSize: 16),
              ),
              Slider(
                min: 16,
                max: 36,
                value: arabicFontSize,
                onChanged: (value) {
                  ref.read(arabicFontSizeProvider.notifier).state = value;
                },
              ),

              // Font size slider (Translation)
              if (showTranslation) ...[
                Text('Translation Font Size: ${translationFontSize.toInt()}'),
                Slider(
                  min: 12,
                  max: 28,
                  value: translationFontSize,
                  onChanged: (value) {
                    ref.read(translationFontSizeProvider.notifier).state =
                        value;
                  },
                ),
              ],

              //divider
              Divider(color: theme.dividerColor),
              const SizedBox(height: 0),

              //cancel btn
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Close',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SurahDetails extends StatelessWidget {
  const SurahDetails({super.key, required this.surah, required this.isDark});
  final Surah surah;
  final bool isDark;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
          clipBehavior: Clip.hardEdge,
          child: Image.asset(
            'assets/images/kaaba.jpeg',
            height: 80,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),

        //Surah title
        Text(
          surah.nameEnglish,
          style: theme.textTheme.titleLarge!.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 4),

        Text(
          'The opener',
          style: theme.textTheme.bodyMedium!.copyWith(fontSize: 14, height: 1),
        ),
        const SizedBox(height: 22),

        Image.asset(
          isDark
              ? 'assets/images/bismillah_dark.png'
              : 'assets/images/bismillah_1.png',
          height: 48,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class AyahTile extends ConsumerWidget {
  final Ayah ayah;

  const AyahTile({super.key, required this.ayah});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);
    final showTranslation = ref.watch(showTranslationProvider);
    final arabicFontSize = ref.watch(arabicFontSizeProvider);
    final translationFontSize = ref.watch(translationFontSizeProvider);

    return AnimatedSize(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // verse number (top-left)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                ayah.ayahNumber.toString(),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.amber,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // arabic text (right)
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                ayah.textArabic,
                textDirection: TextDirection.rtl,
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontSize: arabicFontSize,
                  height: 2.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Translation
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),

              child: showTranslation
                  ? Text(
                      key: const ValueKey('translation'),
                      ayah.textEnglish,
                      textAlign: TextAlign.left,
                      style: theme.textTheme.bodyLarge!.copyWith(
                        fontFamily: 'Roboto',
                        fontSize: translationFontSize,
                        fontWeight: isDark ? FontWeight.w300 : FontWeight.w400,
                        letterSpacing: 2,
                        height: 1.7,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    )
                  : const SizedBox.shrink(key: ValueKey('hide')),
            ),
            if (showTranslation) const SizedBox(height: 20),

            Divider(color: theme.dividerColor),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_add_outlined, size: 22),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share, size: 22),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
