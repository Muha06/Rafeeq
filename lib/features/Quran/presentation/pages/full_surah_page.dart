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
      ),

      body: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: widget.ayahs.length + 1, // +1 for SurahDetails
          itemBuilder: (context, index) {
            if (index == 0) {
              // First item = Surah header
              return SurahDetails(surah: widget.surah);
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
  const SurahDetails({super.key, required this.surah});
  final Surah surah;
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
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
