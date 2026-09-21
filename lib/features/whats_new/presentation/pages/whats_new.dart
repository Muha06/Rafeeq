import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/constants/app_assets.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/features/whats_new/data/whats_new_items.dart';
import 'package:rafeeq/features/whats_new/domain/entitites/whats_new_item.dart';
 
class WhatsNewPage extends ConsumerWidget {
  const WhatsNewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      height: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.tertiary.withValues(alpha: 0.16),
            theme.colorScheme.tertiary.withValues(alpha: 0.05),
            theme.colorScheme.surface.withValues(alpha: 0),
          ],
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      AppAssets.appIcon,
                      height: 72,
                      width: 72,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "What's new in Rafeeq ✨",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Here’s what we’ve improved for you.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 32),

                  ...whatsNewItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: WhatsNewItemTile(item: item),
                    ),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                AppNav.pop(context);
              },
              child: const Text('Continue'),
            ),
          ),
        ],
      ),
    );
  }
}

class WhatsNewItemTile extends StatelessWidget {
  const WhatsNewItemTile({super.key, required this.item});

  final WhatsNewItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(item.icon, size: 26, color: theme.colorScheme.primary),
        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title, style: theme.textTheme.labelLarge),
              const SizedBox(height: 4),
              Text(item.description, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
