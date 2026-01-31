import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/salat_times.dart';
import 'package:rafeeq/features/salat-times/domain/entities/salah_status.dart';
import 'package:rafeeq/features/salat-times/presentation/pages/salat_times_page.dart';
import 'package:rafeeq/features/salat-times/presentation/riverpod/salah_status_provider.dart';

import '../../domain/entities/salah_prayer.dart';

class TodayTimesCard extends ConsumerWidget {
  const TodayTimesCard({
    super.key,
    required this.assetsByPrayer,
    this.height = 190,
    this.borderRadius = 20,
  });

  final Map<SalahPrayer, String> assetsByPrayer;

  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final statusAsync = ref.watch(salahStatusProvider); //salah status

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, anim) {
        final fade = FadeTransition(opacity: anim, child: child);
        final slide = SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.03), // tiny lift
            end: Offset.zero,
          ).animate(anim),
          child: fade,
        );
        return slide;
      },
      child: statusAsync.when(
        loading: () => _SkeletonCard(
          key: const ValueKey('loading'),
          height: height,
          radius: borderRadius,
        ),
        error: (e, _) => const SizedBox.shrink(key: ValueKey('error')),
        data: (status) => _CardBody(
          key: ValueKey(
            'data-${status.current}-${assetsByPrayer[status.current]}',
          ),
          status: status,
          theme: theme,
          height: height,
          radius: borderRadius,
          bgAsset: assetsByPrayer[status.current],
        ),
      ),
    );
  }
}

class _CardBody extends StatelessWidget {
  const _CardBody({
    super.key,
    required this.status,
    required this.theme,
    required this.height,
    required this.radius,
    required this.bgAsset,
  });

  final SalahStatusEntity status;
  final ThemeData theme;
  final double height;
  final double radius;
  final String? bgAsset;

  @override
  Widget build(BuildContext context) {
    final onImage = Colors.white;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            if (bgAsset != null)
              Image.asset(bgAsset!, fit: BoxFit.cover)
            else
              Container(color: theme.cardColor),

            // Gradient overlay (keeps text readable)
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withAlpha(125),
                    Colors.black.withAlpha(65),
                    Colors.black.withAlpha(140),
                  ],
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top row: current | progress | next
                  Row(
                    children: [
                      _TopLabel(
                        title: 'Current',
                        value: status.current.label,
                        salatTime: status.currentStart,
                        color: onImage,
                        align: CrossAxisAlignment.start,
                      ),

                      const SizedBox(width: 12),

                      //progress
                      Expanded(
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: status.progress.isNaN
                                    ? 0
                                    : status.progress.clamp(0.0, 1.0),
                                minHeight: 8,
                                backgroundColor: Colors.white.withAlpha(62),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  status.progress < 0.7
                                      ? Colors.white
                                      : Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      //next salah
                      _TopLabel(
                        title: 'Next',
                        value: status.next.label,
                        salatTime: status.nextStart,
                        color: onImage,
                        align: CrossAxisAlignment.end,
                      ),
                    ],
                  ),

                  const Spacer(),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Bottom: "Next salah in"
                          Text(
                            'Next salah in:',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: onImage.withAlpha(230),
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            formatHms(status.timeToNext),
                            textAlign: TextAlign.left,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: onImage,
                              fontWeight: FontWeight.w800,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),

                      ShowTodayTimesChip(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SalahTimingsPage(),
                            ),
                          );
                        },
                      ),
                    ],
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

class _TopLabel extends StatelessWidget {
  const _TopLabel({
    required this.title,
    required this.value,
    required this.salatTime,
    required this.color,
    required this.align,
  });

  final String title;
  final String value;
  final DateTime salatTime;
  final Color color;
  final CrossAxisAlignment align;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String two(int n) => n.toString().padLeft(2, '0');

    final isNext = title == 'Next';

    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          title,
          style: theme.textTheme.labelMedium?.copyWith(
            color: color.withAlpha(210),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: isNext ? FontWeight.w500 : FontWeight.w800,
            fontSize: isNext ? 13 : 16,
          ),
        ),

        const SizedBox(height: 6),
        Text(
          '${two(salatTime.hour)}:${two(salatTime.minute)}',
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.amber,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class ShowTodayTimesChip extends StatelessWidget {
  const ShowTodayTimesChip({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withOpacity(0.28)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.schedule_rounded,
                  size: 16,
                  color: Colors.white.withOpacity(0.95),
                ),
                const SizedBox(width: 6),
                Text(
                  "See today’s times",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white.withOpacity(0.95),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({super.key, required this.height, required this.radius});

  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: theme.cardColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CupertinoActivityIndicator(radius: 18),
            const SizedBox(height: 8),
            Text('Loading today\'s times...', style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
