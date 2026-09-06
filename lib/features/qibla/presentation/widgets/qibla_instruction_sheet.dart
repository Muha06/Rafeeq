import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/widgets/app_icon_container.dart';

class QiblaInstructionSheet extends StatelessWidget {
  const QiblaInstructionSheet({super.key});

  static Future<void> show(BuildContext context) {
    return AppSheets.showBottomSheet(
      context: context,
      useSafeArea: false,
      child: const QiblaInstructionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return DraggableScrollableSheet(
      maxChildSize: 1,
      initialChildSize: 1,
      expand: false,
      builder: (context, scrollController) => SafeArea(
        top: false,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                AppIconContainer(
                  backgroundColor: cs.surface,
                  size: 80,
                  borderRadius: 999,
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    size: 48,
                    color: Colors.amber,
                  ),
                ),

                const SizedBox(height: 24),

                // Title
                Text(
                  'How to use the Qibla compass',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),

                const SizedBox(height: 8),

                Text(
                  'Follow these steps for the most accurate direction.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 24),

                // Instructions
                const _InstructionTile(
                  icon: Icons.screen_lock_portrait_rounded,
                  title: 'Hold your phone flat',
                  subtitle: 'Keep your phone parallel to the ground.',
                ),

                const _InstructionTile(
                  icon: Icons.warning_amber_rounded,
                  title: 'Stay away from magnets',
                  subtitle:
                      'Keep away from electronic devices such as laptops, speakers and other magnetic objects.',
                ),

                const _InstructionTile(
                  icon: Icons.rotate_right_rounded,
                  title: 'Turn slowly',
                  subtitle:
                      'Rotate your phone until the Qibla indicator points toward the Kaaba.',
                ),

                const _InstructionTile(
                  icon: Icons.sync_rounded,
                  title: 'Calibrate if needed',
                  subtitle:
                      'If the compass seems inaccurate, move your phone in a figure-8 motion.',
                ),

                const SizedBox(height: 8),

                Text(
                  'Your Qibla direction is calculated using your saved location.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 48),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => AppNav.pop(context),
                    child: const Text('Got it'),
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

class _InstructionTile extends StatelessWidget {
  const _InstructionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Card(
          color: cs.surface,
          shadowColor: Colors.transparent,
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading: Icon(icon, size: 24, color: cs.onSurfaceVariant),
            subtitle: Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface,
                height: 1.3,
              ),
            ),
          ),
        )
        .animate(delay: 450.ms)
        .fadeIn(duration: 600.ms, curve: Curves.easeOut)
        .slideY(
          begin: 0.15,
          end: 0,
          duration: 600.ms,
          curve: Curves.easeOutCubic,
        );
  }
}
