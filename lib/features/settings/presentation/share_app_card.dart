import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/widgets/app_icon_container.dart';
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
          AppIconContainer(
            backgroundColor: cs.surfaceContainerHighest,
            borderRadius: 999,
            size: 38,
            child: Icon(Icons.share_rounded, color: cs.onSurface, size: 24),
          ),

          const SizedBox(height: 14),

          Text(
            'Know a Muslim who needs Rafeeq?',
            style: tt.titleMedium?.copyWith(color: cs.onSurface),
          ),

          const SizedBox(height: 8),

          Text(
            'A small share could help someone build a stronger connection with the Quran, salah and their deen.',
            style: tt.bodyMedium?.copyWith(color: cs.onSurface),
          ),

          const SizedBox(height: 18),

          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref
                      .read(shareControllerProvider)
                      .shareRafeeqApp(context: context);
                },
                child: const Text('Share Rafeeq'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
