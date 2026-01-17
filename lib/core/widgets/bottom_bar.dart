import 'package:flutter/material.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';

class GithubStyleBottomBar extends StatelessWidget {
  final ValueChanged<int> onTap;
  final int currentIndex;
  final bool isDarkMode;

  const GithubStyleBottomBar({
    super.key,
    required this.onTap,
    required this.currentIndex,
    required this.isDarkMode,
  });

  static const _items = [
    (icon: Icons.home_outlined, active: Icons.home_rounded, label: 'Home'),
    (
      icon: Icons.menu_book_outlined,
      active: Icons.menu_book_rounded,
      label: "Qur'an",
    ),
    (
      icon: Icons.self_improvement_outlined,
      active: Icons.self_improvement_rounded,
      label: 'Adhkār',
    ),
    (
      icon: Icons.bookmark_outline,
      active: Icons.bookmark_rounded,
      label: 'Bookmarks',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      bottom: true,
      child: Container(
        height: 74,
        color: isDarkMode
            ? AppDarkColors.bottomBar
            : AppLightColors.lightSurface,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Row(
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final isSelected = currentIndex == index;

            final selectedFg = isDarkMode
                ? AppDarkColors.amber
                : AppLightColors.buttonPrimaryPressed;

            final unselectedFg = isDarkMode
                ? AppDarkColors.iconSecondary
                : Colors.black54;

            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(index),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isSelected ? item.active : item.icon,
                      size: 22,
                      color: isSelected ? selectedFg : unselectedFg,
                    ),
                    const SizedBox(height: 6),

                    Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isSelected ? selectedFg : unselectedFg,
                        fontSize: isSelected ? 14 : 12,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
