import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/clean_arabic_text.dart';
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
    required this.assetPath,
    this.adhkars,
    this.initialIndex,
  });

  final Dhikr dhikr;
  final String assetPath;
  final List<Dhikr>? adhkars;
  final int? initialIndex;
  @override
  ConsumerState<AdhkarDetailsPage> createState() => _AdhkarDetailsPageState();
}

class _AdhkarDetailsPageState extends ConsumerState<AdhkarDetailsPage> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    if (widget.initialIndex != null) {
      _currentIndex = widget.initialIndex!;
      _pageController = PageController(initialPage: _currentIndex);
    }
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

    final dhikr = widget.adhkars?[_currentIndex] ?? widget.dhikr;
    final cs = theme.colorScheme;

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

                  if (context.mounted) {
                    AppSnackBar.showSimple(
                      context: context,
                      isDark: isDark,
                      message: nowBookmarked
                          ? 'Added dhikr to bookmarks'
                          : 'Removed dhikr from bookmarks',
                    );
                  }
                },
                icon: Icon(
                  bookmarked
                      ? Icons.bookmark_added_outlined
                      : Icons.bookmark_add_outlined,
                  color: bookmarked ? cs.primary : cs.onSurface,
                  size: 28,
                ),
              );
            },
          ),

          IconButton(
            onPressed: () async {
              Clipboard.setData(
                ClipboardData(
                  text:
                      '${dhikr.title} \n ${dhikr.arabic} \n ${dhikr.translation!}',
                ),
              );
            },
            icon: const Icon(Icons.copy_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: widget.initialIndex != null
            ? PageView.builder(
                controller: _pageController,
                itemCount: widget.adhkars?.length,
                onPageChanged: (i) => setState(() => _currentIndex = i),
                itemBuilder: (context, i) {
                  final actaulDhikr = widget.adhkars?[i] ?? dhikr;
                  return AdhkarDetailsTile(
                    key: ValueKey(dhikr.id),
                    isDark: isDark,
                    dhikr: actaulDhikr,
                    textTheme: textTheme,
                  );
                },
              )
            : AdhkarDetailsTile(
                key: ValueKey(dhikr.id),
                isDark: isDark,
                dhikr: dhikr,
                textTheme: textTheme,
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
    final TextStyle headerStyle = textTheme.labelMedium!;

    final TextStyle bodyTextstyle = textTheme.bodyMedium!.copyWith(
      fontSize: 20,
    );
    final cs = Theme.of(context).colorScheme;

    Widget section(String title, String? text) {
      final t = (text ?? '').trim();
      if (t.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: headerStyle.copyWith(fontWeight: FontWeight.bold),
          ), //header
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
            borderRadius: BorderRadius.circular(24),
            color: cs.surface,
          ),
          child: SelectionArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  Text('Source:', style: headerStyle),
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
