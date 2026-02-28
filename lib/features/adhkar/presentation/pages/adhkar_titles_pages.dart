import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/features/adhkar/presentation/pages/adhkar_details_page.dart';
import 'package:rafeeq/features/adhkar/presentation/riverpod/get_adhkars_provider.dart';
import 'package:rafeeq/features/adhkar/domain/entities/dhikr.dart';

class AdhkarTitlesPages extends ConsumerWidget {
  const AdhkarTitlesPages({
    super.key,
    required this.categoryIds,
    required this.categoryTitle,
  });
  final List<int> categoryIds;
  final String categoryTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adhkarAsync = ref.watch(getAdhkarsProvider(categoryIds));

    return Scaffold(
      appBar: AppBar(title: Text(categoryTitle)),
      body: adhkarAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (adhkars) {
          // Group adhkars by categoryId
          final Map<int, List<DhikrEntity>> grouped = {};
          for (final d in adhkars) {
            grouped.putIfAbsent(d.categoryId, () => []).add(d);
          }

          final categoryIdsInData = grouped.keys.toList();

          return ListView.builder(
            itemCount: categoryIdsInData.length,
            itemBuilder: (context, index) {
              final catId = categoryIdsInData[index];
              final adhkarsForCategory = grouped[catId]!;

              return ListTile(
                title: Text(adhkarsForCategory.first.categoryTitle),
                onTap: () {
                  AppNav.push(
                    context,
                    AdhkarDetailsPage(
                      adhkars: adhkarsForCategory,
                      title: adhkarsForCategory.first.categoryTitle,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
