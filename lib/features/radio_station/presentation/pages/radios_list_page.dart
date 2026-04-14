import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/radio_station/presentation/providers/radio_controller.dart';

import '../widgets/radio_card.dart';

class RadioListPage extends ConsumerWidget {
  const RadioListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(radioControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Live Radio")),
      body: switch (state) {
        RadioInitial() => const SizedBox(),

        RadioLoading() => const Center(child: CircularProgressIndicator()),

        RadioError(:final message) => Center(child: Text(message)),

        RadioLoaded(:final stations) => GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.78,
          ),
          itemCount: stations.length,
          itemBuilder: (_, i) => RadioCard(station: stations[i]),
        ),
      },
    );
  }
}
