import 'dart:ui';

import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_item.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_source_type.dart';
import 'package:rafeeq/core/features/audio/presentation/providers/audio_controller.dart';
import 'package:rafeeq/core/helpers/app_haptics.dart';
import 'package:rafeeq/core/helpers/app_toast.dart';
import 'package:rafeeq/core/helpers/clean_arabic_text.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
import 'package:rafeeq/core/helpers/app_text_style.dart';
import 'package:rafeeq/core/widgets/my_chip.dart';
import 'package:rafeeq/features/adhkar/domain/entities/dhikr_entity.dart';
import 'package:rafeeq/features/adhkar/presentation/providers/adhkar_providers.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/dhikr_bookmark.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/dhikr/dhikr_notifier_provider.dart';
import 'package:vibration/vibration.dart';
import 'package:hugeicons_pro/hugeicons.dart';

class AdhkarDetailsPage extends ConsumerStatefulWidget {
  const AdhkarDetailsPage({
    super.key,
    required this.adhkars,
    required this.initialIndex,
  });

  final List<Dhikr> adhkars;
  final int initialIndex;
  @override
  ConsumerState<AdhkarDetailsPage> createState() => _AdhkarDetailsPageState();
}

class _AdhkarDetailsPageState extends ConsumerState<AdhkarDetailsPage> {
  late final PageController _controller;
  int currentIndex = 0;
  int _dhikrCount = 0;

  static const _edgeWidth = 80.0;
  static const _pageDuration = Duration(milliseconds: 280);
  static const _pageCurve = Curves.easeOutCubic;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialIndex);
    currentIndex = widget.initialIndex;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleEdgeTap(TapUpDetails details, double width) {
    final dx = details.localPosition.dx;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    int delta = 0;
    if (dx < _edgeWidth) {
      delta = isRtl ? 1 : -1;
    } else if (dx > width - _edgeWidth) {
      delta = isRtl ? -1 : 1;
    }
    if (delta == 0) return;

    final target = currentIndex + delta;
    if (target < 0 || target >= widget.adhkars.length) return;

    _controller.animateToPage(
      target,
      duration: _pageDuration,
      curve: _pageCurve,
    );
    AppHaptics.selection();
  }

  Future<void> _onCounterTap(Dhikr dhikr) async {
    if (_dhikrCount >= dhikr.repeat) return; // clamp

    setState(() => _dhikrCount++);

    final completed = _dhikrCount >= dhikr.repeat;
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(
        duration: completed ? 300 : 20,
        amplitude: completed ? 255 : 128,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;
    final dhikr = widget.adhkars[currentIndex];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return FloatingDraggableWidget(
          mainScreenWidget: Scaffold(
            appBar: AppBar(
              title: Text(
                dhikr.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.appBarTheme.titleTextStyle?.copyWith(fontSize: 18),
              ),
              actionsPadding: const EdgeInsets.symmetric(horizontal: 16),
              actions: [
                GestureDetector(
                  onTap: () => AppToast.showCompact(
                    context: context,
                    message: "Repeat the dhikr ${dhikr.repeat} times",
                  ),
                  child: MyChip(
                    backgroundColor: cs.tertiary,
                    borderRadius: 999,
                    child: Text(
                      '${dhikr.repeat}×',
                      style: tt.labelMedium?.copyWith(color: cs.onTertiary),
                    ),
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(end: (currentIndex + 1) / widget.adhkars.length),
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  builder: (_, value, _) =>
                      LinearProgressIndicator(value: value, minHeight: 2),
                ),
              ),
            ),
            body: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapUp: (d) => _handleEdgeTap(d, width),
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _controller,
                    itemCount: widget.adhkars.length,
                    onPageChanged: (index) => setState(() {
                      currentIndex = index;
                      _dhikrCount = 0;
                    }),
                    itemBuilder: (_, index) =>
                        AdhkarDetailsSection(dhikr: widget.adhkars[index]),
                  ),
                  Positioned(
                    bottom: 16 + MediaQuery.of(context).padding.bottom,
                    left: 48,
                    right: 48,
                    child: _BottomNavBar(dhikr: dhikr),
                  ),
                ],
              ),
            ),
          ),
          floatingWidget: DhikrFloatingButton(
            count: _dhikrCount,
            total: dhikr.repeat,
            onTap: () => _onCounterTap(dhikr),
          ),
          floatingWidgetHeight: 72,
          floatingWidgetWidth: 72,
          dy: height - 220,
          dx: width - 100,
        );
      },
    );
  }
}

class _BottomNavBar extends ConsumerWidget {
  const _BottomNavBar({required this.dhikr});
  final Dhikr dhikr;

