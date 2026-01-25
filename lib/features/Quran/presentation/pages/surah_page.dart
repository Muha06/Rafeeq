// ignore_for_file: unused_result

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
import 'package:rafeeq/core/widgets/snackbars.dart';
import 'package:rafeeq/features/Quran/domain/entities/last_read_ayah.dart';
import 'package:rafeeq/features/Quran/domain/entities/surah.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/fetch_ayah_provider.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/last_read_provider.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/surah_settings_provider.dart';
import 'package:rafeeq/features/Quran/presentation/widgets/SURAH_PAGE/ayah_tile.dart';
import 'package:rafeeq/features/Quran/presentation/widgets/SURAH_PAGE/surah_details.dart';
import 'package:rafeeq/features/Quran/presentation/widgets/SURAH_PAGE/surah_settings.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class FullSurahPage extends ConsumerStatefulWidget {
  final Surah surah;
  final int? autoScrollAyah;

  const FullSurahPage({super.key, required this.surah, this.autoScrollAyah});

  @override
  ConsumerState<FullSurahPage> createState() => _FullSurahPageState();
}

class _FullSurahPageState extends ConsumerState<FullSurahPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // ScrollablePositionedList controllers
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final scrollOffsetController = ScrollOffsetController();
  final scrollOffsetListener = ScrollOffsetListener.create();

  int? _lastSavedAyah;
  bool _isSaving = false; // Throttle last read saving
  bool _suppressNextSave = false;
  static const int skipInitialAyahs = 2;
  LastReadAyah? temporaryLastReadAyah;

  Timer? _autoTimer;
  bool _autoOn = false;

  bool _autoTickBusy = false;

  bool _isAtEnd() {
    final positions = itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return false;

    // Your list has: SurahDetails at index 0 + ayahs
    final lastIndex =
        widget.surah.versesCount; // because itemCount = versesCount + 1

    final last = positions.where((p) => p.index == lastIndex).toList();
    if (last.isEmpty) return false;

    // If the last item’s trailing edge is within the viewport, we’re basically at the end
    return last.first.itemTrailingEdge <= 1.02; // small tolerance
  }

  void _startAutoScroll() {
    if (_autoOn) return;
    _autoOn = true;

    const tick = Duration(milliseconds: 300); //duration to wait b4 next scroll

    _autoTimer?.cancel();

    _autoTimer = Timer.periodic(tick, (_) async {
      if (!_autoOn) return;
      if (_autoTickBusy) return; // prevent overlapping animations
      _autoTickBusy = true;

      // ✅ stop if last item is already visible
      if (_isAtEnd()) {
        _stopAutoScroll();
        _autoTickBusy = false;
        return;
      }

      final speed = ref.read(surahSettingsProvider).autoScrollSpeed;

      try {
        await scrollOffsetController.animateScroll(
          offset: speed, // relative pixels down
          duration: tick,
          curve: Curves.linear,
        );
      } finally {
        _autoTickBusy = false;
      }
    });

    setState(() {});
  }

  void _stopAutoScroll() {
    _autoOn = false;
    _autoTimer?.cancel();
    _autoTimer = null;
    setState(() {});
  }

  void _toggleAutoScroll() => _autoOn ? _stopAutoScroll() : _startAutoScroll();

  @override
  void initState() {
    super.initState();

    itemPositionsListener.itemPositions.addListener(_onVisibleAyahsChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLastRead();
      _autoScrollToAyah();
    });
  }

  void _autoScrollToAyah() {
    if (widget.autoScrollAyah != null) {
      _jumpToAyah(widget.autoScrollAyah!);
    }
  }

  Future<void> _jumpToAyah(int ayahNumber, {bool suppressSave = false}) async {
    if (suppressSave) _suppressNextSave = true;

    await itemScrollController.scrollTo(
      index: ayahNumber,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );

    _suppressNextSave = false;
  }

  // Called whenever visible items change
  void _onVisibleAyahsChanged() {
    if (_isSaving) return;
    _isSaving = true;

    final positions = itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) {
      _isSaving = false;
      return;
    }

    // Track first fully visible ayah
    final visible = positions.where((p) => p.itemLeadingEdge >= 0).toList();

    if (visible.isEmpty) {
      _isSaving = false;
      return;
    }

    final firstVisible = visible.reduce(
      (min, p) => p.itemLeadingEdge < min.itemLeadingEdge ? p : min,
    );

    final currentAyahNumber = firstVisible.index + 1;

    // Update temporary last read if needed
    if (!_suppressNextSave &&
        currentAyahNumber != _lastSavedAyah &&
        currentAyahNumber > skipInitialAyahs &&
        currentAyahNumber < (widget.surah.versesCount - 3)) {
      temporaryLastReadAyah = LastReadAyah(
        surahId: widget.surah.id,
        ayahNumber: currentAyahNumber,
        surahName: widget.surah.nameTransliteration,
        verseCount: widget.surah.versesCount,
        updatedAt: DateTime.now(),
      );
      _lastSavedAyah = currentAyahNumber;
    }

    _isSaving = false;
  }

  void _checkLastRead() {
    final isDark = ref.read(isDarkProvider);

    final lastRead = ref
        .read(lastReadRepositoryProvider)
        .getLastRead(widget.surah.id);

    debugPrint('Last read: $lastRead');

    if (lastRead == null) return;
    if (widget.autoScrollAyah != null) return; //dont check

    if (!mounted) return;

    if (lastRead.surahId == widget.surah.id) {
      // Show SnackBar with Go button
      AppSnackBar.showAction(
        context: context,
        isDark: isDark,
        message: 'Jump to last-read Ayah ${lastRead.ayahNumber}?',
        actionLabel: 'Go',
        onAction: () async {
          await _jumpToAyah(lastRead.ayahNumber, suppressSave: true);

          ref.invalidate(lastReadAyahsProvider); //refresh last read
        },
      );
    }
  }

  void _openJumpToAyahSheet(BuildContext context) {
    final theme = Theme.of(context);
    final controller = TextEditingController();
    final isDark = ref.watch(isDarkProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final bottom = MediaQuery.of(ctx).viewInsets.bottom;

        return Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, bottom + 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text('Jump to Ayah', style: theme.textTheme.titleMedium),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Ayah number (1 - ${widget.surah.versesCount})',
                  hintStyle: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppDarkColors.border
                          : AppLightColors.border,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.6),
                      width: 1.2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final raw = controller.text.trim();
                        final n = int.tryParse(raw);

                        if (n == null ||
                            n < 1 ||
                            n > widget.surah.versesCount) {
                          AppSnackBar.showSimple(
                            context: ctx,
                            isDark: ref.read(isDarkProvider),
                            message:
                                'Enter a valid ayah (1 - ${widget.surah.versesCount})',
                          );
                          return;
                        }

                        Navigator.pop(ctx); // close sheet
                        await _jumpToAyah(n, suppressSave: true);
                      },
                      child: const Text('Jump'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Text(
                'Tip: You can also use “Go” from last-read snackbar.',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    itemPositionsListener.itemPositions.removeListener(_onVisibleAyahsChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);
    final surah = widget.surah;

    final surahId = widget.surah.id;
    final ayahsAsync = ref.watch(ayahsFutureProvider(surahId));

    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).clearSnackBars();
        //finally save the last read ayah
        if (temporaryLastReadAyah != null) {
          ref
              .read(lastReadRepositoryProvider)
              .saveLastRead(temporaryLastReadAyah!)
              .then((_) {
                ref.refresh(lastReadAyahsProvider);
              });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                surah.nameTransliteration,
                style: theme.textTheme.titleLarge!.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                surah.nameEnglish,
                style: theme.textTheme.bodySmall!.copyWith(height: 1),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                if (!ayahsAsync.hasValue) return;
                _toggleAutoScroll();
              },
              icon: Icon(_autoOn ? Icons.pause : Icons.play_arrow),
            ),

            IconButton(
              onPressed: () {
                _openJumpToAyahSheet(context);
              },
              icon: const Icon(Icons.pin_drop_outlined),
            ),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => const SurahSettingsSheet(),
                );
              },
              icon: const Icon(Icons.tune),
            ),
          ],
          bottom: appBarBottomDivider(context),
        ),

        body: ayahsAsync.when(
          data: (ayahs) => ScrollablePositionedList.builder(
            itemCount: ayahs.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16,
                  ),
                  child: SurahDetails(surah: widget.surah, isDark: isDark),
                );
              }
              return AyahTile(ayah: ayahs[index - 1]);
            },
            itemScrollController: itemScrollController,
            itemPositionsListener: itemPositionsListener,
            scrollOffsetController: scrollOffsetController,
            scrollOffsetListener: scrollOffsetListener,
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppDarkColors.amber),
          ),
          error: (e, _) => Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off_sharp, size: 120),

                Text(
                  'Failed to load surahs.\n Please try again',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: () async {
                    await ref.refresh(ayahsFutureProvider(surahId).future);
                  },
                  child: const Text('Refresh'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
