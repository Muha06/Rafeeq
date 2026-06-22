import 'dart:ui';

import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/core/features/audio/providers/audio_controller.dart';
import 'package:rafeeq/core/helpers/clean_arabic_text.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
import 'package:rafeeq/core/helpers/snackbars.dart';
import 'package:rafeeq/core/themes/app_text_style.dart';
import 'package:rafeeq/features/adhkar_02/domain/entities/dhikr_entity.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/dhikr_bookmark.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/dhikr/dhikr_notifier_provider.dart';
import 'package:vibration/vibration.dart';

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
                  title: Text(dhikr.title, style: theme.textTheme.titleMedium),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(1),
                    child: LinearProgressIndicator(
                      value: (currentIndex + 1) / widget.adhkars.length,
                    ),
                  ),
                ),

                body: Stack(
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
                      left: 16,
                      right: 16,
                      child: _BottomNavBar(dhikr: dhikr),
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingWidget: DhikrFloatingButton(
            count: _dhikrCount,
            total: dhikr.repeat,
            onTap: () async {
              final isCompleting = _dhikrCount + 1 >= dhikr.repeat;

              if (isCompleting) {
                await Vibration.vibrate(
                  pattern: [0, 80, 50, 120],
                  amplitude: 255,
                );
              } else {
                await Vibration.vibrate(
                  duration: 20,
                  amplitude: 150,
                ); // soft normal tap
              }

              setState(() {
                if (_dhikrCount >= dhikr.repeat) {
                  _dhikrCount = 0;
                } else {
                  _dhikrCount++;
                }
              });
            },
          ),
          floatingWidgetHeight: 64,
          floatingWidgetWidth: 64,
          dy: screenHeight - 150,
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

      RafeeqAnalytics.logFeature('bookmarked_dhikr');
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

      await Clipboard.setData(ClipboardData(text: buffer.toString().trim()));

      if (context.mounted) {
        AppSnackBar.showSimple(context: context, message: "Dhikr copied");
      }
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: cs.surface.withAlpha(100),
            border: Border.all(color: cs.outlineVariant.withAlpha(25)),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withAlpha(50),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
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
                    icon: PhosphorIcon(
                      size: 20,
                      color: isBookmarked ? cs.primary : null,
                      PhosphorIcons.bookmark(
                        isBookmarked
                            ? PhosphorIconsStyle.fill
                            : PhosphorIconsStyle.regular,
                      ),
                    ),
                    label: isBookmarked ? 'Saved' : 'Save',
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

                    return _BottomNavItem(
                      icon: audioState.isBuffering
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CupertinoActivityIndicator(),
                            )
                          : PhosphorIcon(
                              isPlaying
                                  ? PhosphorIcons.pause()
                                  : PhosphorIcons.play(),
                              size: 20,
                            ),
                      label: 'Play',
                      onTap: () {
                        audioCtrl.togglePlay(
                          context: context,
                          currentId: dhikr.id.toString(),
                          url: dhikr.audioUrl!,
                          showAudioPlayer: true,
                          title: dhikr.transliteration ?? 'adhkar',
                        );
                      },
                    );
                  },
                ),

              // Copy
              _BottomNavItem(
                icon: PhosphorIcon(PhosphorIcons.copy(), size: 20),
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
    required this.label,
    required this.onTap,
  });

  final Widget icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: double.infinity,
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 28, height: 28, child: Center(child: icon)),

            const SizedBox(height: 2),

            Text(label, style: tt.labelSmall),
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

    final TextStyle bodyTextstyle = textTheme.bodyMedium!.copyWith(
      fontSize: 16,
    );
    final cs = theme.colorScheme;

    Widget section(String title, String? text) {
      final hasValidText = text != null && text.isNotEmpty;

      if (!hasValidText) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textTheme.bodySmall), //header
          const SizedBox(height: 8),

          Text(text, style: bodyTextstyle), //text
          const SizedBox(height: 24),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: SingleChildScrollView(
        child: SelectionArea(
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
                    fontWeight: FontWeight.w700,
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
              color: cs.surfaceContainer,
              boxShadow: [
                BoxShadow(
                  color: cs.shadow,
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),

          SizedBox(
            width: 72,
            height: 72,
            child: CircularProgressIndicator(value: progress, strokeWidth: 5),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$count", style: tt.titleLarge),
              Text("/ $total", style: tt.labelMedium),
            ],
          ),
        ],
      ),
    );
  }
}
