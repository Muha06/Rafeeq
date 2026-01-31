import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/clean_arabic_text.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
import 'package:rafeeq/core/widgets/snackbars.dart';
import 'package:rafeeq/features/adhkar/domain/entities/dhikr.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/dhikr_bookmark.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/dhikr/execution_providers.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class AdhkarDetailsPage extends ConsumerStatefulWidget {
  const AdhkarDetailsPage({
    super.key,
    required this.dhikr,
    required this.adhkars,
    required this.assetPath,
    required this.initialIndex,
  });

  final Dhikr dhikr;
  final List<Dhikr> adhkars;
  final int initialIndex;
  final String assetPath;
  @override
  ConsumerState<AdhkarDetailsPage> createState() => _AdhkarDetailsPageState();
}

class _AdhkarDetailsPageState extends ConsumerState<AdhkarDetailsPage> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  void openBottomSheet(Dhikr dhikr) {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      builder: (context) {
        final theme = Theme.of(context);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //title
              Text('Adhkar settings', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              //divider
              Divider(color: theme.dividerColor),
              const SizedBox(height: 8),

              //copy
              ListTile(
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(
                      text:
                          '${dhikr.title} \n ${dhikr.arabic} \n ${dhikr.translation!}',
                    ),
                  );
                  Navigator.pop(context);
                },
                title: Text('Copy Dhikr', style: theme.textTheme.bodyLarge),
                trailing: const Icon(Icons.copy),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final dhikr = widget.adhkars[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(dhikr.title),
        bottom: appBarBottomDivider(context),
        actions: [
          //bookmark
          Consumer(
            builder: (context, ref, child) {
              final bookmarked = ref.watch(
                isDhikrBookmarkedProvider(dhikr.id),
              ); // ✅ watch

              return IconButton(
                onPressed: () async {
                  final bookMark = DhikrBookmark(
                    dhikrId: dhikr.id,
                    title: dhikr.title,
                    assetPath: widget.assetPath,
                    createdAt: DateTime.now(),
                  );

                  final toggle = ref.read(
                    toggleDhikrBookmarkProvider(bookMark),
                  ); // ✅ read
                  final nowBookmarked = await toggle();

                  AppSnackBar.showSimple(
                    context: context,
                    isDark: isDark,
                    message: nowBookmarked
                        ? 'Added dhikr to bookmarks'
                        : 'Removed dhikr from bookmarks',
                  );
                },
                icon: Icon(
                  bookmarked
                      ? Icons.bookmark_added_rounded
                      : Icons.bookmark_add,
                  color: bookmarked
                      ? (isDark
                            ? AppDarkColors.amber
                            : AppLightColors.snackbarSuccessBg)
                      : (isDark
                            ? AppDarkColors.iconSecondary
                            : AppLightColors.iconSecondary),
                ),
              );
            },
          ),

          IconButton(
            onPressed: () async {
              openBottomSheet(dhikr);
            },
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.adhkars.length, 
          onPageChanged: (i) => setState(() => _currentIndex = i),
          itemBuilder: (context, i) {
            final dhikr = widget.adhkars[i];
            return AdhkarDetailsTile(
              key: ValueKey(dhikr.id),
              isDark: isDark,
              dhikr: dhikr,
              textTheme: textTheme,
            );
          },
        ),
      ),
    );
  }
}

class AdhkarDetailsTile extends StatelessWidget {
  const AdhkarDetailsTile({
    super.key,
    required this.isDark,
    required this.dhikr,
    required this.textTheme,
  });

  final bool isDark;
  final Dhikr dhikr;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final TextStyle headerStyle = textTheme.bodySmall!.copyWith(fontSize: 14);

    final TextStyle bodyTextstyle = textTheme.bodyMedium!.copyWith(
      color: isDark ? AppDarkColors.textBody : AppLightColors.textBody,
    );

    Widget section(String title, String? text) {
      final t = (text ?? '').trim();
      if (t.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: headerStyle.copyWith(
              color: isDark
                  ? AppDarkColors.textPrimary
                  : AppLightColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ), //header
          const SizedBox(height: 8),
          Text(t, style: bodyTextstyle), //text
          const SizedBox(height: 24),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isDark
              ? AppDarkColors.darkSurface
              : AppLightColors.lightSurface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: SingleChildScrollView(
          child: SelectionArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //title
                Center(
                  child: Text(
                    dhikr.title,
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium!,
                  ),
                ),
                const SizedBox(height: 20),

                //arabic
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    cleanDhikr(dhikr.arabic),
                    textDirection: TextDirection.rtl,
                    style: textTheme.bodyLarge!.copyWith(fontSize: 28),
                  ),
                ),
                const SizedBox(height: 32),

                //transliteration
                section('Transliteration', dhikr.latin),

                //english
                section('Translation', dhikr.translation),

                //note
                section('Notes', dhikr.notes),

                //benefit
                section('Benefit', dhikr.benefits),

                //fawaid
                if (dhikr.benefits != dhikr.fawaid)
                  section('Fawaid', dhikr.fawaid),

                //source
                if ((dhikr.source ?? '').trim().isNotEmpty) ...[
                  Text('Source:', style: textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Text(
                    dhikr.source!.trim(),
                    style: textTheme.bodySmall!.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
