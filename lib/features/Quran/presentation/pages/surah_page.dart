// ignore_for_file: unused_result

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
import 'package:rafeeq/core/widgets/snackbars.dart';
import 'package:rafeeq/features/Quran/domain/entities/last_read_ayah.dart';
import 'package:rafeeq/features/Quran/domain/entities/surah.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/auto_scroll_provider.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/fetch_ayah_provider.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/last_read_provider.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/surah_settings_provider.dart';
import 'package:rafeeq/features/Quran/presentation/widgets/SURAH_PAGE/ayah_tile.dart';
import 'package:rafeeq/features/Quran/presentation/widgets/SURAH_PAGE/surah_details.dart';
import 'package:rafeeq/features/Quran/presentation/widgets/SURAH_PAGE/surah_content_settings.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class FullSurahPage extends ConsumerStatefulWidget {
  final Surah surah;
  final int? autoScrollAyah;

  const FullSurahPage({super.key, required this.surah, this.autoScrollAyah});

  @override
  ConsumerState<FullSurahPage> createState() => _FullSurahPageState();
}

class _FullSurahPageState extends ConsumerState<FullSurahPage> {
  // ScrollablePositionedList controllers
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  int? _lastSavedAyah;
  bool _isSaving = false; // Throttle last read saving
  bool _suppressNextSave = false;
  static const int skipInitialAyahs = 2;
  LastReadAyah? temporaryLastReadAyah;

  Timer? _autoTimer;
  bool _autoOn = false;
  // double _ayahsPerMinute = 20; // change later with slider if you want

  Duration _intervalFrom(double ayahsPerMinute) {
    final ms = (60000 / ayahsPerMinute).round().clamp(120, 5000);
    return Duration(milliseconds: ms);
  }

  void _startAutoScroll() {
    if (_autoOn) return;
    _autoOn = true;

    final speed = ref.read(surahSettingsProvider).autoScrollSpeed;

    _autoTimer?.cancel();
    final tick = _intervalFrom(speed);

    _autoTimer = Timer.periodic(tick, (_) async {
      final positions = itemPositionsListener.itemPositions.value;
      if (positions.isEmpty) return;

      final visible = positions.where((p) => p.itemLeadingEdge >= 0).toList();
      if (visible.isEmpty) return;

      final firstVisible = visible.reduce(
        (min, p) => p.itemLeadingEdge < min.itemLeadingEdge ? p : min,
      );

      var nextIndex = firstVisible.index + 1;
      final maxIndex = widget.surah.versesCount - 1;
      nextIndex = nextIndex.clamp(0, maxIndex);

      if (nextIndex == maxIndex) {
        _stopAutoScroll();
        return;
      }

      await _jumpToAyah(nextIndex + 1, suppressSave: true);
    });

    setState(() {});
  }

  void _stopAutoScroll() {
    _autoTimer?.cancel();
    _autoTimer = null;
    _autoOn = false;
    setState(() {});
  }

  void _toggleAutoScroll() {
    _autoOn ? _stopAutoScroll() : _startAutoScroll();
  }

  @override
  void initState() {
    super.initState();

    itemPositionsListener.itemPositions.addListener(_onVisibleAyahsChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLastRead();
      _autoScrollToAyah();
    });
  }

  //when
  void _autoScrollToAyah() {
    if (widget.autoScrollAyah != null) {
      _jumpToAyah(widget.autoScrollAyah!);
    }
  }

  Future<void> _jumpToAyah(int ayahNumber, {bool suppressSave = false}) async {
    if (suppressSave) _suppressNextSave = true;

    await itemScrollController.scrollTo(
      index: ayahNumber - 1,
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
    final isDark = ref.watch(isDarkProvider);

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

  @override
  void dispose() {
    _autoTimer?.cancel();
    itemPositionsListener.itemPositions.removeListener(_onVisibleAyahsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    final ayahsAsync = ref.watch(ayahsFutureProvider(widget.surah.id));

    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
                widget.surah.nameTransliteration,
                style: theme.textTheme.titleLarge!.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                widget.surah.nameEnglish,
                style: theme.textTheme.bodySmall!.copyWith(height: 1),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: _toggleAutoScroll,
              icon: Icon(_autoOn ? Icons.pause : Icons.play_arrow),
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
        body: Column(
          children: [
            Expanded(
              child: ayahsAsync.when(
                data: (ayahs) => ScrollablePositionedList.builder(
                  itemCount: ayahs.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return SurahDetails(surah: widget.surah, isDark: isDark);
                    }
                    return AyahTile(ayah: ayahs[index - 1]);
                  },
                  itemScrollController: itemScrollController,
                  itemPositionsListener: itemPositionsListener,
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppDarkColors.amber),
                ),
                error: (e, _) =>
                    Center(child: Text('Failed to load ayahs: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
