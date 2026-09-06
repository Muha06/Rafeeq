import 'package:flutter/material.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/features/qibla/presentation/pages/qibla_page.dart';
import 'package:rafeeq/features/qibla/presentation/widgets/qibla_compass.dart';

class QiblaHomeCard extends StatelessWidget {
  const QiblaHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        AppNav.push(context, const QiblaPage());
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Small live compass
            const SizedBox(
              width: 52,
              height: 52,
              child: QiblaCompass(
                size: 52,
                showInstruction: false,
                enableHaptics: false,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Qibla', style: theme.textTheme.labelLarge),
                  const SizedBox(height: 2),
                  Text(
                    'Find the direction of Qibla',
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ),
            ),

            Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
