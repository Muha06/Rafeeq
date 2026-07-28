import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:rafeeq/core/features/audio/presentation/providers/audio_controller.dart';
import 'package:rafeeq/core/features/audio/presentation/widgets/global_mini_player.dart';

class MyBottomBar extends ConsumerWidget {
  final ValueChanged<int> onTap;
  final int currentIndex;

  const MyBottomBar({
    super.key,
    required this.onTap,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context, ref) {
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

    final itemColor = isDark ? Colors.white70 : Colors.black;

    final s = ref.watch(audioControllerProvider);
    final miniPlayer = AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: (s.currentId != null && s.currentId!.isNotEmpty)
          ? const GLobalMiniPlayerSheet(key: ValueKey('mini-player'))
          : const SizedBox(key: ValueKey('empty')),
    );

    final blurSize = isDark ? 4.0 : 16.0;

    return SafeArea(
      top: true,
      bottom: false,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSize, sigmaY: blurSize),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              miniPlayer,

              // const SizedBox(height: 6),
              SafeArea(
                top: false,
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: const BoxDecoration(color: Colors.black26),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 350),
                                  child: Icon(
                                    isSelected ? item.active : item.icon,
                                    key: ValueKey(isSelected), // simpler
                                    color: isSelected ? cs.primary : itemColor,
                                    size: 24,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  item.label,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontSize: 12,
                                    height: 1,
                                    color: isSelected ? cs.primary : itemColor,
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
            ],
          ),
        ),
      ),
    );
  }
}
