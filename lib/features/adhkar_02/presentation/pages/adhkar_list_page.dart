import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
import 'package:rafeeq/features/adhkar_02/domain/entities/dhikr_category.dart';
import 'package:rafeeq/features/adhkar_02/presentation/pages/adhkar_details_page.dart';
import 'package:rafeeq/features/adhkar_02/presentation/providers/adhkar_providers.dart';

class AdhkarPreviewPages extends ConsumerWidget {
  const AdhkarPreviewPages({super.key, required this.category});
  final DhikrCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adhkarAsync = ref.watch(fetchAllAdhkarProvider(category.id));

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(title: Text(category.title)),
        body: adhkarAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (adhkars) {
            if (adhkars.isEmpty) {
              return const Center(child: Text('No adhkars found'));
            }

            return ListView.builder(
              itemCount: adhkars.length,
              itemBuilder: (context, index) {
                final dhikr = adhkars[index];

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () =>
                      AppNav.push(
                        context,
                        AdhkarDetailsPage(dhikr: dhikr),
                      ).then(
                        (value) => RafeeqAnalytics.logScreenView(
                          'adhkar_details_page',
                        ),
                      ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        //Number
                        Container(
                          height: 24,
                          width: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: cs.primary,
                          ),
                          child: Center(
                            child: Text(
                              (index + 1).toString(),
                              style: theme.textTheme.bodySmall!.copyWith(
                                color: cs.onPrimary,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            dhikr.title  ,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(width: 8),

                        const Icon(Icons.chevron_right),
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
