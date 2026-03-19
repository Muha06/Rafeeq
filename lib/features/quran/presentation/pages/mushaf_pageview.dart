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
    final newPage = index + 1;
    debugPrint("User swiped to page $newPage");

    //update provider
    ref.read(readingPositionProvider.notifier).updateFromPage(newPage);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return PageView.builder(
      controller: pageController,
      itemCount: 604,
      reverse: true,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        final pageNumber = index + 1; // adjust if reverse
        return Image.asset(
          "assets/pages2/page${pageNumber.toString().padLeft(3, '0')}.png",
          color: cs.onSurface,
          filterQuality: FilterQuality.high,
        );
      },
    );
  }
}
