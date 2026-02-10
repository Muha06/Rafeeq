import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/presentation/pages/surah_page.dart';

class SurahPagerPage extends ConsumerStatefulWidget {
  final List<Surah> surahs;
  final int initialIndex;

  const SurahPagerPage({
    super.key,
    required this.surahs,
    required this.initialIndex,
  });

  @override
  ConsumerState<SurahPagerPage> createState() => _SurahPagerPageState();
}

class _SurahPagerPageState extends ConsumerState<SurahPagerPage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.surahs.length,
      scrollDirection: Axis.horizontal,
      pageSnapping: true,
      dragStartBehavior: DragStartBehavior.down, // 👈 reacts sooner
      physics: const ClampingScrollPhysics(),
      onPageChanged: (index) {
        // optional: haptics, analytics, preload, etc.
      },
      itemBuilder: (context, index) {
        final surah = widget.surahs[index];

        return FullSurahPage(
          key: ValueKey('surah-${surah.id}'), // important
          surah: surah,
        );
      },
    );
  }
}
