import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MushafPageScreen extends StatelessWidget {
  final int initialPage;

  const MushafPageScreen({super.key, required this.initialPage});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: PageView.builder(
          controller: PageController(initialPage: initialPage),
          padEnds: false,
          itemCount: 604,
          reverse: true, // right-to-left scrolling
          itemBuilder: (context, index) {
            final page = index + 1;
            final url =
                'https://raw.githubusercontent.com/Muha06/quran_images/main/$page.png';

            return CachedNetworkImage(
              imageUrl: url,
              color: cs.onSurface,
              filterQuality: FilterQuality.high,

              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Center(
                child: Text(
                  'Page $page missing',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              fit: BoxFit.contain,
            );
          },
        ),
      ),
    );
  }
}
