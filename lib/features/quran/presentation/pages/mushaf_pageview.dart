import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/show_audio_controls_bar_provider.dart';
import 'package:rafeeq/features/quran/presentation/widgets/SURAH_PAGE/quran_audio_controls_bar.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

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
  static const int _totalPages = 604;

  late final PageController pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.page;
    pageController = PageController(initialPage: widget.page - 1);
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    pageController.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  Future<void> _showPagePicker() async {
    final selectedPage = await showMushafPagePickerDialog(
      context: context,
      initialPage: _currentPage,
    );

    if (selectedPage == null || !mounted || selectedPage == _currentPage) {
      return;
    }

    await pageController.animateToPage(
      selectedPage - 1,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final iconStyle = PhosphorIconsStyle.light;

    final showAudioControls = ref.watch(showAudioControlsProvider);

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: _showPagePicker,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Page $_currentPage',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 6),
                PhosphorIcon(PhosphorIcons.caretDown(iconStyle), size: 18),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: showAudioControls
          ? const AudioControlsBarColorWrapper(child: AudioControlsSection())
          : null,
      body: PageView.builder(
        controller: pageController,
        itemCount: _totalPages,
        reverse: true,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index + 1;
          });
        },
        itemBuilder: (context, index) {
          final pageNumber = index + 1;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Image.asset(
              'assets/images/quran/pages/$pageNumber.png',
              color: cs.onSurface,
              filterQuality: FilterQuality.high,
              alignment: Alignment.topCenter,
            ),
          );
        },
      ),
    );
  }
}

Future<int?> showMushafPagePickerDialog({
  required BuildContext context,
  required int initialPage,
}) async {
  int selectedPage = initialPage.clamp(1, _MushafPageViewState._totalPages);
  final controller = FixedExtentScrollController(initialItem: selectedPage - 1);

  final pickedPage = await showDialog<int>(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          final theme = Theme.of(context);
          final cs = theme.colorScheme;

          return Dialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 24,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 4),
                    Text('Go to page', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 14),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48.0),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: SizedBox(
                          height: 240,
                          child: CupertinoPicker(
                            scrollController: controller,
                            itemExtent: 40,
                            magnification: 1.03,
                            useMagnifier: true,
                            selectionOverlay: null,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                selectedPage = index + 1;
                              });
                            },
                            children: [
                              for (
                                int page = 1;
                                page <= _MushafPageViewState._totalPages;
                                page++
                              )
                                Center(
                                  child: Text(
                                    'Page $page',
                                    style: theme.textTheme.titleMedium,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      'Page $selectedPage',
                      style: theme.textTheme.labelLarge,
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),

                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              Navigator.pop(context, selectedPage);
                            },
                            child: const Text('Go'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );

  controller.dispose();
  return pickedPage;
}
