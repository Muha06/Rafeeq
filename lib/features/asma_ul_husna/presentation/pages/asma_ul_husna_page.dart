import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/widgets/app_state_view.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/entities/translations_enum.dart';
import 'package:rafeeq/features/asma_ul_husna/presentation/providers/asma_ul_husna_provider.dart';
import 'package:rafeeq/features/asma_ul_husna/presentation/widgets/allah_name_tile.dart';

class AllahNamesPage extends ConsumerStatefulWidget {
  const AllahNamesPage({super.key});

  @override
  ConsumerState<AllahNamesPage> createState() => _AllahNamesPageState();
}

class _AllahNamesPageState extends ConsumerState<AllahNamesPage> {
  String _query = '';
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final asyncNames = ref.watch(allahNamesProvider);

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Asma’ul Husna"),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(64),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: _SearchBar(
                hintText: "Search (Arabic / transliteration)",
                onChanged: (v) => setState(() => _query = v.trim()),
              ),
            ),
          ),
        ),
        body: asyncNames.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => const _ErrorState(),
          data: (names) {
            final filtered = names.where((n) {
              if (_query.isEmpty) return true;
              final q = _query.toLowerCase().trim();

              return n.arabic.trim().contains(_query) ||
                  n.transliteration.trim().toLowerCase().contains(q) ||
                  n.translations[AllahNameLanguage.english]!.meaning.contains(
                    q,
                  ) ||
                  n.number.toString() == _query;
            }).toList();

            if (filtered.isEmpty) {
              return const _EmptyState(
                title: "No matches",
                subtitle: "Try a different keyword (or search by number).",
              );
            }

            return Scrollbar(
              interactive: true,
              thickness: 8,
              controller: scrollController,
              child: ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                itemCount: filtered.length,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final n = filtered[i];

                  return AllahNameTile(name: n);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SearchBar extends ConsumerWidget {
  final String hintText;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.hintText, required this.onChanged});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(999),
      borderSide: const BorderSide(color: Colors.transparent),
    );

    return TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: cs.surface,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        prefixIcon: const Icon(Icons.search_rounded),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  const _EmptyState({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return AppStateView(
      icon: Icons.filter_alt_off_rounded,
      title: title,
      message: subtitle,
    );
  }
}

class _ErrorState extends ConsumerWidget {
  const _ErrorState();

  @override
  Widget build(BuildContext context, ref) {
    return AppStateView(
      icon: Icons.wifi_off_rounded,
      title: 'Failed to fetch names',
      message: "Couldn’t load names. Check your internet and try again.",
      buttonText: 'Retry',
      onPressed: () => ref.invalidate(allahNamesProvider),
    );
  }
}
