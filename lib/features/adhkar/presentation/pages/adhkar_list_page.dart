import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
import 'package:rafeeq/core/widgets/app_pressable.dart';
import 'package:rafeeq/core/widgets/app_state_view.dart';
import 'package:rafeeq/features/adhkar/domain/entities/dhikr_category.dart';
import 'package:rafeeq/features/adhkar/presentation/pages/adhkar_details_page.dart';
import 'package:rafeeq/features/adhkar/presentation/providers/adhkar_providers.dart';

class AdhkarPreviewPages extends ConsumerWidget {
  const AdhkarPreviewPages({super.key, required this.category});
  final DhikrCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adhkarAsync = ref.watch(adhkarProvider(category.id));

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(title: Text(category.title)),
        body: adhkarAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => const AppStateView(
            title: 'Error',
            message: 'Failed to load Adhkars. Please try again',
          ),
          data: (adhkars) {
            if (adhkars.isEmpty) {
              return const Center(child: Text('No adhkars found'));
            }

            return ListView.builder(
              itemCount: adhkars.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: _AdhkarCategoryPreview(category: category),
                  );
                }

                final dhikr = adhkars[index - 1];

                return AppPressableScale(
                  scale: 0.97,
                  onTap: () =>
                      AppNav.push(
                        context,
                        AdhkarDetailsPage(
                          adhkars: adhkars,
                          initialIndex: index - 1,
                        ),
                      ).then(
                        (value) => RafeeqAnalytics.logScreenView(
                          'adhkar_details_page',
                        ),
                      ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 28,
                          width: 28,
                          child: Center(
                            child: Text(
                              index.toString(),
                              style: theme.textTheme.labelSmall,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            dhikr.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelLarge,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _AdhkarCategoryPreview extends StatelessWidget {
  const _AdhkarCategoryPreview({required this.category});

  final DhikrCategory category;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 140,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              category.previewAssetPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  DhikrCategory.fallbackPreviewAsset,
                  fit: BoxFit.cover,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
