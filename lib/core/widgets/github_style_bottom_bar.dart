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
      bottom: false,
      child: Container(
        height: 74,
        color: theme.cardColor,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Row(
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final isSelected = currentIndex == index;

            final selectedBg = isDarkMode
                ? AppDarkColors.selectedBottomBar
                : AppLightColors.iconAccent;

            final selectedFg = isDarkMode
                ? AppDarkColors.iconAccent
                : Colors.grey[900];

            final unselectedFg = isDarkMode
                ? AppDarkColors.iconSecondary
                : Colors.black54;

            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(index),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 54,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isSelected ? selectedBg : Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(
                        isSelected ? item.active : item.icon,
                        size: 22,
                        color: isSelected ? selectedFg : unselectedFg,
                      ),
                    ),
                    const SizedBox(height: 6),
                    
                    Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isSelected ? selectedFg : unselectedFg,
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w700
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
