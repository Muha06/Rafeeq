import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/widgets/app_drag_handle.dart';
import 'package:rafeeq/core/widgets/app_icon_container.dart';

void showFridayVirtuesSheet(BuildContext context) {
  AppSheets.showBottomSheet(
    context: context,
    isScrollControlled: true,
    child: SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.9,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          const AppDragHandle(),

          const SizedBox(height: 16),

          Text(
            'Friday Virtues',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          const SizedBox(height: 12),

          Text(
            'Maximize the blessings of Jumu\'ah with a few Sunnah practices/',
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

          ElevatedButton(
            onPressed: () => AppNav.pop(context),
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
          color: cs.surface,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppIconContainer(
              backgroundColor: cs.surfaceContainerHigh,
              borderRadius: 8,
              size: 24,
              child: Icon(icon, color: cs.onSurface, size: 14),
            ),

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
