import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
            theme.colorScheme.tertiary.withValues(alpha: 0.12),
            theme.colorScheme.tertiary.withValues(alpha: 0.05),
            theme.colorScheme.surface.withValues(alpha: 0),
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
                      )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .scale(
                        begin: const Offset(0.85, 0.85),
                        end: const Offset(1, 1),
                        duration: 500.ms,
                        curve: Curves.easeOutBack,
                      ),

                  const SizedBox(height: 12),

                  Text(
                        "What's new in Rafeeq ✨",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall,
                      )
                      .animate(delay: 150.ms)
                      .fadeIn(duration: 450.ms)
                      .slideY(begin: 0.15, end: 0),

                  const SizedBox(height: 8),

                  Text(
                        'Here’s what we’ve improved for you.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      )
                      .animate(delay: 250.ms)
                      .fadeIn(duration: 450.ms)
                      .slideY(begin: 0.12, end: 0),

                  const SizedBox(height: 32),

                  ...whatsNewItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: WhatsNewItemTile(item: item)
                          .animate(delay: (350 + index * 120).ms)
                          .fadeIn(duration: 450.ms)
                          .slideX(
                            begin: 0.08,
                            end: 0,
                            duration: 450.ms,
                            curve: Curves.easeOutCubic,
                          ),
                    );
                  }),

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
              )
              .animate(delay: (350 + whatsNewItems.length * 120).ms)
              .fadeIn(duration: 450.ms)
              .slideY(begin: 0.2, end: 0),
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
              Text(item.title, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 4),
              Text(item.description, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