  @override
  Widget build(BuildContext context, ref) {
    final cs = Theme.of(context).colorScheme;

    Future<void> toggleBookmark(Dhikr dhikr) async {
      final categories = await ref.read(adhkarCategoriesProvider.future);

      final category = categories.firstWhere((c) => c.id == dhikr.categoryId);

      final bookmark = DhikrBookmark(
        dhikrId: dhikr.id,
        title: dhikr.title,
        categoryTitle: category.title,
        arabic: dhikr.arabicText,
        translation: dhikr.englishText,
        repeat: dhikr.repeat,
        categoryId: dhikr.categoryId,
        createdAt: DateTime.now(),
      );

      ref.read(dhikrBookmarksProvider.notifier).toggle(bookmark);
    }

    Future<void> copyDhikr(Dhikr dhikr) async {
      final transliteration = dhikr.transliteration;

      final buffer = StringBuffer();

      // Arabic
      buffer.writeln(cleanDhikr(dhikr.arabicText));
      buffer.writeln();

      // Transliteration
      if (transliteration != null && transliteration.trim().isNotEmpty) {
        buffer.writeln("Transliteration:");
        buffer.writeln(transliteration.trim());
        buffer.writeln();
      }

      // Translation
      if ((dhikr.englishText).trim().isNotEmpty) {
        buffer.writeln("Translation:");
        buffer.writeln(dhikr.englishText.trim());
        buffer.writeln();
      }

      // Repeat
      buffer.writeln("Repeat ${dhikr.repeat} times");

      RafeeqAnalytics.logFeature('copy_dhikr');

      await Clipboard.setData(ClipboardData(text: buffer.toString().trim()));
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: cs.surface.withAlpha(100),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Bookmark
              Consumer(
                builder: (context, ref, _) {
                  final isBookmarked = ref.watch(
                    isDhikrBookmarkedProvider(dhikr.id),
                  );

                  return _BottomNavItem(
                    icon: isBookmarked
                        ? HugeIconsSolid.bookmark01
                        : HugeIconsStroke.bookmark01,
                    iconColor: isBookmarked ? cs.primary : cs.onSurface,
                    label: isBookmarked ? 'Unsave' : 'Save',
                    onTap: () {
                      toggleBookmark(dhikr);
                    },
                  );
                },
              ),

              // Play
              if (dhikr.audioUrl != null)
                Consumer(
                  builder: (context, ref, _) {
                    final audioState = ref.watch(audioControllerProvider);
                    final audioCtrl = ref.read(
                      audioControllerProvider.notifier,
                    );

                    final isCurrent =
                        audioState.currentId == dhikr.id.toString();
                    final isPlaying = audioState.isPlaying && isCurrent;

                    final isBuffering = audioState.isBuffering && isCurrent;
                    return _BottomNavItem(
                      icon: isBuffering
                          ? CupertinoIcons.circle
                          : isPlaying
                          ? HugeIconsStroke.pause
                          : HugeIconsStroke.play,

                      label: isPlaying ? 'Stop' : 'Play',

                      onTap: () async {
                        final item = AudioItem(
                          id: dhikr.id,
                          title: dhikr.title,
                          sourceType: AudioSourceType.adhkar,
                          url: dhikr.audioUrl!,
                        );

                        await audioCtrl.togglePlay(item: item);

                        RafeeqAnalytics.logFeature('play_adhkar_audio');
                      },
                    );
                  },
                ),

              // Copy
              _BottomNavItem(
                icon: HugeIconsStroke.copy01,
                label: 'Copy',
                onTap: () async {
                  await copyDhikr(dhikr);
                  AppHaptics.selection();
                  if (context.mounted) {
                    AppToast.showCompact(context: context, message: 'Copied');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    this.iconColor,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color? iconColor;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final tt = theme.textTheme;
    final cs = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: double.infinity,
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: Center(
                child: Icon(icon, color: iconColor ?? cs.onSurface),
              ),
            ),
            const SizedBox(height: 2),

            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: tt.labelMedium?.copyWith(
                fontSize: 12,
                color: cs.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdhkarDetailsSection extends StatelessWidget {
  const AdhkarDetailsSection({super.key, required this.dhikr});

  final Dhikr dhikr;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final bodyTextstyle = textTheme.bodyLarge?.copyWith(fontSize: 18);
    final cs = theme.colorScheme;

    Widget section(IconData icon, String title, String? text) {
      final hasValidText = text != null && text.isNotEmpty;

      if (!hasValidText) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: cs.onSurfaceVariant),

              const SizedBox(width: 8),

              Text(title, style: textTheme.labelSmall),
            ],
          ),

          const SizedBox(height: 8),

          Text(text, style: bodyTextstyle), //text
          const SizedBox(height: 24),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //arabic
            Align(
              alignment: Alignment.center,
              child: Text(
                cleanDhikr(dhikr.arabicText),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: AppTextStyles.quranAyah.copyWith(
                  color: cs.onSurface,
                  fontSize: 30,
                  height: 1.8,
                ),
              ),
            ),
            const SizedBox(height: 32),

            //transliteration
            section(
              HugeIconsSolid.book01,
              'Transliteration',
              dhikr.transliteration,
            ),

            //english
            section(
              HugeIconsSolid.translation,
              'Translation',
              dhikr.englishText.trim(),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class DhikrFloatingButton extends StatelessWidget {
  const DhikrFloatingButton({
    super.key,
    required this.count,
    required this.total,
    required this.onTap,
  });

  final int count;
  final int total;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : count / total;
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cs.primary,
              boxShadow: [
                BoxShadow(
                  color: cs.shadow,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),

          SizedBox(
            width: 72,
            height: 72,
            child: CircularProgressIndicator(
              value: progress,
              color: cs.onSurface,
              strokeWidth: 5,
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$count",
                style: tt.titleLarge?.copyWith(color: cs.onPrimary),
              ),
              Text(
                "/ $total",
                style: tt.labelMedium?.copyWith(color: cs.onPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
