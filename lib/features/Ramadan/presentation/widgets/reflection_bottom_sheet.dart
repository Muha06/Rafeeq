import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/ayah_share_cotroller_provider.dart';
import 'package:rafeeq/features/Ramadan/domain/ramadan_reflection.dart';
import 'package:rafeeq/features/Ramadan/presentation/widgets/ramadan_card.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class RamadanReflectionSheet extends ConsumerWidget {
  const RamadanReflectionSheet({super.key, required this.reflection});

  final RamadanReflection reflection;

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final isDark = ref.watch(isDarkProvider);

    final label = switch (reflection.type) {
      ReminderType.quran => 'Qur’an',
      ReminderType.hadith => 'Hadith',
      ReminderType.narration => 'Narration',
    };

    return Container(
      decoration: BoxDecoration(
        color: theme.bottomSheetTheme.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Expanded(child: Text('Reflection', style: tt.titleMedium)),
                TypeChip(label: label),
              ],
            ),

            const SizedBox(height: 14),

            _SheetCard(
              isDark: isDark,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Topic', style: tt.labelSmall),
                    const SizedBox(height: 8),
                    Text(reflection.topic, style: tt.titleLarge),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            _SheetCard(
              isDark: isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Reminder', style: tt.labelSmall),
                  const SizedBox(height: 10),
                  Text(
                    reflection.mainText,
                    style: tt.bodyMedium?.copyWith(height: 1.6),
                  ),
                ],
              ),
            ),

            if (reflection.lesson != null &&
                reflection.lesson!.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              _SheetCard(
                isDark: isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Benefit', style: tt.labelSmall),
                    const SizedBox(height: 10),
                    Text(
                      reflection.lesson!,
                      style: tt.bodyMedium?.copyWith(height: 1.6),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 12),

            _SheetCard(
              isDark: isDark,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Source', style: tt.labelSmall),
                        const SizedBox(height: 8),
                        Text(reflection.sourceLabel, style: tt.bodySmall),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.bookmark_outline,
                    size: 20,
                    color: (isDark ? Colors.white : Colors.black).withAlpha(
                      140,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Optional actions row
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final shareController = ref.read(
                        ayahShareControllerProvider,
                      );

                      final text = shareController.buildRamadanReflectionText(
                        reflection: reflection,
                        includeLesson: true,
                      );

                      await shareController.share(
                        context: context,
                        text: text,
                        subject: 'Rafeeq • Ramadan Reflection',
                      );
                    },
                    child: const Text('Share'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetCard extends StatelessWidget {
  const _SheetCard({required this.child, required this.isDark});

  final Widget child;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
