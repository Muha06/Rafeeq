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
        icon: HugeIconsStroke.liveStreaming01,
        active: HugeIconsSolid.liveStreaming01,
        label: 'Live',
      ),
      (
        icon: HugeIconsStroke.bookmark01,
        active: HugeIconsSolid.bookmark01,
        label: 'Bookmarks',
      ),
    ];

    final itemColor = cs.onSurfaceVariant;

    final s = ref.watch(audioControllerProvider);
    final hasAudio = s.currentId != null && s.currentId!.isNotEmpty;

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
      child: (hasAudio)
          ? const GLobalMiniPlayerSheet(key: ValueKey('mini-player'))
          : const SizedBox.shrink(key: ValueKey('empty')),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasAudio) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: miniPlayer,
          ),
        ],

        SafeArea(
          top: false,
          child: Container(
            height: 72,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: theme.bottomNavigationBarTheme.backgroundColor,
              boxShadow: !hasAudio
                  ? [
                      BoxShadow(
                        offset: const Offset(0, -2),
                        blurRadius: 12,
                        spreadRadius: 0,
                        color: cs.shadow,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: List.generate(items.length, (index) {
                final item = items[index];
                final isSelected = currentIndex == index;

                return Expanded(
                  child: InkWell(
                    onTap: () => onTap(index),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
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
                          maxLines: 1,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 12,
                            height: 1,
                            fontWeight: isSelected ? FontWeight.w700 : null,
                            color: isSelected ? cs.primary : itemColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
