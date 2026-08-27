import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/constants/spacing/app_spacing.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/widgets/app_drag_handle.dart';
import 'package:rafeeq/core/widgets/app_icon_container.dart';
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
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    const AppDragHandle(),

                    const SizedBox(height: 12),

                    // Header
                    Row(
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

                    const SizedBox(height: AppSpacing.lg),

                    // List
                    Expanded(
                      child: ListView.builder(
                        controller: scrollCtrl,
                        itemCount: reciters.length,
                        itemBuilder: (context, i) {
                          final r = reciters[i];
                          final isSelected = r.id == selected.id;

                          return ListTile(
                            onTap: () {
                              ref.read(selectedReciterProvider.notifier).state =
                                  r;
                              AppNav.pop(context, r);
                            },
                            leading: AppIconContainer(
                              backgroundColor: cs.secondaryContainer,
                              borderRadius: 999,
                              size: 28,
                              child: Center(
                                child: Text(
                                  r.name.trim().isNotEmpty
                                      ? r.name.trim()[0].toUpperCase()
                                      : '?',
                                  style: theme.textTheme.labelLarge!.copyWith(
                                    color: cs.onSurface,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              r.name,
                              maxLines: 2,
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: isSelected ? FontWeight.w600 : null,
                                color: isSelected ? cs.primary : cs.onSurface,
                              ),
                            ),
                            trailing: isSelected
                                ? Icon(
                                    Icons.check_circle,
                                    size: 24,
                                    color: cs.onSurface,
                                  )
                                : null,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
