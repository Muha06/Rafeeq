import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran/presentation/pages/mushaf_page.dart';

class MushafScrollView extends ConsumerWidget {
  final int startPage;
  final int endPage;

  const MushafScrollView({
    super.key,
    required this.startPage,
    required this.endPage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quran Scrollable Mushaf')),
      body: ListView.builder(
        itemCount: endPage - startPage + 1,
        itemBuilder: (context, index) {
          final pageNumber = startPage + index;
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
            ), // space between pages
            child: MushafPageUI(pageNumber: pageNumber),
          );
        },
      ),
    );
  }
}
