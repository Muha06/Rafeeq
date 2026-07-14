import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';

void showFridayVirtuesSheet(BuildContext context) {
  AppSheets.showBottomSheet(
    context: context,
    showDragHandle: true,
    child: SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.9,
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

          const _VirtueTile(
            title: 'Recite Sūrah Al-Kahf',
            body:
                'A beautiful Friday habit. If you can’t finish, start and continue — consistency wins.',
            icon: PhosphorIcons.bookOpen,
          ),
          const _VirtueTile(
            title: 'Send ṣalawāt',
            body:
                'Increase blessings by sending prayers upon the Prophet ﷺ throughout the day.',
            icon: PhosphorIcons.heart,
          ),

          const _VirtueTile(
            title: 'Ghusl + early Jumu‘ah',
            body: 'Prepare for Jumu‘ah like it matters — because it does.',
            icon: PhosphorIcons.drop,
          ),
          const _VirtueTile(
            title: 'Make duʿā',
            body:
                'Keep a short duʿā list. Ask for guidance, forgiveness, and barakah in your time.',
            icon: PhosphorIcons.handsPraying,
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
