import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/functions/clean_arabic_text.dart';
import 'package:rafeeq/core/themes/app_colors.dart';
import 'package:rafeeq/features/Quran/domain/entities/ayah.dart';
import 'package:rafeeq/features/Quran/domain/entities/last_read_ayah.dart';
import 'package:rafeeq/features/Quran/domain/entities/surah.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/fetch_ayah_provider.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/surah_preferences_provider.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class FullSurahPage extends ConsumerStatefulWidget {
  final Surah surah;

  const FullSurahPage({super.key, required this.surah});

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

  @override
  void initState() {
    super.initState();

    // Listen to which ayahs are visible -> called whenever user scrolls
    itemPositionsListener.itemPositions.addListener(_onVisibleAyahsChanged);

    // Check last read after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLastRead();
    });
  }

  @override
  void dispose() {
    super.dispose();
    itemPositionsListener.itemPositions.removeListener(_onVisibleAyahsChanged);
    ScaffoldMessenger.of(context).clearSnackBars();
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

    if (currentAyahNumber != _lastSavedAyah) {
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

  void _jumpToAyah(int ayahNumber) {
    itemScrollController.scrollTo(
      index: ayahNumber - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _checkLastRead() {
    final isDark = ref.watch(isDarkProvider);

    final lastRead = getLastRead(); // synchronous version
    debugPrint('Last read: $lastRead');

    if (lastRead == null) return;

    if (!mounted) return;

    if (lastRead.surahId == widget.surah.id) {
      // Show SnackBar with Go button
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: isDark ? Colors.black : Colors.white,
          persist: false,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Text(
            'Jump to last-read Ayah ${lastRead.ayahNumber}?',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          action: SnackBarAction(
            label: 'Go',
            textColor: isDark ? Colors.amber : Colors.blue,
            onPressed: () => _jumpToAyah(lastRead.ayahNumber),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    final ayahsAsync = ref.watch(ayahsFutureProvider(widget.surah.id));

    return Scaffold(
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
                child: CircularProgressIndicator(color: AppColors.amber),
              ),
              error: (e, _) => Center(child: Text('Failed to load ayahs: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

class SurahSettingsSheet extends StatelessWidget {
  const SurahSettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer(
      builder: (context, ref, _) {
        final showTranslation = ref.watch(showTranslationProvider);
        final arabicFontSize = ref.watch(arabicFontSizeProvider);
        final translationFontSize = ref.watch(translationFontSizeProvider);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  height: 6,
                  width: 48,
                  decoration: BoxDecoration(
                    color: AppColors.lightTextSecondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Center(
                child: Text(
                  'Full Surah Settings',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 16),

              Divider(color: theme.dividerColor),
              const SizedBox(height: 16),

              // Show/hide translation
              SwitchListTile(
                value: showTranslation,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Show Translation',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    // color: isDark ? Colors.white : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                onChanged: (value) {
                  ref.read(showTranslationProvider.notifier).state = value;
                },
              ),

              const SizedBox(height: 8),

              // Font size slider (Arabic)
              Text(
                'Arabic Font Size: ${arabicFontSize.toInt()}',
                style: theme.textTheme.bodySmall!.copyWith(fontSize: 16),
              ),
              Slider(
                min: 16,
                max: 36,
                value: arabicFontSize,
                onChanged: (value) {
                  ref.read(arabicFontSizeProvider.notifier).state = value;
                },
              ),

              // Font size slider (Translation)
              if (showTranslation) ...[
                Text(
                  'Translation Font Size: ${translationFontSize.toInt()}',
                  style: theme.textTheme.bodySmall!.copyWith(fontSize: 16),
                ),
                Slider(
                  min: 12,
                  max: 28,
                  value: translationFontSize,
                  onChanged: (value) {
                    ref.read(translationFontSizeProvider.notifier).state =
                        value;
                  },
                ),
              ],

              //divider
              Divider(color: theme.dividerColor),
              const SizedBox(height: 0),

              //cancel btn
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Close',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SurahDetails extends StatelessWidget {
  const SurahDetails({super.key, required this.surah, required this.isDark});
  final Surah surah;
  final bool isDark;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
          clipBehavior: Clip.hardEdge,
          child: Image.asset(
            'assets/images/kaaba.jpeg',
            height: 80,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 12),

        //Surah title
        Text(
          surah.nameEnglish,
          style: theme.textTheme.titleLarge!.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 12),

        Text(
          '${surah.versesCount.toString()} Verses',
          style: theme.textTheme.bodySmall!,
        ),
        const SizedBox(height: 12),

        Image.asset(
          isDark
              ? 'assets/images/bismillah_dark.png'
              : 'assets/images/bismillah_1.png',
          height: 48,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class AyahTile extends ConsumerWidget {
  final Ayah ayah;

  const AyahTile({super.key, required this.ayah});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);
    final showTranslation = ref.watch(showTranslationProvider);
    final arabicFontSize = ref.watch(arabicFontSizeProvider);
    final translationFontSize = ref.watch(translationFontSizeProvider);

    return AnimatedSize(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeIn,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // verse number (top-left)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                ayah.ayahNumber.toString(),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.amber,
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // arabic text (right)
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                cleanAyah(ayah.textArabic),
                textDirection: TextDirection.rtl,
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontWeight: isDark ? FontWeight.w300 : FontWeight.w400,
                  fontSize: arabicFontSize,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Translation
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: showTranslation
                  ? Text(
                      key: const ValueKey('translation'),
                      ayah.textEnglish,
                      textAlign: TextAlign.left,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: isDark ? FontWeight.w400 : FontWeight.w500,
                        fontSize: translationFontSize,
                      ),
                    )
                  : const SizedBox.shrink(key: ValueKey('hide')),
            ),
            if (showTranslation) const SizedBox(height: 20),

            Divider(color: theme.dividerColor),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_add_outlined, size: 22),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share, size: 22),
                ),
                IconButton(
                  onPressed: () {
                    saveLastRead(
                      LastReadAyah(
                        surahId: ayah.surahId,
                        ayahNumber: ayah.ayahNumber,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Saved Ayah ${ayah.ayahNumber} as last read',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.bookmark, size: 22),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
