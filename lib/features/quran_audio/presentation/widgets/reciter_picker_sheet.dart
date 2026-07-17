import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/features/quran_audio/presentation/providers/reciters_provider.dart';

class ReciterPickerSheet extends ConsumerWidget {
  const ReciterPickerSheet({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tTheme = theme.textTheme;

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
            maxChildSize: 0.92,
            builder: (context, scrollCtrl) {
              return Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Choose reciter',
                            style: tTheme.titleMedium,
                          ),
                        ),
                        IconButton(
                          onPressed: () => AppNav.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // List
                  Expanded(
                    child: ListView.separated(
                      controller: scrollCtrl,
                      itemCount: reciters.length,
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final r = reciters[i];
                        final isSelected = r.id == selected.id;

                        return Material(
                          color: cs.surface,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              ref.read(selectedReciterProvider.notifier).state =
                                  r;
                              AppNav.pop(context, r);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  // Leading "avatar"
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: cs.onSurfaceVariant.withAlpha(
                                          120,
                                        ),
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
                                        style: theme.textTheme.labelLarge!
                                            .copyWith(color: cs.onSurface),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Name
                                  Expanded(
                                    child: Text(
                                      r.name,
                                      maxLines: 2,
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
                                        horizontal: 6,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                        color: cs.primary.withAlpha(200),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            size: 16,
                                            color: cs.onPrimary,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Selected',
                                            style: theme.textTheme.labelSmall
                                                ?.copyWith(
                                                  color: cs.onPrimary,
                                                  // fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                        ],
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
      ),
    );
  }
}
