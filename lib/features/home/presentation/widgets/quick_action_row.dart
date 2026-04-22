import 'package:flutter/material.dart';

class HomeQuickActionsRow extends StatelessWidget {
  final VoidCallback onQuran;
  final VoidCallback onAdhkar;
  final VoidCallback onAllahNames;

  const HomeQuickActionsRow({
    super.key,
    required this.onQuran,
    required this.onAdhkar,
    required this.onAllahNames,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _QuickActionCard(
              title: "Qur’an",
              imagePath: 'assets/images/home/quran.png',
              onTap: onQuran,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _QuickActionCard(
              title: "Adhkār",
              imagePath: 'assets/images/home/tasbih.png',
              onTap: onAdhkar,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _QuickActionCard(
              title: "Names",
              imagePath: 'assets/images/home/Allah_name.png',
              onTap: onAllahNames,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Icon/Image
            Image.asset(imagePath, height: 32, width: 32, fit: BoxFit.contain),

            const SizedBox(height: 8),

            /// Title
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
