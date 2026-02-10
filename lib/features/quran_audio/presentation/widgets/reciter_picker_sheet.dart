import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/app_text_style.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/features/quran_audio/presentation/providers/reciters_provider.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class ReciterPickerSheet extends ConsumerWidget {
  const ReciterPickerSheet({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    return Consumer(
      builder: (context, ref, _) {
        final reciters = ref.watch(quranRecitersProvider);
        final selected = ref.watch(selectedReciterProvider);

        final searchCtrl = TextEditingController();
        final query = ValueNotifier<String>('');

        return ValueListenableBuilder<String>(
          valueListenable: query,
          builder: (context, q, _) {
            final filtered = reciters
                .where((r) => r.name.toLowerCase().contains(q.toLowerCase()))
                .toList();

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.72,
              minChildSize: 0.45,
              maxChildSize: 0.92,
              builder: (context, scrollCtrl) {
                return Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Choose reciter',
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),

                    // Search
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: TextField(
                        style: AppTextStyles.label.copyWith(
                          fontSize: 19,
                          height: 1.7,
                        ),
                        controller: searchCtrl,
                        onChanged: (v) => query.value = v.trim(),
                        decoration: const InputDecoration(
                          hintText: 'Search reciters',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // List
                    Expanded(
                      child: ListView.separated(
                        controller: scrollCtrl,
                        itemCount: filtered.length,
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final r = filtered[i];
                          final isSelected = r.id == selected.id;

                          final cardLightColor = isSelected
                              ? AppLightColors.onLightSurface
                              : AppLightColors.lightSurface;

                          final cardDarkColor = isSelected
                              ? AppDarkColors.onDarkSurface
                              : AppDarkColors.darkSurface;

                          return Material(
                            color: isDark ? cardDarkColor : cardLightColor,
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                ref
                                        .read(selectedReciterProvider.notifier)
                                        .state =
                                    r;
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    // Leading "avatar"
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: isDark
                                          ? AppDarkColors.iconDisabled
                                          : AppLightColors.onLightSurface,
                                      child: Text(
                                        r.name.trim().isNotEmpty
                                            ? r.name.trim()[0].toUpperCase()
                                            : '?',
                                        style: theme.textTheme.labelLarge,
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Name
                                    Expanded(
                                      child: Text(
                                        r.name,
                                        style: theme.textTheme.labelLarge
                                            ?.copyWith(
                                              fontWeight: isSelected
                                                  ? FontWeight.w700
                                                  : FontWeight.w500,
                                            ),
                                      ),
                                    ),

                                    // Selected chip + check
                                    if (isSelected) ...[
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? AppDarkColors.iconDisabled
                                              : AppLightColors.primary,
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.check_circle,
                                              size: 18,
                                              color: AppDarkColors.amber,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              'Selected',
                                              style: theme.textTheme.labelMedium
                                                  ?.copyWith(
                                                    color: AppDarkColors.amber,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ] else ...[
                                      Icon(
                                        Icons.chevron_right,
                                        color: theme.iconTheme.color
                                            ?.withOpacity(0.6),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
