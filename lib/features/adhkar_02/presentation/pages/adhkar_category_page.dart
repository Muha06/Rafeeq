import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/features/adhkar_02/domain/entities/dhikr_category.dart';
import 'package:rafeeq/features/adhkar_02/presentation/pages/adhkar_list_page.dart';
import 'package:rafeeq/features/adhkar_02/presentation/providers/adhkar_providers.dart';

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

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];

              return GestureDetector(
                onTap: () => AppNav.push(
                  context,
                  AdhkarPreviewPages(category: category),
                ),
                child: AdhkarCategoryTile(category: category),
              );
            },
          );
        },
        error: (error, stack) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class AdhkarCategoryTile extends ConsumerWidget {
  const AdhkarCategoryTile({super.key, required this.category});

  final DhikrCategory category;

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Container(
        height: 80,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: cs.surface,
        ),
        child: Text(
          category.title,
          style: theme.textTheme.bodyLarge!.copyWith(fontSize: 18),
        ),
      ),
    );
  }
}
