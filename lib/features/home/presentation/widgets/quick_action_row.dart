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
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            title: "Qur’an",
            icon: Icons.menu_book_rounded,
            onTap: onQuran,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionCard(
            title: "Adhkār",
            icon: Icons.self_improvement_rounded,
            onTap: onAdhkar,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionCard(
            title: "Allah Names",
            icon: Icons.auto_awesome_rounded,
            onTap: onAllahNames,
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends ConsumerWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: 120,
        width: 200,
        padding: const EdgeInsets.all(8),
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
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: isDark
                    ? AppDarkColors.textPrimary
                    : AppLightColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),

            //will change to image later
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? AppDarkColors.border
                        : AppLightColors.primary,
                  ),
                  color: isDark ? theme.cardColor : AppLightColors.lightSurface,
                ),
                child: Icon(
                  icon,
                  color: isDark
                      ? AppDarkColors.iconPrimary
                      : AppLightColors.primary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
