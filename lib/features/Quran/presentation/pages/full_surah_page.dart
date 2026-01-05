import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/app_colors.dart';
import 'package:rafeeq/features/Quran/domain/entities/ayah.dart';
import 'package:rafeeq/features/Quran/domain/entities/surah.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class FullSurahPage extends ConsumerStatefulWidget {
  const FullSurahPage({super.key, required this.surah, required this.ayahs});
  final List<Ayah> ayahs;
  final Surah surah;

  @override
  ConsumerState<FullSurahPage> createState() => _FullSurahPageState();
}

class _FullSurahPageState extends ConsumerState<FullSurahPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.surah.nameEnglish,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: isDark ? AppColors.textPrimary : AppColors.darkSurface,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
            const SizedBox(height: 4),

            Text(widget.surah.nameArabic, style: theme.textTheme.bodySmall),
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
                  return Container(
                    padding: const EdgeInsets.all(16),
                    height: 250, // or whatever height you want
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Modify Surahs',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text('Options for adding/editing content go here.'),
                      ],
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.tune, color: isDark ? Colors.white : Colors.black),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: widget.ayahs.length + 1, // +1 for SurahDetails
          itemBuilder: (context, index) {
            if (index == 0) {
              // First item = Surah header
              return SurahDetails(surah: widget.surah, isDark: isDark);
            }

            // Rest = Ayah tiles
            final ayah = widget.ayahs[index - 1];
            final isLast = index == widget.ayahs.length;

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

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
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

          const SizedBox(height: 16),

          // arabic text (right)
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              ayah.textArabic,
              textDirection: TextDirection.rtl,
              style: theme.textTheme.bodyLarge!.copyWith(
                height: 1.8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // english translation
          Text(
            ayah.textEnglish,
            textAlign: TextAlign.left,
            style: theme.textTheme.bodyLarge!.copyWith(
              fontFamily: 'Roboto',
              fontWeight: isDark ? FontWeight.w300 : FontWeight.w400,
              letterSpacing: 2,
              height: 1.7,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
