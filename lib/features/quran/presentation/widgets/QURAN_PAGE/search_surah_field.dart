import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_surahs_provider.dart';

class SearchSurahField extends ConsumerStatefulWidget {
  const SearchSurahField({super.key});

  @override
  ConsumerState<SearchSurahField> createState() => _SearchSurahFieldState();
}

class _SearchSurahFieldState extends ConsumerState<SearchSurahField> {
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
    final searchSurahText = ref
        .watch(searchSurahTextProvider)
        .trim()
        .toLowerCase();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(999),
      borderSide: const BorderSide(color: Colors.transparent),
    );

    final hasInput = searchSurahText.trim().isNotEmpty;

    return TextField(
      focusNode: _focus,
      controller: _controller,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        isDense: true,
        prefixIcon: IconButton(
          onPressed: () {
            _focus.unfocus();
          },
          icon: Icon(HugeIconsSolid.search01, color: cs.onSurfaceVariant),
        ),
        hintText: "Search Surahs...",
        filled: true,
        fillColor: cs.surface,
        enabledBorder: border,

        focusedBorder: border,
        suffixIcon: hasInput
            ? IconButton(
                icon: const Icon(Icons.cancel),
                onPressed: () {
                  _controller.clear();
                  ref.read(searchSurahTextProvider.notifier).state = '';
                  _focus.requestFocus();
                },
              )
            : null,
      ),
      onChanged: (value) {
        ref.read(searchSurahTextProvider.notifier).state = value;
      },
    );
  }
}
