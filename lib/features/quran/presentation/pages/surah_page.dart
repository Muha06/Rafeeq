// ignore_for_file: unused_result

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_state.dart';
import 'package:rafeeq/core/features/audio/providers/audio_controller.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/rafeeq_analytics.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
import 'package:rafeeq/core/helpers/snackbars.dart';
import 'package:rafeeq/features/quran/domain/entities/last_read_ayah.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/presentation/pages/mushaf_pageview.dart';
 import 'package:rafeeq/features/quran/presentation/riverpod/fetch_ayah_provider.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_surahs_provider.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/last_read_provider.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/show_audio_controls_bar_provider.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/surah_settings_provider.dart';
import 'package:rafeeq/features/quran/presentation/widgets/SURAH_PAGE/ayah_tile.dart';
import 'package:rafeeq/features/quran/presentation/widgets/SURAH_PAGE/quran_audio_controls_bar.dart';
import 'package:rafeeq/features/quran/presentation/widgets/SURAH_PAGE/surah_ayah_dialog.dart';
import 'package:rafeeq/features/quran/presentation/widgets/SURAH_PAGE/surah_details.dart';
import 'package:rafeeq/features/quran/presentation/widgets/SURAH_PAGE/surah_settings_sheet.dart';
import 'package:rafeeq/features/quran_audio/presentation/providers/reciters_provider.dart';
import 'package:rafeeq/features/quran_audio/presentation/providers/surah_audio_providers.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/log_ayah_bottomsheet.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:quran/quran.dart' as quran;

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

  int? _currentVisibleAyah;
  int? _lastSavedAyah;

  bool _isSaving = false; // Throttle last read saving
  bool _suppressNextSave = false;
  static const int skipInitialAyahs = 2;
  LastReadAyah? temporaryLastReadAyah;

  Timer? _autoTimer;
  bool _autoOn = false; //whether ticker is running or paused

  bool _autoTickBusy = false;

  @override
  void initState() {
    super.initState();

    itemPositionsListener.itemPositions.addListener(_onVisibleAyahsChanged);
    // _initializeSurah();
  }

  Surah get surah {
    return widget.surah;
  }

  bool _isAtEnd() {
    final currentSurah = surah;

    final positions = itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return false;

    // Your list has: SurahDetails at index 0 + ayahs
    final lastIndex =
        currentSurah.versesCount; // because itemCount = versesCount + 1

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

  Future<void> jumpToAyah(int ayahNumber, {bool suppressSave = false}) async {
    if (!itemScrollController.isAttached) return;

    if (suppressSave) _suppressNextSave = true;

    await itemScrollController.scrollTo(
      index: ayahNumber,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );

    _suppressNextSave = false;
  }

  // Called whenever ayahs items change
  void _onVisibleAyahsChanged() async {
    if (_isSaving) return;
    _isSaving = true;

    final positions = itemPositionsListener.itemPositions.value;

    if (positions.isEmpty) {
      _isSaving = false;
      return;
    }

    // Find first visible item
    final firstVisible = positions
        .where((p) => p.itemTrailingEdge > 0)
        .reduce((min, p) => p.index < min.index ? p : min);

    final currentIndex = firstVisible.index;

    // Skip SurahDetails (index 0)
    if (currentIndex <= 0) {
      _isSaving = false;
      return;
    }

    final ayahs = ref.read(ayahsFutureProvider(surah.id)).value;

    if (ayahs == null || currentIndex > ayahs.length) {
      _isSaving = false;
      return;
    }

    final ayah = ayahs[currentIndex - 1];
    final currentAyahNumber = ayah.ayahNumber;

    // Update temporary last read
    if (!_suppressNextSave &&
        currentAyahNumber != _lastSavedAyah && //only different ayah
        currentAyahNumber < (surah.versesCount - 3) && //skip last ayhs
        currentAyahNumber > skipInitialAyahs) //skip initial
    {
      temporaryLastReadAyah = LastReadAyah(
        surahId: surah.id,
        ayahNumber: currentAyahNumber,
        surahName: surah.nameTransliteration,
        verseCount: surah.versesCount,
        updatedAt: DateTime.now(),
      );

      _lastSavedAyah = currentAyahNumber;
    }

    _currentVisibleAyah = currentAyahNumber;

    _isSaving = false;
  }

  void _checkLastRead() async {
    if (widget.autoScrollAyah != null) return; // dont check

    final currentSurah = surah;

    final isDark = ref.read(isDarkProvider);

    final lastRead = ref
        .read(lastReadRepositoryProvider)
        .getLastRead(currentSurah.id);

    if (lastRead == null) return;

    if (!mounted) return;

    if (lastRead.surahId == currentSurah.id) {
      // Show SnackBar with Go button
      AppSnackBar.showAction(
        context: context,
        isDark: isDark,
        message: 'Jump to last-read Ayah ${lastRead.ayahNumber}?',
        actionLabel: 'Go',
        onAction: () async {
          await jumpToAyah(lastRead.ayahNumber, suppressSave: true);
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

    //show cntrols
    ref.read(showAudioControlsProvider.notifier).state = true;

    await ref
        .read(audioControllerProvider.notifier)
        .playUrl(
          id: surahName,
          title: surahName,
          source: AudioSourceType.quranSurah,
          url: track.url,
          showPlayer: false,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final surahId = widget.surah.id;

    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);
    final isconStyle = PhosphorIconsStyle.light;

    final ayahsAsync = ref.watch(ayahsFutureProvider(surahId));

    final showAudioControls = ref.watch(showAudioControlsProvider);
    final showSpeedControls = ref
        .watch(surahSettingsProvider)
        .autoScrollEnabled;

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
        bottomNavigationBar: (showAudioControls || showSpeedControls)
            ? QuranAudioControlsBar(
                onStart: _startAutoScroll,
                onPause: _pauseAutoScroll,
                autoOn: _autoOn,
                onExit: _exitAutoScroll,
                showAudioControls: showAudioControls,
                showSpeedControls: showSpeedControls,
              )
            : null,

        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          title: AppbarSurahPicker(jumpToAyah: jumpToAyah, surah: surah),

          actions: [
            //Ayah log
            IconButton(
              icon: PhosphorIcon(PhosphorIcons.floppyDisk(isconStyle)),
              onPressed: () async {
                showAyahLogSheet(context, ref);
              },
            ),

            //Mushaf mode
            IconButton(
              onPressed: () {
                final page = quran.getPageNumber(
                  surahId,
                  _currentVisibleAyah ?? 1,
                ); // first ayah page

                AppNav.push(
                  context,
                  MushafPageView(
                    page: page,
                    surah: surah,
                    jumpToAyah: jumpToAyah,
                  ),
                );
              },
              visualDensity: VisualDensity.compact,
              icon: PhosphorIcon(PhosphorIcons.bookOpenText(isconStyle)),
            ),

            //Surah settings
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  showDragHandle: true,
                  builder: (context) =>
                      SurahSettingsSheet(onToggleAutoScroll: _toggleAutoScroll),
                );
              },
              icon: PhosphorIcon(PhosphorIcons.gear(isconStyle)),
            ),
          ],
          bottom: appBarBottomDivider(context),
        ),
        body: ayahsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),

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

          data: (ayahs) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (!mounted) return;

              _checkLastRead();

              if (widget.autoScrollAyah != null) {
                await jumpToAyah(widget.autoScrollAyah!, suppressSave: true);
              }
            });

            return ScrollablePositionedList.builder(
              itemCount: ayahs.length + 1,
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
              scrollOffsetController: scrollOffsetController,
              scrollOffsetListener: scrollOffsetListener,

              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      SurahDetails(surah: surah, isDark: isDark),
                      const SizedBox(height: 8),

                      PlayFullSurahBtn(
                        onPlay: () async {
                          playSurahAudio(
                            ref: ref,
                            surahId: surahId,
                            surahName: surah.nameTransliteration,
                          );

                          await RafeeqAnalytics.logFeature("Play-surah-audio");
                        },
                      ),
                    ],
                  );
                }

                return AyahTile(surah: surah, ayahNumber: index);
              },
            );
          },
        ),
      ),
    );
  }
}

class AppbarSurahPicker extends ConsumerWidget {
  const AppbarSurahPicker({
    super.key,
    required this.surah,
    required this.jumpToAyah,
  });

  final Function(int ayahNumber, {bool suppressSave}) jumpToAyah;
  final Surah surah;

  @override
  Widget build(BuildContext context, ref) {
    // final readingPos = ref.watch(readingPositionProvider);
    // final currentSurahId = readingPos?.surahId ?? 1;

    final theme = Theme.of(context);

    return Consumer(
      builder: (context, ref, child) {
        final surahs = ref.watch(surahsProvider);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (surahs.isEmpty) return;

              showSurahAyahPickerDialog(
                context: context,
                surahs: surahs,
                initialSurahIndex: surah.id - 1,
                initialAyahIndex: 0,
                onGo: (surahId, ayahNumber) async {
                  if (surahId == surah.id) {
                    // same surah: just scroll
                    await jumpToAyah(ayahNumber, suppressSave: true);
                    return;
                  }

                  final newSurah = surahs.firstWhere((s) => s.id == surahId);

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => FullSurahPage(
                        surah: newSurah,
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

                  PhosphorIcon(
                    PhosphorIcons.caretDown(PhosphorIconsStyle.light),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
