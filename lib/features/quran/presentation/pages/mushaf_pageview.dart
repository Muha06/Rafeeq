import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';

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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: PageView.builder(
          controller: pageController,
          itemCount: 604,
          reverse: true,
          itemBuilder: (context, index) {
            final pageNumber = index + 1;

            return Column(
              children: [
                Image.asset(
                  "assets/pages2/page${pageNumber.toString().padLeft(3, '0')}.png",
                  color: cs.onSurface,
                  filterQuality: FilterQuality.high,
                ),

                Text("Page:$pageNumber "),
              ],
            );
          },
        ),
      ),
    );
  }
}
