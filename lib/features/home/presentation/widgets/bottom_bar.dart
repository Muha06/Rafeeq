import 'dart:ui';

import 'package:flutter/material.dart';
 import 'package:hugeicons_pro/hugeicons.dart';

class MyBottomBar extends StatelessWidget {
  final ValueChanged<int> onTap;
  final int currentIndex;

  const MyBottomBar({
    super.key,
    required this.onTap,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final List<({IconData icon, IconData active, String label})> items = [
      (
        icon: HugeIconsStroke.home09,
        active: HugeIconsSolid.home09,
        label: 'Home',
      ),
      (
        icon: HugeIconsStroke.quran02,
        active: HugeIconsSolid.quran02,
        label: "Qur'an",
      ),
      (
        icon: HugeIconsStroke.tasbih,
        active: HugeIconsSolid.tasbih,
        label: 'Adhkār',
      ),
      (
        icon: HugeIconsStroke.bookmark01,
        active: HugeIconsSolid.bookmark01,
        label: 'Bookmarks',
      ),
    ];
    final isDark = Theme.brightnessOf(context) == Brightness.dark;

    final itemColor = isDark ? Colors.white70 : Colors.black87;

    return SafeArea(
      top: false,
      bottom: false,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: cs.surface.withAlpha(140)),
            child: Row(
              children: List.generate(items.length, (index) {
                final item = items[index];
                final isSelected = currentIndex == index;

                return Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onTap(index),
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 350),
                              child: Icon(
                                isSelected ? item.active : item.icon,
                                key: ValueKey(isSelected), // simpler
                                color: isSelected ? cs.primary : itemColor,
                                size: 24,
                              ),
                            ),
                          ),

                          Text(
                            item.label,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 12,
                              height: 1,
                              color: itemColor,
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
        ),
      ),
    );
  }
}
