import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/constants/strings/app_strings.dart';
import 'package:rafeeq/core/features/audio/presentation/providers/audio_controller.dart';
import 'package:rafeeq/core/helpers/app_text_style.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/entities/name_entity.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/entities/translations_enum.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:rafeeq/features/asma_ul_husna/presentation/widgets/allah_name_tile.dart';

class AllahNameDetailsSheet extends ConsumerWidget {
  final AllahName name;

  const AllahNameDetailsSheet({super.key, required this.name});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    final translation = name.translations[AllahNameLanguage.english];

    if (translation == null) {
      return const SizedBox.shrink();
    }

    final audioState = ref.watch(audioControllerProvider);

    final itemId = name.id;
    final isCurrent = audioState.currentId == itemId;

    final isPlaying = audioState.isPlaying && isCurrent;
    debugPrint("Isplaying: $isPlaying");

    return DraggableScrollableSheet(
      initialChildSize: 1,
      maxChildSize: 1,
      minChildSize: 0.45,
      expand: false,
      builder: (_, scrollController) => SafeArea(
        top: false,
        child: SingleChildScrollView(
          controller: scrollController,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 48, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Arabic
                  Text(
                    name.arabic,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.arabicUi.copyWith(
                      fontSize: 38,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.primary,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    translation.name,
                    textAlign: TextAlign.center,
                    style: tt.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: Text(
                      name.transliteration,
                      style: tt.titleMedium?.copyWith(
                        fontFamily: AppStrings.displayFont,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  PlayAllahNameButton(name: name),

                  const SizedBox(height: 24),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Meaning', style: tt.labelMedium),
                  ),

                  const SizedBox(height: 8),

                  Text(translation.meaning, style: tt.bodyLarge),

                  const SizedBox(height: 24),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Details', style: tt.labelMedium),
                  ),

                  const SizedBox(height: 8),

                  MarkdownBody(
                    data: translation.details,
                    styleSheet: MarkdownStyleSheet(
                      p: tt.bodyLarge,
                      strong: tt.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton.icon(
                  //     onPressed: () async {
                  //       final item = AudioItem(
                  //         id: name.id,
                  //         title: name.transliteration,
                  //         sourceType: AudioSourceType.allahName,
                  //         url: name.audioUrl,
                  //       );

                  //       await audioCtrl.togglePlay(item: item);

                  //       if (!isPlaying) {
                  //         RafeeqAnalytics.logFeature('play_Allah_name_audio');
                  //       }
                  //     },
                  //     icon: isBuffering
                  //         ? const CircularProgressIndicator()
                  //         : const Icon(Icons.play_arrow_rounded),
                  //     label: Text(isBuffering ? 'Buffering' : 'Listen'),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
