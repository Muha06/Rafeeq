import 'package:flutter/material.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';

class MyBottomBar extends StatelessWidget {
  final ValueChanged<int> onTap;
  final int currentIndex;
  final bool isDarkMode;

  const MyBottomBar({
    super.key,
    required this.onTap,
    required this.currentIndex,
    required this.isDarkMode,
  });

  static const _items = [
    (icon: Icons.home_outlined, active: Icons.home_rounded, label: 'Home'),
    (icon: Icons.menu_book, active: Icons.menu_book_rounded, label: "Qur'an"),
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
      //bg container
      child: Container(
        height: 61,
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppDarkColors.bottomBar
              : AppLightColors.amberSoft,
          border: Border(top: BorderSide(color: theme.dividerColor)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
        child: Row(
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final isSelected = currentIndex == index;

            final selectedFg = isDarkMode
                ? AppDarkColors.amber
                : AppLightColors.iconPrimary;

            final unselectedFg = isDarkMode
                ? AppDarkColors.iconSecondary
                : Colors.black54;

            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 120),
                        switchInCurve: Curves.easeOutBack,
                        switchOutCurve: Curves.easeIn,
                        transitionBuilder: (child, anim) =>
                            ScaleTransition(scale: anim, child: child),
                        child: Icon(
                          isSelected ? item.active : item.icon,
                          key: ValueKey('$index-$isSelected'),
                          size: isSelected ? 21 : 19,
                          color: isSelected ? selectedFg : unselectedFg,
                        ),
                      ),
                      const SizedBox(height: 6),

                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        style: theme.textTheme.bodySmall!.copyWith(
                          color: isSelected ? selectedFg : unselectedFg,
                          fontSize: isSelected ? 12 : 11,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w700,
                        ),
                        child: Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
