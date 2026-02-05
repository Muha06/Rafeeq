import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/ayah_share_cotroller_provider.dart';
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

    final cardBg = isDark
        ? AppDarkColors.onDarkSurface
        : AppLightColors.onLightSurface;

    final label = switch (reflection.type) {
      ReminderType.quran => 'Qur’an',
      ReminderType.hadith => 'Hadith',
      ReminderType.narration => 'Narration',
    };

    return DraggableScrollableSheet(
      initialChildSize: 0.62,
      minChildSize: 0.45,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          // padding: EdgeInsets.only(bottom: bottomInset),
          decoration: BoxDecoration(
            color: theme.bottomSheetTheme.backgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Handle
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: (isDark ? Colors.white : Colors.black).withAlpha(40),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 12),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(child: Text('Reflection', style: tt.titleMedium)),
                    TypeChip(label: label, isDark: isDark),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  children: [
                    _SheetCard(
                      isDark: isDark,
                      background: cardBg,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Topic', style: tt.labelSmall),
                          const SizedBox(height: 8),
                          Text(reflection.topic, style: tt.titleLarge),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    _SheetCard(
                      isDark: isDark,
                      background: cardBg,
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
                        background: cardBg,
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
                      background: cardBg,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Source', style: tt.labelSmall),
                                const SizedBox(height: 8),
                                Text(
                                  reflection.sourceLabel,
                                  style: tt.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.bookmark_outline,
                            size: 20,
                            color: (isDark ? Colors.white : Colors.black)
                                .withAlpha(140),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Optional actions row (keep minimal)
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

                              final text = shareController
                                  .buildRamadanReflectionText(
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
            ],
          ),
        );
      },
    );
  }
}

class _SheetCard extends StatelessWidget {
  const _SheetCard({
    required this.child,
    required this.isDark,
    required this.background,
  });

  final Widget child;
  final bool isDark;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
