import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Ensure flutter_animate is imported
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Adhkar'), centerTitle: true),
      body: adhkarCategoriesState.when(
        data: (categories) {
          if (categories.isEmpty) {
            return Center(
              child: GestureDetector(
                onTap: () => ref.refresh(adhkarCategoriesProvider),
                child: Text(
                  'No categories found',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final category = categories[index];

                    final isEven = index % 2 == 0;

                    return AppPressableScale(
                      scale: 0.97,
                      onTap: () => AppNav.push(
                        context,
                        AdhkarPreviewPages(category: category),
                      ),
                      child: AdhkarCategoryTile(category: category)
                          .animate()
                          .fadeIn(
                            duration: 500.ms,
                            curve: Curves.easeOutCubic,
                            delay: (index * 80).ms,
                          )
                          .slideY(
                            begin: isEven ? 0.15 : 0.25,
                            end: 0,
                            duration: 600.ms,
                            curve: Curves.easeOutBack,
                            delay: (index * 80).ms,
                          )
                          .scaleXY(
                            begin: 0.92,
                            end: 1,
                            duration: 550.ms,
                            curve: Curves.easeOutCubic,
                            delay: (index * 80).ms,
                          ),
                    );
                  }, childCount: categories.length),
                ),
              ),
            ],
          );
        },
        error: (error, stack) => AppStateView(
          icon: HugeIconsSolid.alert01,
          title: 'Failed to load categories',
          message: 'Please try again.',
          buttonText: 'Retry',
          onPressed: () => ref.refresh(adhkarCategoriesProvider),
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
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

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
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
                    stops: const [0.0, 0.45, 0.75, 1.0],
                    colors: [
                      Colors.black.withValues(alpha: 0.15),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.65),
                      Colors.black.withValues(alpha: 0.97),
                    ],
                  ),
                ),
              ),
            ),

            // Content Layer
            Positioned(
              left: 14,
              right: 14,
              bottom: 16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    category.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
