import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/extensions/page_animate_ext.dart';
import 'package:rafeeq/core/widgets/app_pressable.dart';
import 'package:rafeeq/core/widgets/app_state_view.dart';
import 'package:rafeeq/features/adhkar/domain/entities/dhikr_category.dart';
import 'package:rafeeq/features/adhkar/presentation/pages/adhkar_list_page.dart';
import 'package:rafeeq/features/adhkar/presentation/providers/adhkar_providers.dart';

class AdhkarCategoryPage extends ConsumerStatefulWidget {
  const AdhkarCategoryPage({super.key});

  @override
  ConsumerState<AdhkarCategoryPage> createState() => _AdhkarCategoryPageState();
}

class _AdhkarCategoryPageState extends ConsumerState<AdhkarCategoryPage> {
  @override
  Widget build(BuildContext context) {
    final adhkarCategoriesState = ref.watch(fetchAdhkarCategoriesProvider);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(title: const Text('Adhkars')),
      body: adhkarCategoriesState.when(
        data: (categories) {
          if (categories.isEmpty) {
            return Center(
              child: GestureDetector(
                onTap: () => ref.refresh(fetchAdhkarCategoriesProvider),
                child: const Text('No categories found'),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];

              return AppPressableScale(
                scale: 0.8,
                onTap: () => AppNav.push(
                  context,
                  AdhkarPreviewPages(category: category),
                ),
                child: AdhkarCategoryTile(category: category),
              );
            },
          );
        },
        error: (error, stack) => AppStateView(
          icon: HugeIconsSolid.alert01,
          title: 'Failed to load categories',
          message: 'Please try again.',
          buttonText: 'Retry',
          onPressed: () => ref.refresh(fetchAdhkarCategoriesProvider),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    ).animatePage();
  }
}

class AdhkarCategoryTile extends ConsumerWidget {
  const AdhkarCategoryTile({super.key, required this.category});

  final DhikrCategory category;

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: cs.surface,
      ),
      child: Text(
        category.title,
        textAlign: TextAlign.center,
        overflow: TextOverflow.visible,
        maxLines: 2,
        style: theme.textTheme.labelLarge,
      ),
    );
  }
}
