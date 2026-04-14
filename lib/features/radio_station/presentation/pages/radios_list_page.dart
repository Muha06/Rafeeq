import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/radio_station/domain/enums/radio_audio_category.dart';
import 'package:rafeeq/features/radio_station/presentation/providers/radio_controller.dart';
import 'package:rafeeq/features/radio_station/presentation/widgets/radio_tab_selector.dart';
import '../widgets/radio_card.dart';

class RadioListPage extends ConsumerStatefulWidget {
  const RadioListPage({super.key});

  @override
  ConsumerState<RadioListPage> createState() => _RadioListPageState();
}

class _RadioListPageState extends ConsumerState<RadioListPage> {
  RadioAudioCategory _selectedCategory = RadioAudioCategory.quran;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(radioControllerProvider);
    final controller = ref.read(radioControllerProvider.notifier);

    if (state is RadioLoaded) {
      _selectedCategory = state.selectedCategory;
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Live Radio")),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // CATEGORY SELECTOR
            RadioCategorySelector(
              selected: _selectedCategory, // default selection
              onChanged: (cat) {
                controller.setCategory(cat);
              },
            ),

            const SizedBox(height: 10),

            // CONTENT
            Expanded(
              child: switch (state) {
                RadioInitial() => const SizedBox(),

                RadioLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),

                RadioError(:final message) => Center(child: Text(message)),

                RadioLoaded(:final stations) => GridView.builder(
                  // padding: const EdgeInsets.all(12),
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
            ),
          ],
        ),
      ),
    );
  }
}
