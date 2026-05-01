import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
import 'package:rafeeq/features/quran/presentation/pages/surah_page.dart';
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

  @override
  void dispose() {
    _focus.dispose();
    _controller.dispose();
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
        }
      },
      child: SafeArea(
        top: false,
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
                          ref.read(searchSurahTextProvider.notifier).state = '';
                          _focus.requestFocus();
                        },
                      ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        _focus.unfocus();
                      },
                    ),
                  ],
                ),
              ),
              onChanged: (value) {
                ref.read(searchSurahTextProvider.notifier).state = value;
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

                      return InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return FullSurahPage(surah: surah);
                              },
                            ),
                          );

                          RafeeqAnalytics.logScreenView('surah_page');
                        },
                        child: SurahTile(
                          surah: surah,
                          surahs: surahs,
                          index: realSurahIndex,
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
