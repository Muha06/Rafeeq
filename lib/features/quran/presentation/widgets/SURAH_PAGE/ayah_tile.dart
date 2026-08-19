import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/app_haptics.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/themes/app_text_style.dart';
import 'package:rafeeq/core/helpers/snackbars.dart';
import 'package:rafeeq/core/helpers/app_toast.dart';
import 'package:rafeeq/core/widgets/app_drag_handle.dart';
import 'package:rafeeq/core/widgets/bottom_sheet_action.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/Quran/quran_notifier_provider.dart';
import 'package:rafeeq/features/quran/domain/entities/ayah.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/ayah_of_the_day.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/ayah_share_cotroller_provider.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/surah_settings_provider.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/quran_bookmark.dart';
import 'package:hugeicons_pro/hugeicons.dart';

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
  void _openAyahActionsSheet() {
    AppSheets.showBottomSheet(
      context: context,
      child: AyahActionsSheet(
        ayah: widget.ayah,
        surahNameTranslit: widget.surahNameTranslit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final ayahNumber = widget.ayahNumber;

    final ayah = widget.ayah;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Controls section
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${ayah.surahId}: ${ayahNumber.toString()}',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const Spacer(),

                  IconButton(
                    onPressed: _openAyahActionsSheet,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      HugeIconsSolid.menu09,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
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
        Text(label, style: tt.labelSmall),

        const SizedBox(height: 6),

        Text(
          ayahText,
          textAlign: TextAlign.left,
          style: tt.bodyLarge!.copyWith(fontSize: translationFontSize),
        ),
      ],
    );
  }
}

class AyahActionsSheet extends ConsumerStatefulWidget {
  const AyahActionsSheet({
    super.key,
    required this.ayah,
    required this.surahNameTranslit,
  });
  final Ayah ayah;
  final String surahNameTranslit;

  @override
  ConsumerState<AyahActionsSheet> createState() => _AyahActionsSheetState();
}

class _AyahActionsSheetState extends ConsumerState<AyahActionsSheet> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bookmarkId = widget.ayah.verseKey;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppDragHandle(),

          const SizedBox(height: 12),

          Text(
            "${widget.surahNameTranslit} : ${widget.ayah.id}",
            style: theme.textTheme.labelLarge,
          ),

          const SizedBox(height: 16),

          //Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer(
                builder: (context, ref, child) {
                  final isBookmarked = ref.watch(
                    isQuranBookmarkedProvider(bookmarkId),
                  );

                  return BottomSheetActionBtn(
                    iconData: isBookmarked
                        ? HugeIconsSolid.bookmark01
                        : HugeIconsStroke.bookmark01,
                    label: 'Bookmark',
                    onPressed: () async {
                      try {
                        AppHaptics.selection();

                        final ayahSurah = ref.read(
                          ayahSurahProvider(widget.ayah.surahId),
                        );

                        final bookmark = QuranBookmarkEntity(
                          id: bookmarkId,
                          surahId: widget.ayah.surahId,
                          surahEnglishName:
                              ayahSurah?.nameTransliteration ?? '',
                          ayahNumber: widget.ayah.ayahNumber,
                          createdAt: DateTime.now(),
                        );

                        //toggle
                        final isBookmarked = await ref
                            .read(quranBookmarksProvider.notifier)
                            .toggle(bookmark);

                        if (!context.mounted) return;

                        AppToast.showCompact(
                          context: context,
                          message: isBookmarked
                              ? "Ayah Bookmarked"
                              : "Removed from bookmarks",
                        );
                      } catch (e) {
                        AppSnackBar.showSimple(
                          context: context,
                          message:
                              "Failed to bookmark ayah. Please try again later",
                        );
                      }
                    },
                  );
                },
              ),

              const SizedBox(width: 24),

              BottomSheetActionBtn(
                iconData: HugeIconsStroke.share01,
                label: 'Share',
                onPressed: () async {
                  AppHaptics.selection();

                  final surahName = widget.surahNameTranslit;

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

                  await controller.share(context: context, text: text);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
