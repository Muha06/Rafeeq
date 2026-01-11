import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rafeeq/features/Quran/domain/entities/surah.dart';

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
        const SizedBox(height: 12),

        //Surah title
        Text(
          surah.nameEnglish,
          style: theme.textTheme.titleLarge!.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 12),

        Text(
          '${surah.versesCount.toString()} Verses',
          style: theme.textTheme.bodySmall!,
        ),
        const SizedBox(height: 12),

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
