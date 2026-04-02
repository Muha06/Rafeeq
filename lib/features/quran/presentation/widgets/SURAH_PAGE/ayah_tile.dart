import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/core/themes/app_text_style.dart';
import 'package:rafeeq/core/helpers/snackbars.dart';
import 'package:rafeeq/features/quran/domain/entities/ayah.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/ayah_of_the_day.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/ayah_share_cotroller_provider.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/surah_settings_provider.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/quran_bookmark.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/Quran/execution_providers.dart';

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
    final ayahId = '${ayah.surahId}:$ayahNumber';

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
                        final isBookmarked = ref.read(
                          isBookmarkedProvider(ayahId),
                        );

                        if (isBookmarked) {
                          // remove bookmark
                          await ref.read(removeQuranBookmarkProvider(ayahId))();

                          AppSnackBar.showSimple(
                            context: context,
                            message: 'Bookmark removed ❌',
                            duration: const Duration(seconds: 3),
                          );

                          return;
                        }

                        // add bookmark
                        final ayahSurah = ref.read(
                          ayahSurahProvider(ayah.surahId),
                        );

                        if (ayahSurah != null) {
                          final bookmark = QuranBookmarkEntity(
                            id: '${ayah.surahId}:$ayahNumber',
                            surahId: ayah.surahId,
                            surahEnglishName: ayahSurah.nameTransliteration,
                            ayahNumber: ayahNumber,
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
                    icon: Consumer(
                      builder: (context, ref, child) {
                        final bookmarkedIds = ref.watch(bookmarkedIdsProvider);
                        final isBookmarked = bookmarkedIds.contains(ayahId);
                        return PhosphorIcon(
                          isBookmarked
                              ? PhosphorIcons.bookBookmark(
                                  PhosphorIconsStyle.fill,
                                )
                              : PhosphorIcons.bookBookmark(),
                          size: 22,
                          color: isBookmarked
                              ? cs.primary
                              : cs.onSurfaceVariant,
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
                        PhosphorIcons.share(),
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

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

                  // TRANSLATION
                  if (showTranslation) ...[
                    const SizedBox(height: 20),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 100),
                      child: Text(
                        key: const ValueKey('translation'),
                        ayah.textEnglish,
                        textAlign: TextAlign.left,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          fontSize: translationFontSize,
                        ),
                      ),
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
