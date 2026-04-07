import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
import 'package:rafeeq/features/adhkar/domain/entities/adhkar_category.dart';
import 'package:rafeeq/features/adhkar/presentation/pages/adhkar_titles_pages.dart';
import 'package:rafeeq/features/adhkar/presentation/riverpod/get_adhkars_provider.dart';

class AdhkarCategoryPage extends ConsumerStatefulWidget {
  const AdhkarCategoryPage({super.key});

  @override
  ConsumerState<AdhkarCategoryPage> createState() => _AdhkarCategoryPageState();
}

class _AdhkarCategoryPageState extends ConsumerState<AdhkarCategoryPage> {
  @override
  Widget build(BuildContext context) {
    final adhkarCategories = ref.watch(adhkarCategoriesProviders);

    return Scaffold(
      appBar: AppBar(title: const Text('Adhkars')),
      body: ListView.builder(
        itemCount: adhkarCategories.length,
        itemBuilder: (context, index) {
          final category = adhkarCategories[index];

          return GestureDetector(
            onTap: () =>
                AppNav.push(
                  context,
                  AdhkarTitlesPages(
                    categoryTitle: category.name,
                    categoryIds: category.categoryIds,
                  ),
                ).then(
                  (value) =>
                      RafeeqAnalytics.logScreenView('adhkar_category'),
                ),
            child: AdhkarCategoryTile(category: category),
          );
        },
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
          category.name,
          style: theme.textTheme.bodyLarge!.copyWith(fontSize: 18),
        ),
      ),
    );
  }
}
