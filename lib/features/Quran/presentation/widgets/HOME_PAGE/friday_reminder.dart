import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/features/Quran/domain/entities/surah.dart';
import 'package:rafeeq/features/Quran/presentation/pages/surah_page.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class FridayReminder extends ConsumerStatefulWidget {
  const FridayReminder({super.key});

  @override
  ConsumerState<FridayReminder> createState() => _FridayReminderState();
}

class _FridayReminderState extends ConsumerState<FridayReminder> {
  bool isFriday = DateTime.now().weekday == DateTime.friday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    if (isFriday) return const SizedBox.shrink(); // hide if not Friday

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
                borderRadius: BorderRadius.circular(12),
                color: isDark
                    ? AppDarkColors.darkSurface
                    : AppLightColors.lightSurface,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("It's Friday!", style: theme.textTheme.bodySmall),
                    const SizedBox(height: 10),

                    Text.rich(
                      TextSpan(
                        text: 'Don’t forget to read ',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          height: 1,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: 'Surah Al-Kahf',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  height: 1.1,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                          ),
                          const TextSpan(text: ' today to earn blessings!'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    Text(
                      'Tap to read',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: isDark ? AppLightColors.amber : Colors.black,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
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
                'assets/images/mosque.png',
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
