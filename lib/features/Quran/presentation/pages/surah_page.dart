import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/features/Quran/domain/entities/last_read_ayah.dart';
import 'package:rafeeq/features/Quran/domain/entities/surah.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/fetch_ayah_provider.dart';
import 'package:rafeeq/features/Quran/presentation/widgets/SURAH_PAGE/ayah_tile.dart';
import 'package:rafeeq/features/Quran/presentation/widgets/SURAH_PAGE/surah_details.dart';
import 'package:rafeeq/features/Quran/presentation/widgets/SURAH_PAGE/surah_settings.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class FullSurahPage extends ConsumerStatefulWidget {
  final Surah surah;
  final int? ayahOfTheDayAyah;

  const FullSurahPage({super.key, required this.surah, this.ayahOfTheDayAyah});

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

  @override
  void initState() {
    super.initState();

    // Listen to which ayahs are visible -> called whenever user scrolls
    itemPositionsListener.itemPositions.addListener(_onVisibleAyahsChanged);

    // Check last read after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLastRead();
      _jumpAyahOfTheDay();
    });
  }

  //when
  void _jumpAyahOfTheDay() {
    if (widget.ayahOfTheDayAyah != null) {
      _jumpToAyah(widget.ayahOfTheDayAyah!);
    }
  }

  void _jumpToAyah(int ayahNumber, {bool suppressSave = false}) {
    if (suppressSave) _suppressNextSave = true;

    itemScrollController.scrollTo(
      index: ayahNumber - 1,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  // Called whenever visible items change
  void _onVisibleAyahsChanged() {
    if (_isSaving) return;
    _isSaving = true;

    final positions = itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    // First fully visible item = current ayah
    final firstVisible = positions
        .where((position) => position.itemLeadingEdge >= 0)
        .reduce(
          (min, position) =>
              position.itemLeadingEdge < min.itemLeadingEdge ? position : min,
        );

    final currentAyahNumber = firstVisible.index + 1;

    //save the ayah
    if (!_suppressNextSave &&
        currentAyahNumber != _lastSavedAyah &&
        currentAyahNumber > skipInitialAyahs) {
      saveLastRead(
        LastReadAyah(surahId: widget.surah.id, ayahNumber: currentAyahNumber),
      );
      _lastSavedAyah = currentAyahNumber;
      debugPrint(
        'Saved last read: Surah ${widget.surah.id}, Ayah $currentAyahNumber',
      );
    }

    _isSaving = false;
  }

  void _checkLastRead() {
    final isDark = ref.watch(isDarkProvider);
    final theme = Theme.of(context);

    final lastRead = getLastRead(widget.surah.id); // synchronous version
    debugPrint('Last read: $lastRead');

    if (lastRead == null) return;
    if (widget.ayahOfTheDayAyah != null) return; //dont check

    if (!mounted) return;

    if (lastRead.surahId == widget.surah.id) {
      // Show SnackBar with Go button
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: isDark ? AppDarkColors.divider : Colors.white,
          // persist: false,
          content: Text(
            'Jump to last-read Ayah ${lastRead.ayahNumber}?',
            style: theme.textTheme.bodySmall!.copyWith(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          action: SnackBarAction(
            label: 'Go',
            textColor: isDark ? Colors.amber : Colors.blue,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              _jumpToAyah(lastRead.ayahNumber, suppressSave: true);
              removeLastReadHive(lastRead.surahId);
            },
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    itemPositionsListener.itemPositions.removeListener(_onVisibleAyahsChanged);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    final ayahsAsync = ref.watch(ayahsFutureProvider(widget.surah.id));

    return PopScope(
      onPopInvokedWithResult: (didPop, result) =>
          ScaffoldMessenger.of(context).hideCurrentSnackBar(),
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
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => const SurahSettingsSheet(),
                );
              },
              icon: const Icon(Icons.tune),
            ),
          ],
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
                  //scrollController: scrollController, // attach scroll controller
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
