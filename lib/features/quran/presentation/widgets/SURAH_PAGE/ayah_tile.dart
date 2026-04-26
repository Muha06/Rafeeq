import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/core/themes/app_text_style.dart';
import 'package:rafeeq/core/helpers/snackbars.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/Quran/quran_notifier_provider.dart';
import 'package:rafeeq/features/quran/domain/entities/ayah.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/ayah_of_the_day.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/ayah_share_cotroller_provider.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/surah_settings_provider.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/quran_bookmark.dart';

class AyahTile extends ConsumerStatefulWidget {
  final String surahNameTranslit;
  final Ayah ayah;
  final int ayahNumber;

  const AyahTile({
    super.key,
    required this.ayahNumber,
    required this.surahNameTranslit,
    required this.ayah,
  });

  @override
  ConsumerState<AyahTile> createState() => _AyahTileState();
}

class _AyahTileState extends ConsumerState<AyahTile> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final ayahNumber = widget.ayahNumber;

    final ayah = widget.ayah;
    final bookmarkId = ayah.verseKey;

    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Controls section
          Card(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${ayah.surahId}: ${ayahNumber.toString()}',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelLarge,
                  ),
                  const Spacer(),

                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () async {
                      try {
                        final ayahSurah = ref.read(
                          ayahSurahProvider(ayah.surahId),
                        );

                        final bookmark = QuranBookmarkEntity(
                          id: bookmarkId,
                          surahId: ayah.surahId,
                          surahEnglishName:
                              ayahSurah?.nameTransliteration ?? '',
                          ayahNumber: ayahNumber,
                          createdAt: DateTime.now(),
                        );

                        //toggle
                        final isBookmarked = await ref
                            .read(quranBookmarksProvider.notifier)
                            .toggle(bookmark);

                        AppSnackBar.showSimple(
                          context: context,
                          message: isBookmarked
                              ? 'Added to bookmarks'
                              : 'Removed from bookmars',
                        );
                      } catch (e) {
                        AppSnackBar.showSimple(
                          context: context,
                          message:
                              "Failed to bookmark ayah. Please try again later",
                        );
                      }
                    },
                    icon: Consumer(
                      builder: (context, ref, child) {
                        final isBookmarked = ref.watch(
                          isQuranBookmarkedProvider(bookmarkId),
                        );

                        return PhosphorIcon(
                          isBookmarked
                              ? PhosphorIcons.bookBookmark(
                                  PhosphorIconsStyle.fill,
                                )
                              : PhosphorIcons.bookBookmark(
                                  PhosphorIconsStyle.light,
                                ),
                          size: 22,
                          color: isBookmarked ? cs.primary : null,
                        );
                      },
                    ),
                  ),

                  //share
                  Builder(
                    builder: (btnCtx) => IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () async {
                        final surahName = widget.surahNameTranslit;

                        final controller = ref.read(
                          ayahShareControllerProvider,
                        );

                        final text = controller.buildText(
                          englishText: ayah.textEnglish,
                          arabicText: ayah.textArabic,
                          ayahNumber: ayahNumber,
                          surahId: ayah.surahId,
                          surahName: surahName,
                          includeTranslation: ref
                              .read(surahSettingsProvider)
                              .showTranslation,
                        );

                        await controller.share(context: btnCtx, text: text);
                      },
                      icon: PhosphorIcon(
                        PhosphorIcons.share(PhosphorIconsStyle.light),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          //Content section
          Consumer(
            builder: (context, ref, child) {
              final settings = ref.watch(surahSettingsProvider);

              final showTranslation = settings.showTranslation;
              final arabicFontSize = settings.arabicFontSize;
              final translationFontSize = settings.translationFontSize;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // arabic text (right)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      ayah.textArabic,
                      textDirection: TextDirection.rtl,
                      style: AppTextStyles.quranAyah.copyWith(
                        fontSize: arabicFontSize,
                        color: cs.onSurface,
                      ),
                    ),
                  ),

                  // TRANSLATIONS
                  if (showTranslation) ...[
                    const SizedBox(height: 20),
                    _TranslationSection(
                      label: 'English',
                      ayahText: ayah.textEnglish,
                      translationFontSize: translationFontSize,
                    ),
                    const SizedBox(height: 16),

                    _TranslationSection(
                      label: 'Swahili',
                      ayahText: ayah.textSwahili,
                      translationFontSize: translationFontSize,
                    ),
                    const SizedBox(height: 20),
                  ],

                  //Transliterations
                  if (settings.showTranslit) ...[
                    _TranslationSection(
                      label: 'Transliteration',
                      ayahText: ayah.transliteration,
                      translationFontSize: translationFontSize,
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TranslationSection extends StatelessWidget {
  const _TranslationSection({
    required this.label,
    this.translationFontSize,
    required this.ayahText,
  });

  final String label;
  final String ayahText;
  final double? translationFontSize;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        //label
        Text(label, style: tt.bodySmall),

        const SizedBox(height: 0),

        Text(
          ayahText,
          textAlign: TextAlign.left,
          style: tt.bodyMedium!.copyWith(fontSize: translationFontSize),
        ),
      ],
    );
  }
}
