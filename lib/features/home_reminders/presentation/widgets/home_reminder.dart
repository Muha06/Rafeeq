import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/widgets/app_icon_container.dart';

class HomeReminderCard extends StatelessWidget {
  const HomeReminderCard({
    super.key,
    required this.title,
    required this.onTap,
    required this.message,
  });

  final String title;
  final String message;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: cs.tertiaryContainer),
        child: Stack(
          children: [
            Positioned(
              right: -18,
              top: -24,
              child: Icon(
                PhosphorIcons.moonThin,
                size: 92,
                color: cs.onSurfaceVariant.withAlpha(48),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Title
                    AppIconContainer(
                      backgroundColor: cs.tertiary,
                      borderRadius: 8,
                      size: 24,
                      child: Icon(
                        CupertinoIcons.bell,
                        color: cs.onTertiaryContainer,
                        size: 16,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelLarge?.copyWith(
                              height: 1,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // Message
                          Text(
                            message,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
