import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/helpers/app_haptics.dart';
import 'package:rafeeq/core/helpers/ayah_share_cotroller_provider.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
import 'package:rafeeq/core/widgets/app_drag_handle.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/dhikr_bookmark.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/quran_bookmark.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_ayah_provider.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/surah_settings_provider.dart';
import 'package:rafeeq/features/quran/presentation/share/services/ayah_share_service.dart';
import 'package:rafeeq/features/quran/presentation/share/widgets/share_ayah_sheet.dart';

class BookmarkActionBottomSheet extends ConsumerWidget {
  const BookmarkActionBottomSheet({
    super.key,
    this.quranBookmark,
    this.dhikrBookmark,
    required this.onDeleteBookmark,
  });

  final QuranBookmarkEntity? quranBookmark;
  final DhikrBookmark? dhikrBookmark;
  final VoidCallback onDeleteBookmark;

  @override
  Widget build(BuildContext context, ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppDragHandle(),

              const SizedBox(height: 12),

              _ActionTile(
                icon: HugeIconsStroke.delete03,
                title: 'Delete',
                subtitle: 'This can’t be undone',
                onTap: onDeleteBookmark,
              ),

              if (quranBookmark != null)
                _ActionTile(
                  icon: HugeIconsStroke.share01,
                  title: 'Share ayah',
                  subtitle: 'Send this verse to others',
                  onTap: () async {
                    AppHaptics.selection();

                    final surahName = quranBookmark!.surahName;
                    final surahId = quranBookmark!.surahId;

                    final type = await showAyahShareSheet(context);

                    // User dismissed the sheet.
                    if (!context.mounted || type == null) return;

                    final ayahs = await ref.read(ayahsProvider(surahId).future);

                    final ayah = ayahs.firstWhere(
                      (ayah) => ayah.surahId == surahId,
                    );

                    switch (type) {
                      case AyahShareType.image:
                        final ayahShareService = AyahShareService();

                        await ayahShareService.shareAyah(
                          context: context,
                          ayah: ayah,
                          surahName: surahName,
                        );

                      case AyahShareType.text:
                        final controller = ref.read(shareControllerProvider);

                        final text = controller.buildText(
                          englishText: ayah.textEnglish,
                          arabicText: ayah.textArabic,
                          ayahNumber: ayah.ayahNumber,
                          surahId: ayah.surahId,
                          surahName: surahName,
                          includeTranslation: ref
                              .read(surahSettingsProvider)
                              .showTranslation,
                        );

                        await controller.share(context: context, text: text);
                    }

                    RafeeqAnalytics.logFeature('share-ayah');
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends ConsumerWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, ref) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ListTile(
        leading: PhosphorIcon(icon),
        title: Text(title),
        subtitle: Text(subtitle!),
      ),
    );
  }
}
