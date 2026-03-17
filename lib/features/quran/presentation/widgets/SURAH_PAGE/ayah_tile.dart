import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
 import 'package:rafeeq/core/themes/app_text_style.dart';
import 'package:rafeeq/core/helpers/snackbars.dart';
import 'package:rafeeq/features/quran/domain/entities/ayah.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/ayah_of_the_day.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/ayah_share_cotroller_provider.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/surah_settings_provider.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/quran_bookmark.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/Quran/execution_providers.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';
import 'package:quran/quran.dart' as quran;

class AyahTile extends ConsumerStatefulWidget {
  final Ayah ayah;
  final Surah surah;
  const AyahTile({super.key, required this.ayah, required this.surah});

  @override
  ConsumerState<AyahTile> createState() => _AyahTileState();
}

class _AyahTileState extends ConsumerState<AyahTile> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);
    final settings = ref.watch(surahSettingsProvider);

    final showTranslation = settings.showTranslation;
    final showTranslit = settings.showTranslit;
    final arabicFontSize = settings.arabicFontSize;
    final translationFontSize = settings.translationFontSize;

    final id = '${widget.ayah.surahId}:${widget.ayah.ayahNumber}';
    final bookmarkedIds = ref.watch(bookmarkedIdsProvider);
    final isBookmarked = bookmarkedIds.contains(id);
    final cs = theme.colorScheme;

    final ayah = quran
        .getVerse(widget.surah.id, widget.ayah.ayahNumber, verseEndSymbol: true)
        .replaceAll('۝', '');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Controls section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${widget.ayah.surahId}: ${widget.ayah.ayahNumber.toString()}',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelLarge,
                ),
                const Spacer(),

                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () async {
                    try {
                      final isBookmarked = ref.read(isBookmarkedProvider(id));

                      if (isBookmarked) {
                        // remove bookmark
                        await ref.read(removeQuranBookmarkProvider(id))();

                        AppSnackBar.showSimple(
                          context: context,
                          message: 'Bookmark removed ❌',
                          duration: const Duration(seconds: 3),
                        );

                        return;
                      }

                      // add bookmark
                      final ayahSurah = ref.read(
                        ayahSurahProvider(widget.ayah.surahId),
                      );

                      if (ayahSurah != null) {
                        final bookmark = QuranBookmarkEntity(
                          id: '${widget.ayah.surahId}:${widget.ayah.ayahNumber}',
                          surahId: widget.ayah.surahId,
                          surahEnglishName: ayahSurah.nameTransliteration,
                          ayahNumber: widget.ayah.ayahNumber,
                          createdAt: DateTime.now(),
                        );

                        await ref.read(addQuranBookmarkProvider(bookmark))();
                      }

                      AppSnackBar.showSimple(
                        context: context,
                        message: 'Bookmark added ✅',
                        duration: const Duration(seconds: 3),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Bookmark failed: $e')),
                      );
                    }
                  },
                  icon: PhosphorIcon(
                    isBookmarked
                        ? PhosphorIcons.bookBookmark(PhosphorIconsStyle.fill)
                        : PhosphorIcons.bookBookmark(),
                    size: 22,
                    color: isBookmarked ? cs.primary : cs.onSurfaceVariant,
                  ),
                ),

                //share
                Builder(
                  builder: (btnCtx) => IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () async {
                      final surah = ref.read(
                        ayahSurahProvider(widget.ayah.surahId),
                      );
                      final surahName = surah?.nameTransliteration ?? 'Qur’an';

                      final controller = ref.read(ayahShareControllerProvider);

                      final text = controller.buildText(
                        englishText: widget.ayah.textEnglish,
                        arabicText: widget.ayah.textArabic,
                        ayahNumber: widget.ayah.ayahNumber,
                        surahId: widget.ayah.surahId,
                        surahName: surahName,
                        includeTranslation: ref
                            .read(surahSettingsProvider)
                            .showTranslation,
                      );

                      await controller.share(context: btnCtx, text: text);
                    },
                    icon: PhosphorIcon(
                      PhosphorIcons.share(),
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // arabic text (right)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  ayah.startsWith('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ')
                      ? ayah
                            .replaceFirst(
                              'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                              '',
                            )
                            .trim()
                      : ayah,
                  textDirection: TextDirection.rtl,
                  style: AppTextStyles.quranAyah.copyWith(
                    fontSize: arabicFontSize,
                    color: cs.onSurface,
                  ),
                ),
              ),

              //TRANSLITERATION
              if (showTranslit) ...[
                const SizedBox(height: 20),
                Text(
                  key: const ValueKey('translit'),
                  widget.ayah.transliteration,
                  textAlign: TextAlign.left,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: isDark ? FontWeight.w400 : FontWeight.w500,
                    height: 1.4,
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: translationFontSize,
                  ),
                ),
              ],

              // TRANSLATION
              if (showTranslation) ...[
                const SizedBox(height: 20),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 100),
                  child: Text(
                    key: const ValueKey('translation'),
                    widget.ayah.textEnglish,
                    textAlign: TextAlign.left,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: translationFontSize,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
