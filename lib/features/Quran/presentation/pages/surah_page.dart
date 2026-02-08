import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_state.dart';
import 'package:rafeeq/core/features/audio/providers/audio_controller.dart';
 import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
import 'package:rafeeq/core/widgets/snackbars.dart';
import 'package:rafeeq/features/quran/domain/entities/last_read_ayah.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_ayah_provider.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_surahs_provider.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/last_read_provider.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/surah_settings_provider.dart';
import 'package:rafeeq/features/quran/presentation/widgets/SURAH_PAGE/ayah_tile.dart';
import 'package:rafeeq/features/quran/presentation/widgets/SURAH_PAGE/surah_ayah_dialog.dart';
import 'package:rafeeq/features/quran/presentation/widgets/SURAH_PAGE/surah_details.dart';
import 'package:rafeeq/features/quran/presentation/widgets/SURAH_PAGE/surah_settings_sheet.dart';
import 'package:rafeeq/features/quran_audio/presentation/providers/reciters_provider.dart';
import 'package:rafeeq/features/quran_audio/presentation/providers/surah_audio_providers.dart';
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
  bool _autoOn = false; //whether ticker is running or paused

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
    setState(() {
      _autoOn = true;
    });

    ref.read(surahSettingsProvider.notifier).setAutoScrollEnabled(true);

    const tick = Duration(milliseconds: 500); //duration to wait b4 next scroll

    _autoTimer?.cancel();

    _autoTimer = Timer.periodic(tick, (_) async {
      if (!_autoOn) return;
      if (_autoTickBusy) return; // prevent overlapping animations
      _autoTickBusy = true;

      // ✅ stop if last item is already visible
      if (_isAtEnd()) {
        _exitAutoScroll();
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
  }

  void _pauseAutoScroll() {
    if (!_autoOn) return;
    setState(() => _autoOn = false);

    _autoTimer?.cancel();
    _autoTimer = null;
  }

  void _exitAutoScroll() {
    _autoTimer?.cancel();
    _autoTimer = null;

    ref.read(surahSettingsProvider.notifier).setAutoScrollEnabled(false);

    setState(() => _autoOn = false);
  }

  void _toggleAutoScroll() => _autoOn ? _exitAutoScroll() : _startAutoScroll();

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

    final currentAyahNumber = firstVisible.index;

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

  void _checkLastRead() async {
    final isDark = ref.read(isDarkProvider);

    final lastRead = ref
        .read(lastReadRepositoryProvider)
        .getLastRead(widget.surah.id);

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

          // ref.refresh(lastReadAyahsProvider.future); //refresh last read
        },
      );
    }
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    itemPositionsListener.itemPositions.removeListener(_onVisibleAyahsChanged);

    super.dispose();
  }

  Future<void> playSurahAudio({
    required WidgetRef ref,
    required int surahId,
    required String surahName,
  }) async {
    final reciter = ref.read(selectedReciterProvider);
    final getTrack = ref.read(getSurahAudioTrackProvider);

    final track = await getTrack(
      surahId: surahId,
      surahName: surahName,
      reciter: reciter,
    );

    await ref
        .read(audioControllerProvider.notifier)
        .playUrl(
          id: surahName,
          title: surahName,
          source: AudioSourceType.quranSurah,
          url: track.url,
        );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);
    var surah = widget.surah;

    final surahId = widget.surah.id;
    final ayahsAsync = ref.watch(ayahsFutureProvider(surahId));
    final surahs = ref.watch(surahsFutureProvider).value;

    final showControls = ref.watch(surahSettingsProvider).autoScrollEnabled;

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

        // ✅ reset UI state + provider when leaving page
        ref.read(surahSettingsProvider.notifier).setAutoScrollEnabled(false);
      },
      child: Scaffold(
        bottomNavigationBar: showControls
            ? AutoScrollControlsBar(
                onStart: _startAutoScroll,
                autoOn: _autoOn, //for pause featre
                onExit: _exitAutoScroll,
                onPause: _pauseAutoScroll,
              )
            : null,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          title: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                final list = surahs;
                if (list == null || list.isEmpty) return;

                showSurahAyahPickerDialog(
                  context: context,
                  surahs: list,
                  initialSurahIndex: surah.id - 1,
                  initialAyahIndex: 0,
                  isDark: isDark,
                  onGo: (surahId, ayahNumber) async {
                    final targetSurah = list.firstWhere((s) => s.id == surahId);

                    if (surahId == widget.surah.id) {
                      // same surah: just scroll
                      await _jumpToAyah(ayahNumber, suppressSave: true);
                      return;
                    }

                    // different surah: navigate
                    if (!mounted) return;
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => FullSurahPage(
                          surah: targetSurah,
                          autoScrollAyah: ayahNumber, // ✅ scroll after load
                        ),
                      ),
                    );
                  },
                );
              },

              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                height: kToolbarHeight, // fills AppBar height
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${surah.id}. ${surah.nameTransliteration}",
                      style: theme.textTheme.titleLarge!.copyWith(fontSize: 16),
                    ),
                    const SizedBox(width: 6),
                    const FaIcon(FontAwesomeIcons.chevronDown, size: 16),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: theme.bottomSheetTheme.backgroundColor,
                  isScrollControlled: true,
                  showDragHandle: true,
                  builder: (context) =>
                      SurahSettingsSheet(onToggleAutoScroll: _toggleAutoScroll),
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
                return Column(
                  children: [
                    SurahDetails(surah: surah, isDark: isDark),
                    const SizedBox(height: 8),

                    PlayFullSurahBtn(
                      onPlay: () {
                        playSurahAudio(
                          ref: ref,
                          surahId: surahId,
                          surahName: surah.nameTransliteration,
                        );
                      },
                    ),
                  ],
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
                  onPressed: () {
                    ref.invalidate(ayahsFutureProvider(surahId));
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

class AutoScrollControlsBar extends ConsumerWidget {
  const AutoScrollControlsBar({
    super.key,
    required this.onStart,
    required this.onPause,
    required this.autoOn,
    required this.onExit,
  });

  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onExit;
  final bool autoOn;

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final surahSettings = ref.watch(surahSettingsProvider);
    final surahSettingsNotifier = ref.watch(surahSettingsProvider.notifier);
    var speed = surahSettings.autoScrollSpeed;
    final isDark = ref.watch(isDarkProvider);

    final iconColor = isDark
        ? AppDarkColors.iconSecondary
        : AppLightColors.iconSecondary;
    final fontSize = 16.0;

    return SafeArea(
      bottom: true,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: theme.bottomAppBarTheme.color,
          border: Border(top: BorderSide(color: theme.dividerColor)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //exit speed
            IconButton(
              onPressed: onExit,
              icon: FaIcon(
                FontAwesomeIcons.x,
                color: iconColor,
                size: fontSize,
              ),
            ),

            Expanded(
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //reduce speed
                    IconButton(
                      onPressed: () {
                        surahSettingsNotifier.decreaseSpeed();
                      },
                      icon: FaIcon(
                        FontAwesomeIcons.minus,
                        color: iconColor,
                        size: fontSize,
                      ),
                    ),

                    const SizedBox(width: 8),
                    Text(speed.toString()),
                    const SizedBox(width: 8),

                    //increase speed
                    IconButton(
                      onPressed: () {
                        surahSettingsNotifier.increaseSpeed();
                      },
                      icon: FaIcon(
                        FontAwesomeIcons.plus,
                        color: iconColor,
                        size: fontSize,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //pause
            IconButton(
              onPressed: autoOn ? onPause : onStart,
              icon: FaIcon(
                autoOn ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
                color: iconColor,
                size: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
