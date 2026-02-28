import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_state.dart';
import 'package:rafeeq/core/features/audio/providers/audio_controller.dart';
import 'package:rafeeq/core/features/audio/providers/just_audio_player_provider.dart';
import 'package:rafeeq/core/helpers/clean_arabic_text.dart';
import 'package:rafeeq/core/themes/app_text_style.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
import 'package:rafeeq/features/adhkar/domain/entities/dhikr.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

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
    final isDark = ref.watch(isDarkProvider);
    final adhkars = widget.adhkars;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: theme.textTheme.titleMedium),
        bottom: appBarBottomDivider(context),
      ),
      body: ListView.builder(
        itemCount: adhkars.length,
        itemBuilder: (context, i) {
          final dhikr = adhkars[i];

          return AdhkarDetailsTile(isDark: isDark, dhikr: dhikr);
        },
      ),
    );
  }
}

class AdhkarDetailsTile extends ConsumerStatefulWidget {
  const AdhkarDetailsTile({
    super.key,
    required this.isDark,
    required this.dhikr,
  });

  final bool isDark;
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

    final playing = ref.watch(audioPlayingProvider).value ?? false;
    final buffering = ref.watch(audioBufferingProvider).value ?? false;

    final audio = ref.watch(audioControllerProvider);
    final ctrl = ref.watch(audioControllerProvider.notifier);

    final isActive =
        audio.source == AudioSourceType.adhkar && audio.url == dhikr.audioUrl;

    final showPause = playing && isActive;

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
                      // fontSize: 24,
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
                              if (showPause) {
                                ctrl.pause();
                              } else {
                                ctrl.playUrl(
                                  url: dhikr.audioUrl,
                                  source: AudioSourceType.adhkar,
                                  id: "dhikr.id",
                                  title: dhikr.categoryTitle,
                                  context: context,
                                );
                              }
                            },
                      icon: buffering
                          ? const CupertinoActivityIndicator()
                          : PhosphorIcon(
                              showPause
                                  ? PhosphorIcons.pause()
                                  : PhosphorIcons.play(),
                            ),
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
