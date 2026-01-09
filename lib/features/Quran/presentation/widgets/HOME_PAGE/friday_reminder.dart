import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/app_colors.dart';
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

    if (!isFriday) return const SizedBox.shrink(); // hide if not Friday

    const surahAlKahf = Surah(
      id: 18,
      nameArabic: 'الكهف',
      nameEnglish: 'Al-Kahf',
      nameTransliteration: 'Al Kahf',
      versesCount: 110,
      isMeccan: false,
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FullSurahPage(surah: surahAlKahf),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Icon(
                  Icons.book,
                  color: isDark
                      ? AppColors.lightBackground
                      : AppColors.lightTextBody,
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("It's Friday!", style: theme.textTheme.bodySmall),
                      const SizedBox(height: 12),

                      Text.rich(
                        TextSpan(
                          text: 'Don’t forget to read ',
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(
                                color: isDark ? Colors.white70 : Colors.black87,
                                height: 1.3,
                              ),
                          children: [
                            TextSpan(
                              text: 'Surah Al-Kahf',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white70 : Colors.black,
                              ),
                            ),
                            const TextSpan(text: ' today to earn blessings!'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      Text(
                        'Tap to read',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: isDark ? AppColors.amber : Colors.black,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                    ],
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
