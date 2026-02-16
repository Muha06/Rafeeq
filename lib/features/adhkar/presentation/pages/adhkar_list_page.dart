import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_state.dart';
import 'package:rafeeq/core/features/audio/providers/audio_controller.dart';
import 'package:rafeeq/core/features/audio/providers/just_audio_player_provider.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
import 'package:rafeeq/features/adhkar/domain/entities/adhkar_category.dart';
import 'package:rafeeq/features/adhkar/domain/entities/dhikr.dart';
import 'package:rafeeq/features/adhkar/presentation/pages/adhkar_details_page.dart';
import 'package:rafeeq/features/adhkar/presentation/riverpod/get_adhkars_provider.dart';

class AdhkarListPage extends ConsumerStatefulWidget {
  const AdhkarListPage({super.key, required this.category});
  final AdhkarCategory category;

  @override
  ConsumerState<AdhkarListPage> createState() => _AdhkarListPageState();
}

class _AdhkarListPageState extends ConsumerState<AdhkarListPage> {
  bool get isMorning => widget.category.title.toLowerCase().contains('morning');

  @override
  Widget build(BuildContext context) {
    final assetPath = widget.category.assetPath;
    final adhkars = ref.watch(getAdhkarsProvider(assetPath));
    final theme = Theme.of(context);
    final category = widget.category;
    final title = category.title.toLowerCase();

    final urlsAsync = ref.watch(adhkarAudioUrlsProvider);

    final isMorningCat = title.contains('morning');
    final isEveningCat = title.contains('evening');

    final audioState = ref.watch(audioControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.title),
        actions: [
          if (isMorningCat || isEveningCat)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: urlsAsync.when(
                  loading: () => const CupertinoActivityIndicator(),
                  error: (e, st) => IconButton(
                    onPressed: () => ref.invalidate(adhkarAudioUrlsProvider),
                    icon: const Icon(CupertinoIcons.exclamationmark_triangle),
                  ),
                  data: (urls) {
                    final url = isMorningCat
                        ? urls.morningUrl
                        : urls.eveningUrl;

                    final playing =
                        ref.watch(audioPlayingProvider).value ?? false;
                    final buffering =
                        ref.watch(audioBufferingProvider).value ?? false;

                    final isActive =
                        audioState.source == AudioSourceType.adhkar &&
                        audioState.url == url;

                    final showPause = isActive && playing;

                    return TextButton.icon(
                      onPressed: buffering
                          ? null
                          : () async {
                              if (showPause) {
                                await ref
                                    .read(audioControllerProvider.notifier)
                                    .pause();
                              } else {
                                await ref
                                    .read(audioControllerProvider.notifier)
                                    .playUrl(
                                      url: url,
                                      source: AudioSourceType.adhkar,
                                      id: isMorningCat
                                          ? 'adhkar_morning'
                                          : 'adhkar_evening',
                                      title: isMorningCat
                                          ? 'Morning Adhkār'
                                          : 'Evening Adhkār',
                                      context: context,
                                    );
                              }
                            },
                      icon: buffering
                          ? const CupertinoActivityIndicator()
                          : Icon(
                              showPause
                                  ? CupertinoIcons.pause
                                  : CupertinoIcons.play,
                            ),
                      label: Text(
                        buffering
                            ? 'Loading'
                            : (showPause ? 'Pause' : 'Listen'),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],

        bottom: appBarBottomDivider(context),
      ),
      body: adhkars.when(
        error: (error, stackTrace) => const Center(child: Text('Error')),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (adhkars) {
          return ListView.separated(
            separatorBuilder: (context, index) =>
                Divider(color: theme.dividerColor),
            itemCount: adhkars.length,
            itemBuilder: (context, index) {
              final dhikr = adhkars[index];

              return AdhkarListTile(
                dhikr: dhikr,
                index: index,
                assetPath: assetPath,
                adhkars: adhkars,
              );
            },
          );
        },
      ),
    );
  }
}

class AdhkarListTile extends ConsumerWidget {
  const AdhkarListTile({
    super.key,
    required this.dhikr,
    required this.index,
    required this.assetPath,
    required this.adhkars,
  });

  final Dhikr dhikr;
  final List<Dhikr> adhkars;
  final int index;
  final String assetPath;

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdhkarDetailsPage(
              dhikr: dhikr,
              adhkars: adhkars,
              assetPath: assetPath,
              initialIndex: index,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14),
        child: Row(
          children: [
            Container(
              height: 24,
              width: 36,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  (index + 1).toString(),
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Text(
                dhikr.title.trim(),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: theme.textTheme.bodySmall!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(width: 8),
            const Icon(CupertinoIcons.right_chevron, size: 18),
          ],
        ),
      ),
    );
  }
}
