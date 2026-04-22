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
  String _query = '';

  @override
  void dispose() {
    _focus.dispose();
    _controller.dispose();
    _controller.clear();
    ref.read(searchSurahTextProvider.notifier).state = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surahs = ref.watch(surahsProvider).value ?? []; // <surahs provider
    final searchSurahText = ref.watch(searchSurahTextProvider);
    final q = searchSurahText.trim().toLowerCase();

    final filtered = q.isEmpty
        ? surahs
        : surahs.where((s) {
            return s.nameTransliteration.toLowerCase().contains(q) ||
                s.nameEnglish.toLowerCase().contains(q) ||
                s.id.toString() == q;
          }).toList();

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          ref.read(searchSurahTextProvider.notifier).state = '';
          _controller.clear();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 12,
          title: TextField(
            focusNode: _focus,
            autofocus: true,
            controller: _controller,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              isDense: true,
              hintText: "Search surah (name / number)…",
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (searchSurahText.trim().isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        _controller.clear();
                        _query = '';
                        ref.read(searchSurahTextProvider.notifier).state = '';
                        _focus.requestFocus();
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      ref.read(searchSurahTextProvider.notifier).state = _query;
                      _focus.unfocus();
                    },
                  ),
                ],
              ),
            ),
            onChanged: (value) {
              _query = value;
            },
            onSubmitted: (value) {
              ref.read(searchSurahTextProvider.notifier).state = _query;
            },
          ),
        ),
        body: GestureDetector(
          onTap: () => _focus.unfocus(),
          child: filtered.isEmpty
              ? const Center(child: Text('No surahs found'))
              : ListView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: filtered.length,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemBuilder: (context, index) {
                    final surah = filtered[index];

                    final realSurahIndex = surahs.indexWhere(
                      (s) => s.id == surah.id,
                    );

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
