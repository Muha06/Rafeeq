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
import 'package:rafeeq/core/helpers/clean_arabic_text.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
import 'package:rafeeq/core/helpers/app_text_style.dart';
import 'package:rafeeq/features/adhkar/domain/entities/dhikr_entity.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dhikr = widget.adhkars[currentIndex];

    return LayoutBuilder(
      builder: (context, _) {
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;

        return FloatingDraggableWidget(
          mainScreenWidget: SafeArea(
            top: false,
            bottom: true,
            child: SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    dhikr.title,
                    style: theme.appBarTheme.titleTextStyle?.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(1),
                    child: LinearProgressIndicator(
                      value: (currentIndex + 1) / widget.adhkars.length,
                    ),
                  ),
                ),

                body: GestureDetector(
                  onTapUp: (details) {
                    final screenWidth = MediaQuery.of(context).size.width;
                    final dx = details.localPosition.dx;

                    const edgeWidth = 80.0;
                    const duration = Duration(milliseconds: 170);

                    if (dx < edgeWidth) {
                      // Left edge tapped
                      _controller.previousPage(
                        duration: duration,
                        curve: Curves.fastOutSlowIn,
                      );
                      if (currentIndex > 0) AppHaptics.selection();
                    } else if (dx > screenWidth - edgeWidth) {
                      // Right edge tapped
                      _controller.nextPage(
                        duration: duration,
                        curve: Curves.fastOutSlowIn,
                      );

                      if (currentIndex < widget.adhkars.length - 1) {
                        AppHaptics.selection();
                      }
                    }
                  },
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _controller,
                        itemCount: widget.adhkars.length,
                        onPageChanged: (index) {
                          setState(() {
                            currentIndex = index;
                            _dhikrCount = 0;
                          });
                        },
                        itemBuilder: (context, index) {
                          final dhikr = widget.adhkars[index];

                          return AdhkarDetailsSection(dhikr: dhikr);
                        },
                      ),

                      // Fixed bottom nav bar
                      Positioned(
                        bottom: 16,
                        left: 48,
                        right: 48,
                        child: _BottomNavBar(dhikr: dhikr),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          floatingWidget: DhikrFloatingButton(
            count: _dhikrCount,
            total: dhikr.repeat,
            onTap: () async {
              setState(() {
                _dhikrCount++;
              });

              final isCompleting = _dhikrCount >= dhikr.repeat;

              if (isCompleting) {
                await Vibration.vibrate(duration: 300, amplitude: 255);
              } else {
                await Vibration.vibrate(duration: 20);
              }
            },
          ),
          floatingWidgetHeight: 64,
          floatingWidgetWidth: 64,
          dy: screenHeight - 200,
          dx: screenWidth - 100,
        );
      },
    );
  }
}

class _BottomNavBar extends ConsumerWidget {
  const _BottomNavBar({super.key, required this.dhikr});
  final Dhikr dhikr;

  @override
  Widget build(BuildContext context, ref) {
    final cs = Theme.of(context).colorScheme;

    void toggleBookmark(Dhikr dhikr) {
      final bookmark = DhikrBookmark(
        dhikrId: dhikr.id,
        title: dhikr.title,
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
                          title: dhikr.transliteration ?? 'adhkar',
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
                  copyDhikr(dhikr);
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

class AdhkarDetailsSection extends ConsumerStatefulWidget {
  const AdhkarDetailsSection({super.key, required this.dhikr});

  final Dhikr dhikr;
  @override
  ConsumerState<AdhkarDetailsSection> createState() =>
      _AdhkarDetailsSectionState();
}

class _AdhkarDetailsSectionState extends ConsumerState<AdhkarDetailsSection> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final dhikr = widget.dhikr;

    final bodyTextstyle = textTheme.bodyLarge;
    final cs = theme.colorScheme;

    Widget section(String title, String? text) {
      final hasValidText = text != null && text.isNotEmpty;

      if (!hasValidText) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textTheme.labelSmall), //header
          const SizedBox(height: 8),

          Text(text, style: bodyTextstyle), //text
          const SizedBox(height: 24),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //arabic
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                cleanDhikr(widget.dhikr.arabicText),
                textDirection: TextDirection.rtl,
                style: AppTextStyles.quranAyah.copyWith(
                  color: cs.onSurface,
                  fontSize: 30,
                  height: 1.8,
                ),
              ),
            ),
            const SizedBox(height: 32),

            //transliteration
            section('Transliteration', dhikr.transliteration),

            //english
            section('Translation', dhikr.englishText),

            //note
            section('Notes', 'Repeat ${dhikr.repeat} times'),

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
