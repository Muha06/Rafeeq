import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/core/features/audio/providers/audio_controller.dart';
import 'package:rafeeq/core/helpers/clean_arabic_text.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
import 'package:rafeeq/core/helpers/snackbars.dart';
import 'package:rafeeq/core/themes/app_text_style.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
import 'package:rafeeq/features/adhkar/domain/entities/dhikr.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/dhikr_bookmark.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/dhikr/dhikr_notifier_provider.dart';

class AdhkarDetailsPage extends ConsumerStatefulWidget {
  const AdhkarDetailsPage({
    super.key,
    required this.adhkars,
    required this.title,
  });

  final List<DhikrEntity> adhkars;
  final String title;
  @override
  ConsumerState<AdhkarDetailsPage> createState() => _AdhkarDetailsPageState();
}

class _AdhkarDetailsPageState extends ConsumerState<AdhkarDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final adhkars = widget.adhkars;
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title, style: theme.textTheme.titleMedium),
          bottom: appBarBottomDivider(context),
        ),
        body: ListView.builder(
          itemCount: adhkars.length,
          itemBuilder: (context, i) {
            final dhikr = adhkars[i];

            return AdhkarDetailsTile(dhikr: dhikr);
          },
        ),
      ),
    );
  }
}

class AdhkarDetailsTile extends ConsumerStatefulWidget {
  const AdhkarDetailsTile({super.key, required this.dhikr});

  final DhikrEntity dhikr;

  @override
  ConsumerState<AdhkarDetailsTile> createState() => _AdhkarDetailsTileState();
}

class _AdhkarDetailsTileState extends ConsumerState<AdhkarDetailsTile> {
  Future<void> playAudio() async {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final dhikr = widget.dhikr;
    final dhikrId = dhikr.id;

    final audioState = ref.watch(audioControllerProvider);
    final isCurrent = audioState.currentId == dhikrId.toString();

    final isPlaying = audioState.isPlaying && isCurrent;
    final buffering = audioState.isBuffering;

    final ctrl = ref.watch(audioControllerProvider.notifier);

    final TextStyle bodyTextstyle = textTheme.bodyMedium!.copyWith(
      fontSize: 18,
    );
    final cs = theme.colorScheme;

    Widget section(String title, String? text) {
      final t = (text ?? '').trim();
      if (t.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textTheme.bodySmall), //header
          const SizedBox(height: 8),

          Text(t, style: bodyTextstyle), //text
          const SizedBox(height: 24),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: cs.surface,
          ),
          child: SelectionArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //arabic
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    cleanDhikr(widget.dhikr.arabicText),
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.arabicUi.copyWith(
                      color: cs.onSurface,
                      height: 1.8,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                //transliteration
                section('Transliteration', widget.dhikr.transliteration),

                //english
                section('Translation', widget.dhikr.translation),

                //note
                section('Notes', 'Repeat ${widget.dhikr.repeat} times'),

                const Divider(height: 8),

                //controls section
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      iconSize: 20,
                      onPressed: buffering
                          ? null
                          : () {
                              ctrl.togglePlay(
                                context: context,
                                currentId: dhikrId.toString(),
                                url: dhikr.audioUrl,
                                showAudioPlayer: true,
                                title: dhikr.categoryTitle,
                              );
                            },
                      icon: buffering
                          ? const CupertinoActivityIndicator()
                          : PhosphorIcon(
                              isPlaying
                                  ? PhosphorIcons.pause()
                                  : PhosphorIcons.play(),
                            ),
                    ),
                    const SizedBox(),

                    //copy
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      iconSize: 22,
                      onPressed: () async {
                        final buffer = StringBuffer();

                        // Arabic
                        buffer.writeln(cleanDhikr(dhikr.arabicText));
                        buffer.writeln();

                        // Transliteration
                        if ((dhikr.transliteration).trim().isNotEmpty) {
                          buffer.writeln("Transliteration:");
                          buffer.writeln(dhikr.transliteration.trim());
                          buffer.writeln();
                        }

                        // Translation
                        if ((dhikr.translation).trim().isNotEmpty) {
                          buffer.writeln("Translation:");
                          buffer.writeln(dhikr.translation.trim());
                          buffer.writeln();
                        }

                        // Repeat
                        buffer.writeln("Repeat ${dhikr.repeat} times");

                        await Clipboard.setData(
                          ClipboardData(text: buffer.toString().trim()),
                        );

                        if (context.mounted) {
                          AppSnackBar.showSimple(
                            context: context,
                            message: "Dhikr copied",
                          );
                        }
                      },
                      icon: PhosphorIcon(PhosphorIcons.copy()),
                    ),

                    Consumer(
                      builder: (context, ref, child) {
                        final isBookmarked = ref.watch(
                          isDhikrBookmarkedProvider(dhikr.id),
                        );

                        return IconButton(
                          onPressed: () {
                            final bookmark = DhikrBookmark(
                              dhikrId: dhikr.id,
                              title: dhikr.transliteration,
                              categoryId: dhikr.categoryId,
                              createdAt: DateTime.now(),
                            );

                            ref
                                .read(dhikrBookmarksProvider.notifier)
                                .toggle(bookmark);

                            RafeeqAnalytics.logFeature('bookmarked_dhikr');
                          },
                          icon: PhosphorIcon(
                            PhosphorIcons.bookmark(
                              isBookmarked
                                  ? PhosphorIconsStyle.fill
                                  : PhosphorIconsStyle.regular,
                            ),
                            color: isBookmarked ? cs.primary : cs.onSurface,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
