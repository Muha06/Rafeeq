import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/reading_position_provider.dart';

class MushafPageView extends ConsumerStatefulWidget {
  final int page;

  const MushafPageView({super.key, required this.page});

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
    debugPrint("User swiped to page $newPage");

    _currentPage = newPage;
    //update provider
    ref.read(readingPositionProvider.notifier).updateFromPage(newPage);

    debugPrint(
      "${ref.read(readingPositionProvider.notifier).currentSurah?.nameTransliteration}",
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final page = ref.watch(readingPositionProvider)?.page ?? 1;

    return Column(
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
    );
  }
}
