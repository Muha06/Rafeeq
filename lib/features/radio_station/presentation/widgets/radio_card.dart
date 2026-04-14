import 'package:flutter/material.dart';
import 'package:rafeeq/features/radio_station/domain/enums/radio_audio_category.dart';
import '../../domain/entities/radio_station.dart';

class RadioCard extends StatelessWidget {
  final RadioStation station;

  const RadioCard({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        // later: play station
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: theme.colorScheme.surfaceContainerHighest,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  station.imageUrl ?? "https://via.placeholder.com/300",
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // TEXT SECTION
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // TAG
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      station.category.label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
