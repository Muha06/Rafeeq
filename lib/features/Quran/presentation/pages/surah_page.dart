import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/animations/slide_fade_wrapper.dart';
import 'package:rafeeq/core/functions/clean_arabic_text.dart';
import 'package:rafeeq/core/themes/app_colors.dart';
import 'package:rafeeq/features/Quran/domain/entities/ayah.dart';
import 'package:rafeeq/features/Quran/domain/entities/last_read_ayah.dart';
import 'package:rafeeq/features/Quran/domain/entities/surah.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/fetch_ayah_provider.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/surah_preferences_provider.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class FullSurahPage extends ConsumerStatefulWidget {
  final Surah surah;

  const FullSurahPage({super.key, required this.surah});

  @override
  ConsumerState<FullSurahPage> createState() => _FullSurahPageState();
}

class _FullSurahPageState extends ConsumerState<FullSurahPage> {
  final ScrollController scrollController = ScrollController();
  double estimatedAyahHeight = 150.0;

  // Throttle last read saving
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    // Add scroll listener
    scrollController.addListener(_onScroll);

    // Check last read after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLastRead();
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  // Called whenever user scrolls
  void _onScroll() {
    if (_isSaving) return;

    _isSaving = true;
    Future.delayed(const Duration(milliseconds: 300), () {
      _saveLastRead();
      _isSaving = false;
    });
  }

  void _saveLastRead() {
    final index = (scrollController.offset / estimatedAyahHeight).floor();
    final ayahNumber = (index.clamp(0, widget.surah.versesCount - 1)) + 1;

    saveLastRead(
      LastReadAyah(surahId: widget.surah.id, ayahNumber: ayahNumber),
    );
    debugPrint('Saved last read: Surah ${widget.surah.id}, Ayah $ayahNumber');
  }

  void _checkLastRead() {
    debugPrint('Checking last read');

    final lastRead = getLastRead(); // synchronous version
    debugPrint('Last read: $lastRead');

    if (lastRead == null) return;

    if (lastRead.surahId == widget.surah.id && scrollController.hasClients) {
      // Show SnackBar with Go button
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Jump to last-read Ayah ${lastRead.ayahNumber}?'),
          action: SnackBarAction(
            label: 'Go',
            onPressed: () => _jumpToAyah(lastRead.ayahNumber),
          ),
          duration: const Duration(seconds: 5),
        ),
      );

      // Auto jump with slight delay so SnackBar is visible
      // Future.delayed(const Duration(milliseconds: 300), () {
      //   _jumpToAyah(lastRead.ayahNumber);
      // });
    }
  }

  void _jumpToAyah(int ayahNumber) {
    final offset = (ayahNumber - 1) * estimatedAyahHeight;
    scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    final ayahsAsync = ref.watch(ayahsFutureProvider(widget.surah.id));

    return Scaffold(
      body: ayahsAsync.when(
        data: (ayahs) => CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: false,
              backgroundColor: theme.scaffoldBackgroundColor,
              toolbarHeight: 60,
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
                      builder: (context) => const SurahSettingsSheet(),
                    );
                  },
                  icon: const Icon(Icons.tune),
                ),
              ],
            ),

            SliverToBoxAdapter(
              child: SurahDetails(surah: widget.surah, isDark: isDark),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final ayah = ayahs[index];
                final isLast = index == ayahs.length - 1;
                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 16.0 : 0),
                  child: SlideFadeWrapper(
                    index: index,
                    child: AyahTile(ayah: ayah),
                  ),
                );
              }, childCount: ayahs.length),
            ),
          ],
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.amber),
        ),
        error: (e, _) => Center(child: Text('Failed to load ayahs: $e')),
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

