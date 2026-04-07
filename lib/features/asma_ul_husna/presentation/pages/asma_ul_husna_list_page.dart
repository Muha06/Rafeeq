import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/asma_ul_husna/presentation/providers/asma_ul_husna_provider.dart';

class AllahNamesPage extends ConsumerStatefulWidget {
  const AllahNamesPage({super.key});

  @override
  ConsumerState<AllahNamesPage> createState() => _AllahNamesPageState();
}

class _AllahNamesPageState extends ConsumerState<AllahNamesPage> {
  String _query = '';

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
          error: (e, _) => _ErrorState(
            message: "Couldn’t load names. Check your internet and try again.",
            details: e.toString(),
            onRetry: () => ref.invalidate(allahNamesProvider),
          ),
          data: (names) {
            final filtered = names.where((n) {
              if (_query.isEmpty) return true;
              final q = _query.toLowerCase().trim();

              return n.arabic.trim().contains(_query) ||
                  n.transliteration.trim().toLowerCase().contains(q) ||
                  n.meaningEn.trim().toLowerCase().contains(q) ||
                  n.number.toString() == _query;
            }).toList();

            if (filtered.isEmpty) {
              return const _EmptyState(
                title: "No matches",
                subtitle: "Try a different keyword (or search by number).",
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final n = filtered[i];
                return _AllahNameTile(
                  number: n.number,
                  arabic: n.arabic,
                  transliteration: n.transliteration,
                  meaning: n.meaningEn,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _AllahNameTile extends ConsumerWidget {
  final int number;
  final String arabic;
  final String transliteration;
  final String meaning;

  const _AllahNameTile({
    required this.number,
    required this.arabic,
    required this.transliteration,
    required this.meaning,
  });

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NumberBadge(number: number),
            const SizedBox(width: 12),

            // Main content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Arabic
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      arabic,
                      textDirection: TextDirection.rtl,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                        height: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Transliteration
                  Text(transliteration, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 6),

                  // Meaning
                  Text(meaning, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NumberBadge extends ConsumerWidget {
  final int number;
  const _NumberBadge({required this.number});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: cs.surfaceContainerHighest,
      ),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w800,
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

    return TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: theme.textTheme.bodySmall,
      decoration: InputDecoration(
        hintText: hintText,
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
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_alt_off_rounded,
              size: 34,
              color: theme.iconTheme.color,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall!.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final String details;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.details,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 40,
              color: theme.colorScheme.onSurface.withAlpha(89),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
