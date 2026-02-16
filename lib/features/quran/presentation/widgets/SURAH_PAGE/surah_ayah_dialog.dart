import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';

Future<void> showSurahAyahPickerDialog({
  required BuildContext context,
  required List<Surah> surahs,
  required bool isDark,
  int initialSurahIndex = 0,
  int initialAyahIndex = 0, // 0-based
  required void Function(int surahId, int ayahNumber)
  onGo, // ayahNumber is 1-based
}) async {
  int surahIndex = initialSurahIndex.clamp(0, surahs.length - 1);
  int ayahIndex = initialAyahIndex;

  final surahController = FixedExtentScrollController(initialItem: surahIndex);
  FixedExtentScrollController ayahController = FixedExtentScrollController(
    initialItem: ayahIndex,
  );

  final theme = Theme.of(context);

  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          final selectedSurah = surahs[surahIndex];
          final ayahCount = selectedSurah.versesCount;

          // keep ayahIndex valid when switching surahs
          if (ayahIndex >= ayahCount) {
            ayahIndex = ayahCount - 1;
            ayahController.dispose();
            ayahController = FixedExtentScrollController(
              initialItem: ayahIndex,
            );
          }

          return Dialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 24,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      'Go to',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 14),

                    SizedBox(
                      height: 260,
                      child: Row(
                        children: [
                          // Surah wheel
                          Expanded(
                            flex: 3,
                            child: _WheelCard(
                              title: 'Surah',
                              child: CupertinoPicker(
                                scrollController: surahController,
                                itemExtent: 44,
                                magnification: 1.08,
                                useMagnifier: true,
                                selectionOverlay: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onSelectedItemChanged: (i) {
                                  setState(() {
                                    surahIndex = i;
                                    // reset ayah to 1 when surah changes (nice UX)
                                    ayahIndex = 0;
                                    ayahController.dispose();
                                    ayahController =
                                        FixedExtentScrollController(
                                          initialItem: 0,
                                        );
                                  });
                                },
                                children: [
                                  for (final s in surahs)
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: Text(
                                          '${s.id}. ${s.nameTransliteration}',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Ayah wheel
                          Expanded(
                            flex: 2,
                            child: _WheelCard(
                              title: 'Ayah',
                              child: CupertinoPicker(
                                scrollController: ayahController,
                                itemExtent: 44,
                                magnification: 1.08,
                                useMagnifier: true,
                                onSelectedItemChanged: (i) {
                                  setState(() => ayahIndex = i);
                                },
                                selectionOverlay: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                children: [
                                  for (int a = 1; a <= ayahCount; a++)
                                    Center(
                                      child: Text(
                                        a.toString(),
                                        style: theme.textTheme.titleLarge,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      '${selectedSurah.nameTransliteration} • Ayah ${ayahIndex + 1}',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: theme.textTheme.labelLarge!.color,
                      ),
                    ),

                    const SizedBox(height: 14),

                    //Actions
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
                          child: ElevatedButton(
                            onPressed: () {
                              final s = surahs[surahIndex];
                              Navigator.pop(context);
                              onGo(s.id, ayahIndex + 1);
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

  surahController.dispose();
  ayahController.dispose();
}

class _WheelCard extends ConsumerWidget {
  final String title;
  final Widget child;

  const _WheelCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(title, style: theme.textTheme.labelLarge),
          const SizedBox(height: 6),
          Expanded(child: child),
        ],
      ),
    );
  }
}
