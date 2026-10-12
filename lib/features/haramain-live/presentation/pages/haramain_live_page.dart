import 'package:flutter/material.dart';
import 'package:rafeeq/core/constants/spacing/app_spacing.dart';
import 'package:rafeeq/features/haramain-live/presentation/provider/haramain_player_provider.dart';
import 'package:rafeeq/features/haramain-live/presentation/widgets/haramain_video_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HaramainLivePage extends ConsumerStatefulWidget {
  const HaramainLivePage({super.key, this.startOnOpen = true});

  final bool startOnOpen;

  @override
  ConsumerState<HaramainLivePage> createState() => _HaramainLivePageState();
}

class _HaramainLivePageState extends ConsumerState<HaramainLivePage> {
  @override
  void initState() {
    super.initState();

    if (!widget.startOnOpen) return;

    Future.microtask(() {
      if (!mounted) return;

      final notifier = ref.read(haramainPlayerProvider.notifier);
      notifier.start();
    });
  }

  Widget _buildError(String error) {
    final notifier = ref.read(haramainPlayerProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.wifi_off, size: 40),
        const SizedBox(height: 10),
        Text(error, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        TextButton(onPressed: notifier.retry, child: const Text('Retry')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final player = ref.watch(haramainPlayerProvider);
    final notifier = ref.read(haramainPlayerProvider.notifier);

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final isMakkah = player.selectedIndex == 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              ChoiceChip(
                padding: const EdgeInsets.all(12),
                label: Text(
                  'Makkah',
                  style: theme.chipTheme.labelStyle?.copyWith(
                    color: isMakkah ? cs.onPrimary : cs.onSurfaceVariant,
                  ),
                ),
                selected: isMakkah,
                backgroundColor: isMakkah ? cs.primary : cs.surface,
                onSelected: (_) => notifier.switchStream(0),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                padding: const EdgeInsets.all(12),
                label: Text(
                  'Madinah',
                  style: theme.chipTheme.labelStyle?.copyWith(
                    color: !isMakkah ? cs.onPrimary : cs.onSurfaceVariant,
                  ),
                ),
                selected: !isMakkah,
                backgroundColor: !isMakkah ? cs.primary : cs.surface,
                onSelected: (_) => notifier.switchStream(1),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxxl),
        
        if (player.error != null)
          _buildError(player.error!)
        else if (player.isLoading)
          const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(),
          )
        else if (player.controller case final controller?
            when controller.value.isInitialized)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                HaramainVideoPlayer(controller: controller),
                const SizedBox(height: 16),
                Text(
                  'Please note that the Haramain livestream may occasionally be unstable.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          )
        else
          const CircularProgressIndicator(),
      ],
    );
  }
}
