import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:rafeeq/core/helpers/ayah_share_cotroller_provider.dart';

class ShareRafeeqCard extends ConsumerWidget {
  const ShareRafeeqCard({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: cs.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Share Rafeeq', style: tt.labelSmall),

          const SizedBox(height: 14),

          Text(
            'Rafeeq helps Muslims stay connected to the Quran, salah, adhkar and their deen. Share it with another Muslim and spread something beneficial.',
            style: tt.bodyMedium?.copyWith(color: cs.onSurface),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.tertiaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  HugeIconsSolid.quoteDown,
                  size: 12,
                  color: cs.onTertiaryContainer,
                ),
                const SizedBox(height: 8),
                Text(
                  '“Whoever guides to good will have a reward similar to that of its doer.”',
                  style: tt.bodyMedium?.copyWith(color: cs.onTertiaryContainer),
                ),
                const SizedBox(height: 8),

                Text(
                  '— Sahih Muslim',
                  style: tt.labelSmall?.copyWith(color: cs.onTertiaryContainer),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ref
                    .read(shareControllerProvider)
                    .shareRafeeqApp(context: context);
              },
              icon: const Icon(Icons.share_rounded, size: 18),
              label: const Text('Share Rafeeq'),
            ),
          ),
        ],
      ),
    );
  }
}
