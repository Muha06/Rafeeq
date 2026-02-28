import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/clean_arabic_text.dart';
import 'package:rafeeq/core/themes/app_text_style.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
import 'package:rafeeq/features/adhkar/domain/entities/dhikr.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class AdhkarDetailsPage extends ConsumerStatefulWidget {
  const AdhkarDetailsPage({
    super.key,
    required this.adhkars,
    required this.title,
  });

  final List<DhikrEntity> adhkars;
  final String title;
  @override
  ConsumerState<AdhkarDetailsPage> createState() => _AdhkarDetailsPageState();
}

class _AdhkarDetailsPageState extends ConsumerState<AdhkarDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final adhkars = widget.adhkars;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: theme.textTheme.labelLarge),
        bottom: appBarBottomDivider(context),
        actions: [
          //bookmark
          // Consumer(
          //   builder: (context, ref, child) {
          //     final bookmarked = ref.watch(
          //       isDhikrBookmarkedProvider(dhikr.id.toString()),
          //     ); // ✅ watch

          //     return IconButton(
          //       onPressed: () async {
          //         final bookMark = DhikrBookmark(
          //           dhikrId: dhikr.id.toString(),
          //           title: dhikr.transliteration,
          //           assetPath: widget.assetPath,
          //           createdAt: DateTime.now(),
          //         );

          //         final toggle = ref.read(
          //           toggleDhikrBookmarkProvider(bookMark),
          //         ); // ✅ read
          //         final nowBookmarked = await toggle();

          //         if (context.mounted) {
          //           AppSnackBar.showSimple(
          //             context: context,
          //             isDark: isDark,
          //             message: nowBookmarked
          //                 ? 'Added dhikr to bookmarks'
          //                 : 'Removed dhikr from bookmarks',
          //           );
          //         }
          //       },
          //       icon: Icon(
          //         bookmarked
          //             ? Icons.bookmark_added
          //             : Icons.bookmark_add_outlined,
          //         color: bookmarked ? cs.primary : cs.onSurface,
          //         size: 24,
          //       ),
          //     );
          //   },
          // ),

          // IconButton(
          //   onPressed: () async {
          //     Clipboard.setData(
          //       ClipboardData(
          //         text:
          //             '${dhikr.translation} \n ${dhikr.arabicText} \n ${dhikr.translation}',
          //       ),
          //     );
          //   },
          //   icon: Icon(Icons.copy_outlined, color: cs.onSurface, size: 24),
          // ),
        ],
      ),
      body: ListView.builder(
        itemCount: adhkars.length,
        itemBuilder: (context, i) {
          final dhikr = adhkars[i];

          return AdhkarDetailsTile(isDark: isDark, dhikr: dhikr);
        },
      ),
    );
  }
}

class AdhkarDetailsTile extends StatelessWidget {
  const AdhkarDetailsTile({
    super.key,
    required this.isDark,
    required this.dhikr,
  });

  final bool isDark;
  final DhikrEntity dhikr;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final TextStyle bodyTextstyle = textTheme.bodyMedium!.copyWith(
      fontSize: 18,
    );
    final cs = theme.colorScheme;

    Widget section(String title, String? text) {
      final t = (text ?? '').trim();
      if (t.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textTheme.bodySmall), //header
          const SizedBox(height: 8),

          Text(t, style: bodyTextstyle), //text
          const SizedBox(height: 24),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: cs.surface,
          ),
          child: SelectionArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //arabic
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    cleanDhikr(dhikr.arabicText),
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.arabicUi.copyWith(
                      // fontSize: 24,
                      height: 1.8,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                //transliteration
                section('Transliteration', dhikr.transliteration),

                //english
                section('Translation', dhikr.translation),

                //note
                section('Notes', 'Repeat ${dhikr.repeat} times'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
