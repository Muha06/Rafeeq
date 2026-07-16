import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

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
        icon: PhosphorIcons.house,
        active: PhosphorIcons.houseFill,
        label: 'Home',
      ),
      (
        icon: PhosphorIcons.bookOpenText,
        active: PhosphorIcons.bookOpenTextFill,
        label: "Qur'an",
      ),
      (
        icon: PhosphorIcons.handsPraying,
        active: PhosphorIcons.handsPrayingFill,
        label: 'Adhkār',
      ),
      (
        icon: PhosphorIcons.bookmark,
        active: PhosphorIcons.bookmarkFill,
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
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: cs.surface.withAlpha(80)),
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
