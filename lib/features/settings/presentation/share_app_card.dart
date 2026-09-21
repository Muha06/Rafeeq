import 'package:flutter/material.dart';

class ShareRafeeqCard extends StatelessWidget {
  const ShareRafeeqCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: cs.surface,
      ),
      child: Column(
        children: [
          Text('Share Rafeeq to Muslims', style: tt.labelLarge),

          const SizedBox(height: 12),

          Text('', style: tt.bodyMedium),

          const SizedBox(height: 12),

          ElevatedButton(onPressed: () {}, child: const Text('Share Rafeeq')),
        ],
      ),
    );
  }
}
