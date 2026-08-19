import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/salat_times.dart';
import 'package:rafeeq/features/home/presentation/widgets/hijri_date.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_prayer.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_status.dart';
import 'package:rafeeq/features/timings/presentation/pages/timings_pages.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/salah_status_provider.dart';
import 'package:rafeeq/features/home/presentation/widgets/user_location_chip.dart';

class HomeTimelineCard extends ConsumerWidget {
  const HomeTimelineCard({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final salahStatus = ref.watch(salahStatusProvider);

    return salahStatus.when(
      data: (status) => _BuildTimelineCard(status: status),
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const _ErrorCard(),
    );
  }
}

class _ErrorCard extends ConsumerWidget {
  const _ErrorCard({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Row(
      children: [
        const Text('Oops! Failed to fetch prayer times'),
        const Spacer(),
        IconButton(
          onPressed: () => ref.invalidate(salahStatusProvider),
          icon: const Icon(HugeIconsSolid.refresh),
        ),
      ],
    );
  }
}

class _BuildTimelineCard extends ConsumerWidget {
  const _BuildTimelineCard({super.key, required this.status});
  final SalahStatusEntity status;

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final current = status.current;
    final currentStart = status.currentStart;
    final next = status.next;

    return GestureDetector(
      onTap: () => AppNav.push(context, const SalahTimingsPage()),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: cs.primary.withAlpha(160),
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset(
              'assets/images/salah/masjid_dark.jpeg',
              fit: BoxFit.cover,
            ),

            const DecoratedBox(
              decoration: BoxDecoration(color: Colors.black38),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CurrentSalat(
                        current: current,
                        currentStart: currentStart,
                      ),

                      const Spacer(),

                      const UserLocationChip(),
                    ],
                  ),

                  const Spacer(),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: _TimeToNextText(next: next),
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

class _TimeToNextText extends ConsumerWidget {
  const _TimeToNextText({required this.next});

  final SalahPrayer next;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final remaining = ref.watch(salahTimeToNextProvider);

    return remaining.when(
      data: (duration) => Row(
        children: [
          const Icon(PhosphorIcons.clock, color: Colors.white, size: 14),

          const SizedBox(width: 2),

          Text(
            '${formatRemaining(duration)} until ${next.label}',
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.white,
              // fontSize: 13,
            ),
          ),
        ],
      ),
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
    );
  }
}

class _CurrentSalat extends StatelessWidget {
  const _CurrentSalat({
    super.key,
    required this.current,
    required this.currentStart,
  });
  final SalahPrayer current;
  final DateTime currentStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          current.label,
          style: tt.labelMedium?.copyWith(color: Colors.white),
        ),

        const SizedBox(height: 0),

        // Time
        Text(
          formatTime(currentStart),
          style: tt.headlineMedium?.copyWith(
            fontFamily: 'PlayFairDisplay',
            fontWeight: FontWeight.bold,
            // fontSize: 20,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
