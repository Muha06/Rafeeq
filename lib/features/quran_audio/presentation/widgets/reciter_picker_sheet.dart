import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/constants/spacing/app_spacing.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/features/quran_audio/presentation/providers/reciters_provider.dart';

class ReciterPickerSheet extends ConsumerWidget {
  const ReciterPickerSheet({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tTheme = theme.textTheme;

    const horizontalPadding = AppSpacing.lg;

    return SafeArea(
      top: false,
      bottom: true,
      child: Consumer(
        builder: (context, ref, _) {
          final reciters = ref.watch(quranRecitersProvider);
          final selected = ref.watch(selectedReciterProvider);

          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.72,
            minChildSize: 0.45,
            maxChildSize: 1,
            builder: (context, scrollCtrl) {
              return Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 16,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Reciter Voice', style: tTheme.titleMedium),

                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Choose your preferred Quran reciter',
                                style: tTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => AppNav.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // List
                  Expanded(
                    child: ListView.separated(
                      controller: scrollCtrl,
                      itemCount: reciters.length,
                      padding: const EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.xl),
                      itemBuilder: (context, i) {
                        final r = reciters[i];
                        final isSelected = r.id == selected.id;

                        return GestureDetector(
                          onTap: () {
                            ref.read(selectedReciterProvider.notifier).state =
                                r;
                            AppNav.pop(context, r);
                          },
                          child: Row(
                            children: [
                              // Leading "avatar"
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: cs.onSurfaceVariant.withAlpha(120),
                                  ),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                width: 36,
                                height: 36,
                                child: Center(
                                  child: Text(
                                    r.name.trim().isNotEmpty
                                        ? r.name.trim()[0].toUpperCase()
                                        : '?',
                                    style: theme.textTheme.labelLarge!.copyWith(
                                      color: isSelected
                                          ? cs.primary
                                          : cs.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Name
                              Expanded(
                                child: Text(
                                  r.name,
                                  maxLines: 2,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? cs.primary
                                        : cs.onSurface,
                                  ),
                                ),
                              ),

                              // Selected chip + check
                              if (isSelected) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(999),
                                    color: cs.primary.withAlpha(200),
                                  ),
                                  child: Icon(
                                    Icons.check_circle,
                                    size: 16,
                                    color: cs.onPrimary,
                                  ),
                                ),
                              ] else ...[
                                Icon(
                                  Icons.chevron_right,
                                  color: theme.iconTheme.color?.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                              ],
                            ],
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
      ),
    );
  }
}
