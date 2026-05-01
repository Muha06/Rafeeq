import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/presentation/pages/surah_page.dart';
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
    final cs = theme.colorScheme;

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
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Friday Reminder', style: theme.textTheme.labelLarge),
                  const SizedBox(height: 8),

                  const Text(
                    "Friday is a gift from Allah ﷻ. Recite Sūrah Al-Kahf, increase dhikr and take a moment for duʿā.",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () =>
                            _showFridayVirtuesSheet(context, isDark),
                        icon: const Icon(Icons.info_outline, size: 16),
                        label: Text(
                          'View Friday virtues',
                          style: theme.textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          AppNav.push(
                            context,
                            const FullSurahPage(surah: surahAlKahf),
                          );
                        },
                        child: Text(
                          'Tap to read >',
                          style: theme.textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cs.primary,
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
              'assets/images/adhkar/mosque.png',
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
  final iconStyle = PhosphorIconsStyle.light;

  AppSheets.showBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    child: SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
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

          _VirtueTile(
            title: 'Recite Sūrah Al-Kahf',
            body:
                'A beautiful Friday habit. If you can’t finish, start and continue — consistency wins.',
            icon: PhosphorIcons.bookOpen(iconStyle),
          ),
          _VirtueTile(
            title: 'Send ṣalawāt',
            body:
                'Increase blessings by sending prayers upon the Prophet ﷺ throughout the day.',
            icon: PhosphorIcons.heart(iconStyle),
          ),

          _VirtueTile(
            title: 'Ghusl + early Jumu‘ah',
            body: 'Prepare for Jumu‘ah like it matters — because it does.',
            icon: PhosphorIcons.drop(iconStyle),
          ),
          _VirtueTile(
            title: 'Make duʿā',
            body:
                'Keep a short duʿā list. Ask for guidance, forgiveness, and barakah in your time.',
            icon: PhosphorIcons.handsPraying(iconStyle),
          ),
          const SizedBox(height: 14),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    ),
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
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: theme.colorScheme.surfaceContainerHighest,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: cs.onSurface),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.labelLarge),
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
