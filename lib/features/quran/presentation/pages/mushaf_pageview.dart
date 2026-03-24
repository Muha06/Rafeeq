import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/presentation/pages/surah_page.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/reading_position_provider.dart';

class MushafPageView extends ConsumerStatefulWidget {
  final int page;
  final Surah surah;
  final Function(int, {bool suppressSave}) jumpToAyah;
  const MushafPageView({
    super.key,
    required this.page,
    required this.surah,
    required this.jumpToAyah,
  });

  @override
  ConsumerState<MushafPageView> createState() => _MushafPageViewState();
}

class _MushafPageViewState extends ConsumerState<MushafPageView> {
  late PageController pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.page - 1);
    _currentPage = widget.page;
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    final newPage = index + 1;
    debugPrint(
      "User swiped to page $newPage, surah: ${ref.read(readingPositionProvider.notifier).currentSurah?.nameTransliteration}",
    );

    _currentPage = newPage;

    //update provider
    ref.read(readingPositionProvider.notifier).updateFromPage(newPage);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.of(context).pop(_currentPage); // send page back
        }
      },
      child: Scaffold(
        appBar: AppBar(title: AppbarSurahPicker(jumpToAyah: widget.jumpToAyah)),
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: 604,
                reverse: true,
                onPageChanged: onPageChanged,
                itemBuilder: (context, index) {
                  final pageNumber = index + 1;

                  return Image.asset(
                    "assets/pages2/page${pageNumber.toString().padLeft(3, '0')}.png",
                    color: cs.onSurface,
                    filterQuality: FilterQuality.high,
                  );
                },
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Text("Page:$_currentPage "),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
