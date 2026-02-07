import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class HomeQuickActionsRow extends StatelessWidget {
  final VoidCallback onQuran;
  final VoidCallback onAdhkar;
  final VoidCallback onAllahNames;

  const HomeQuickActionsRow({
    super.key,
    required this.onQuran,
    required this.onAdhkar,
    required this.onAllahNames,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ' Quick links',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            // fontWeight: FontWeight.w600,
            // color: AppLightColors.textBody,
          ),
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                title: "Qur’an",
                imagePath: 'assets/images/home/quran.png',
                onTap: onQuran,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickActionCard(
                title: "Adhkār",
                imagePath: 'assets/images/home/tasbih.png',
                onTap: onAdhkar,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickActionCard(
                title: "Allah's Names",
                imagePath: 'assets/images/home/Allah_name.png',
                onTap: onAllahNames,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionCard extends ConsumerWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isDark ? theme.cardColor : AppLightColors.lightSurface,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                wordSpacing: 1,
                fontSize: 12,
                color: isDark
                    ? AppDarkColors.textPrimary
                    : AppLightColors.textPrimary,
              ),
            ),

            Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(imagePath, height: 40, width: 40),
            ),
          ],
        ),
      ),
    );
  }
}
