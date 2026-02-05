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

    final TextStyle keyWordStyle = Theme.of(context).textTheme.bodyMedium!
        .copyWith(
          fontWeight: FontWeight.w800,
          fontSize: 14,
          height: 1.3,
          color: isDark ? AppDarkColors.textPrimary : Colors.black,
        );

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
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isDark
                  ? AppDarkColors.darkSurface
                  : AppLightColors.lightSurface,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Friday Reminder', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 24),

                  Text.rich(
                    TextSpan(
                      text: "Friday is a gift from Allah ﷻ. Recite ",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium!.copyWith(height: 1, fontSize: 14),
                      children: [
                        TextSpan(text: 'Sūrah Al-Kahf,', style: keyWordStyle),
                        TextSpan(
                          text: " increase",
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(height: 1, fontSize: 14),
                        ),
                        TextSpan(text: ' dhikr', style: keyWordStyle),
                        TextSpan(
                          text: ' and take a moment for',
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(height: 1, fontSize: 14),
                        ),
                        TextSpan(text: ' duʿā.', style: keyWordStyle),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () =>
                            _showFridayVirtuesSheet(context, isDark),
                        icon: const Icon(Icons.info_outline, size: 16),
                        label: Text(
                          'View Friday virtues',
                          style: theme.textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppDarkColors.textPrimary
                                : AppLightColors.textPrimary,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const FullSurahPage(surah: surahAlKahf),
                            ),
                          );
                        },
                        child: Text(
                          'Tap to read >',
                          style: theme.textTheme.bodySmall!.copyWith(
                            color: isDark ? AppLightColors.amber : Colors.black,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ],
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
    );
  }
}

void _showFridayVirtuesSheet(BuildContext context, bool isDark) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: false,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.35,
        maxChildSize: 0.9,
        builder: (context, controller) {
          return Container(
            decoration: BoxDecoration(
              color: isDark ? AppDarkColors.bottomSheet : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
            ),
            child: ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black12,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Friday Virtues',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  'A few Sunnah reminders to make your Jumu‘ah count.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),

                const _VirtueTile(
                  title: 'Recite Sūrah Al-Kahf',
                  body:
                      'A beautiful Friday habit. If you can’t finish, start and continue — consistency wins.',
                  icon: Icons.menu_book_outlined,
                ),
                const _VirtueTile(
                  title: 'Send ṣalawāt',
                  body:
                      'Increase blessings by sending prayers upon the Prophet ﷺ throughout the day.',
                  icon: Icons.favorite_border,
                ),

                const _VirtueTile(
                  title: 'Ghusl + early Jumu‘ah',
                  body:
                      'Prepare for Jumu‘ah like it matters — because it does.',
                  icon: Icons.water_drop_outlined,
                ),
                const _VirtueTile(
                  title: 'Make duʿā',
                  body:
                      'Keep a short duʿā list. Ask for guidance, forgiveness, and barakah in your time.',
                  icon: Icons.volunteer_activism_outlined,
                ),
                const SizedBox(height: 14),
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Got it'),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class _VirtueTile extends ConsumerWidget {
  const _VirtueTile({
    required this.title,
    required this.body,
    required this.icon,
  });

  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark
              ? AppDarkColors.onDarkSurface
              : AppLightColors.onAmberSoft,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(body, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
