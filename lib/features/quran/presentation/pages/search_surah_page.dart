import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_surahs_provider.dart';
import 'package:rafeeq/features/quran/presentation/widgets/QURAN_PAGE/surah_listview.dart';

class SurahSearchPage extends ConsumerStatefulWidget {
  const SurahSearchPage({super.key});

  @override
  ConsumerState<SurahSearchPage> createState() => _SurahSearchPageState();
}

class _SurahSearchPageState extends ConsumerState<SurahSearchPage> {
  final FocusNode _focus = FocusNode();
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _focus.dispose();
    _controller.dispose();
    _controller.clear();
    _debounce?.cancel();
    ref.read(searchSurahTextProvider.notifier).state = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final surahs = ref.watch(surahsProvider).value ?? []; // <surahs provider
    final searchSurahText = ref.watch(searchSurahTextProvider);
    final q = searchSurahText.trim().toLowerCase();

    final filtered = q.isEmpty
        ? surahs
        : surahs.where((s) {
            final t = s.nameTransliteration.toLowerCase();
            final e = s.nameEnglish.toLowerCase();
            final n = s.id.toString();
            return t.contains(q) || e.contains(q) || n == q;
          }).toList();

    if (q.isNotEmpty && filtered.isEmpty) {
      return const Center(child: Text('No surahs found'));
    }

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        ref.read(searchSurahTextProvider.notifier).state = '';
        _controller.clear();
        _focus.requestFocus();
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 12,
          title: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.center,
            child: TextField(
              focusNode: _focus,
              autofocus: true,
              controller: _controller,
              textInputAction: TextInputAction.search,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                isDense: true,
                hintText: "Search surah (name / number)…",
                suffixIcon: searchSurahText.trim().isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () {
                          _controller.clear();
                          ref.read(searchSurahTextProvider.notifier).state = '';
                          _focus.requestFocus();
                        },
                      ),
              ),
              onChanged: (value) {
                _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 100), () {
                  ref.read(searchSurahTextProvider.notifier).state = value;
                });
              },
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () => _focus.unfocus(),
          child: ListView.builder(
            itemCount: filtered.length,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemBuilder: (context, index) {
              final surah = filtered[index];

              final realSurahIndex = surahs.indexWhere((s) => s.id == surah.id);

              return SurahTile(
                surah: surah,
                surahs: surahs,
                index: realSurahIndex,
              );
            },
          ),
        ),
      ),
    );
  }
}
