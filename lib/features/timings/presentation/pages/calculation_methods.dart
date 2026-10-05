import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/timings/domain/entities/prayer_calculation_method.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/calculation_methods_provider.dart';

class PrayerCalculationMethodsPage extends ConsumerWidget {
  const PrayerCalculationMethodsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final methods = ref.watch(calculationMethodsProvider);
    final selectedMethod = ref.watch(selectedCalculationMethodProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Calculation Method')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text(
            'Prayer time calculation',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'Choose the calculation method used to determine your prayer times.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: 20),

          ...methods.map((method) {
            final isSelected = method.id == selectedMethod.id;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: PrayerCalculationMethodTile(
                method: method,
                isSelected: isSelected,
                onTap: () {
                  ref
                      .read(selectedCalculationMethodProvider.notifier)
                      .select(method);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

class PrayerCalculationMethodTile extends StatelessWidget {
  const PrayerCalculationMethodTile({
    super.key,
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  final PrayerCalculationMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 150.ms,
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primaryContainer
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(
                method.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: theme.listTileTheme.titleTextStyle?.copyWith(
                  fontSize: 16,
                ),
              ),
            ),

            if (method.id == 3) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Recomended",
                  style: tt.titleSmall?.copyWith(color: colorScheme.tertiary),
                ),
              ),
            ],

            if (isSelected) ...[
              const SizedBox(width: 8),

              Icon(Icons.check_circle_rounded, color: colorScheme.primary),
            ],
          ],
        ),
      ),
    );
  }
}
