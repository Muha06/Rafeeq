import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
import 'package:rafeeq/features/adhkar/domain/entities/adhkar_category.dart';
import 'package:rafeeq/features/adhkar/presentation/pages/adhkar_list_page.dart';
import 'package:rafeeq/features/adhkar/presentation/riverpod/adhkar_categories.dart';

class AdhkarCategoryPage extends ConsumerStatefulWidget {
  const AdhkarCategoryPage({super.key});

  @override
  ConsumerState<AdhkarCategoryPage> createState() => _AdhkarCategoryPageState();
}

class _AdhkarCategoryPageState extends ConsumerState<AdhkarCategoryPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final adhkarCategories = ref.watch(getAdhkarCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adhkars Categories'),
        bottom: appBarBottomDivider(context),
      ),
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

class AdhkarCategoryTile extends StatelessWidget {
  const AdhkarCategoryTile({super.key, required this.category});

  final AdhkarCategory category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                color: AppDarkColors.darkSurface,
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
