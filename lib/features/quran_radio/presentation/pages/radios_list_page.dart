import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/constants/spacing/app_spacing.dart';
import 'package:rafeeq/core/widgets/app_state_view.dart';
import 'package:rafeeq/features/quran_radio/domain/enums/radio_audio_category.dart';
import 'package:rafeeq/features/quran_radio/presentation/providers/radio_controller.dart';
import 'package:rafeeq/features/quran_radio/presentation/widgets/radio_tab_selector.dart';
import '../widgets/radio_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: RadioCategorySelector(
              selected: _selectedCategory,
              onChanged: (cat) {
                controller.setCategory(cat);
              },
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 10)),

        switch (state) {
          RadioInitial() => const SliverFillRemaining(child: SizedBox()),

          RadioLoading() => const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),

          RadioError() => SliverFillRemaining(
            child: AppStateView(
              icon: PhosphorIcons.radio,
              title: "Error loading stations",
              message:
                  "We couldn't load the radio stations, please try again later.",
              buttonText: "retry",
              onPressed: () => controller.loadAll(),
            ),
          ),

          RadioLoaded(:final stations) when stations.isEmpty =>
            SliverFillRemaining(child: _emptyState()),

          RadioLoaded(:final stations) => SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
              vertical: AppSpacing.screenVertical,
            ),
            sliver: SliverMasonryGrid.count(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 20,
              childCount: stations.length,
              itemBuilder: (_, i) {
                return RadioCard(stations: stations, initialIndex: i);
              },
            ),
          ),
        },
      ],
    );
  }
}

Widget _emptyState() {
  return const Center(
    child: AppStateView(
      icon: PhosphorIcons.radio,
      title: "No stations found",
      message: "We couldn't find any radio stations for this category.",
    ),
  );
}
