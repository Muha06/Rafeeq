import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/features/adhkar/presentation/pages/adhkar_list_page.dart';
import 'package:rafeeq/features/adhkar/presentation/riverpod/adhkar_categories.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class EveningAdhkarRemindercard extends ConsumerWidget {
  const EveningAdhkarRemindercard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 4, bottom: 16),
      child: GestureDetector(
        onTap: () {
          final categories = ref.read(getAdhkarCategoriesProvider);

          final eveningCategory = categories.firstWhere(
            (c) => c.title.toLowerCase().contains('evening'),
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdhkarListPage(category: eveningCategory),
            ),
          );
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isDark
                    ? AppDarkColors.darkSurface
                    : AppLightColors.amberSoft,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Evening Adhkār 🌙",
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "It’s time — keep your heart protected for the night.",
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontSize: 14,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Tap to start >',
                        style: theme.textTheme.bodySmall!.copyWith(
                          color: isDark ? AppLightColors.amber : Colors.black,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Image.asset(
                'assets/images/adhkar/mosque.png',
                height: 30,
                width: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
