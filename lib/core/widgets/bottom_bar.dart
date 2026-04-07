import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final List<({IconData icon, IconData active, String label})> items = [
      (
        icon: PhosphorIcons.house(),
        active: PhosphorIcons.house(PhosphorIconsStyle.fill),
        label: 'Home',
      ),
      (
        icon: PhosphorIcons.bookOpenText(),
        active: PhosphorIcons.bookOpenText(PhosphorIconsStyle.fill),
        label: "Qur'an",
      ),
      (
        icon: PhosphorIcons.handsPraying(),
        active: PhosphorIcons.handsPraying(PhosphorIconsStyle.fill),
        label: 'Adhkār',
      ),
      (
        icon: PhosphorIcons.bookmark(),
        active: PhosphorIcons.bookmark(PhosphorIconsStyle.fill),
        label: 'Bookmarks',
      ),
    ];

    return SafeArea(
      bottom: true,
      child: Container(
        height: 61,
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: cs.outline, width: 0.5)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: Icon(
                        isSelected ? item.active : item.icon,
                        key: ValueKey(isSelected), // simpler
                        color: isSelected ? cs.primary : cs.onSurfaceVariant,
                        size: isSelected ? 26 : 24,
                      ),
                    ),
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
