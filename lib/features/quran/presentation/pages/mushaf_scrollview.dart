import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MushafPageView extends ConsumerStatefulWidget {
  final int page;

  const MushafPageView({super.key, required this.page});

  @override
  ConsumerState<MushafPageView> createState() => _MushafPageViewState();
}

class _MushafPageViewState extends ConsumerState<MushafPageView> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.page - 1);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    final currentPage = index + 1;
    print("User swiped to page $currentPage");

    // Here you can check which Surah is on this page
    // Example:
    // final newSurah = getSurahForPage(currentPage);
    // update your state or Riverpod provider
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      itemCount: 604,
      reverse: true,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        final pageNumber = index + 1; // adjust if reverse
        return Image.asset(
          "assets/pages2/page${pageNumber.toString().padLeft(3, '0')}.png",
          filterQuality: FilterQuality.high,
        );
      },
    );
  }
}
