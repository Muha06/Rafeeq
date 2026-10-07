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
    final adhkarCategoriesState = ref.watch(adhkarCategoriesProvider);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(title: const Text('Adhkars')),
      body: adhkarCategoriesState.when(
        data: (categories) {
          if (categories.isEmpty) {
            return Center(
              child: GestureDetector(
                onTap: () => ref.refresh(adhkarCategoriesProvider),
                child: const Text('No categories found'),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.87,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];

              return AppPressableScale(
                scale: 0.93,
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
          onPressed: () => ref.refresh(adhkarCategoriesProvider),
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
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              category.previewAssetPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                DhikrCategory.fallbackPreviewAsset,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.95),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Text(
              category.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
