import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/calendar/presentation/providers/hijri_date_providers.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(hijriDateProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hijriState = ref.watch(hijriDateProvider);

    String offsetLabel(int v) {
      if (v == 0) return 'Offset: 0 (accurate)';
      final sign = v > 0 ? '+' : '';
      return 'Offset: $sign$v day${v.abs() == 1 ? '' : 's'}';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => _openOffsetSheet(context, ref),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hijriState.formatted,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              offsetLabel(hijriState.offsetDays),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),

            // Big obvious button too (not only the top icon)
            FilledButton.icon(
              onPressed: () => _openOffsetSheet(context, ref),
              icon: const Icon(Icons.calendar_month),
              label: const Text('Adjust Hijri Offset'),
            ),
          ],
        ),
      ),
    );
  }

  void _openOffsetSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: false,
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(hijriDateProvider);
            final notifier = ref.read(hijriDateProvider.notifier);

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Hijri Offset',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Use this if your local moon sighting is ahead/behind.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Preview
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Text(
                          state.formatted,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Offset: ${state.offsetDays}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Slider -2..+2
                  Row(
                    children: [
                      IconButton(
                        onPressed: state.offsetDays <= -2
                            ? null
                            : () => notifier.setOffset(state.offsetDays - 1),
                        icon: const Icon(Icons.remove),
                      ),
                      Expanded(
                        child: Slider(
                          value: state.offsetDays.toDouble(),
                          min: -2,
                          max: 2,
                          divisions: 4,
                          label: state.offsetDays.toString(),
                          onChanged: (v) => notifier.setOffset(v.round()),
                        ),
                      ),
                      IconButton(
                        onPressed: state.offsetDays >= 2
                            ? null
                            : () => notifier.setOffset(state.offsetDays + 1),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: state.offsetDays == 0
                              ? null
                              : notifier.reset,
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Done'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
