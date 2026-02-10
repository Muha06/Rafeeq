import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/features/adhkar/domain/entities/adhkar_category.dart';
import 'package:rafeeq/features/adhkar/presentation/pages/adhkar_list_page.dart';
import 'package:rafeeq/features/adhkar/presentation/riverpod/adhkar_categories.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class AdhkarCategoryPage extends ConsumerStatefulWidget {
  const AdhkarCategoryPage({super.key});

  @override
  ConsumerState<AdhkarCategoryPage> createState() => _AdhkarCategoryPageState();
}

class _AdhkarCategoryPageState extends ConsumerState<AdhkarCategoryPage> {
  @override
  Widget build(BuildContext context) {
    final adhkarCategories = ref.watch(getAdhkarCategoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Adhkars Categories')),
      body: ListView.builder(
        itemCount: adhkarCategories.length,
        itemBuilder: (context, index) {
          final category = adhkarCategories[index];

          return AdhkarCategoryTile(category: category);
        },
      ),
    );
  }
}

class AdhkarCategoryTile extends ConsumerWidget {
  const AdhkarCategoryTile({super.key, required this.category});

  final AdhkarCategory category;

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdhkarListPage(category: category),
            ),
          );
        },
        child: Stack(
          children: [
            Container(
              height: 80,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: isDark
                    ? AppDarkColors.darkSurface
                    : AppLightColors.lightSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                category.title,
                style: theme.textTheme.bodyLarge!.copyWith(fontSize: 18),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: Image.asset(category.imagePath, height: 48, width: 48),
            ),
          ],
        ),
      ),
    );
  }
}
