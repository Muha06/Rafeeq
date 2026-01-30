import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/features/Quran/domain/entities/surah.dart';
import 'package:rafeeq/features/Quran/presentation/pages/surah_page.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class FridayReminderCard extends ConsumerStatefulWidget {
  const FridayReminderCard({super.key});

  @override
  ConsumerState<FridayReminderCard> createState() => _FridayReminderCardState();
}

class _FridayReminderCardState extends ConsumerState<FridayReminderCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    const surahAlKahf = Surah(
      id: 18,
      nameArabic: 'الكهف',
      nameEnglish: 'Al-Kahf',
      nameTransliteration: 'Al Kahf',
      versesCount: 110,
      isMeccan: false,
    );

    return Padding(
      padding: const EdgeInsets.only(left: 14.0, right: 14, top: 4, bottom: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FullSurahPage(surah: surahAlKahf),
            ),
          );
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isDark
                    ? AppDarkColors.darkSurface
                    : AppLightColors.amberSoft,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Friday Reminder', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 10),

                    Text.rich(
                      TextSpan(
                        text: 'Dont forget to recite ',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          height: 1,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: 'Surah Al-Kahf ',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  height: 1.1,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                          ),
                          const TextSpan(text: 'to earn blessings.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Tap to read >',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: isDark ? AppLightColors.amber : Colors.black,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Image.asset(
                'assets/images/adhkar/mosque_amber.png',
                height: 30,
                width: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
