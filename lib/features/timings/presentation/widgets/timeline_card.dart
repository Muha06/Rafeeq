// ignore_for_file: unused_result

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/app/providers/tabs_screen_provider.dart';
import 'package:rafeeq/core/animations/navigation_animations.dart';
import 'package:rafeeq/core/features/location/presentation/pages/user_loc_settings.dart';
import 'package:rafeeq/core/features/location/presentation/provider/user_location_provider.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/rafeeq_analytics.dart';
import 'package:rafeeq/core/widgets/app_state_view.dart';
import 'package:rafeeq/features/asma_ul_husna/presentation/pages/asma_ul_husna_list_page.dart';
import 'package:rafeeq/features/home/presentation/widgets/hijri_date.dart';
import 'package:rafeeq/features/home/presentation/widgets/quick_action_row.dart';
import 'package:rafeeq/features/settings/presentation/pages/settings_page.dart';
import 'package:rafeeq/features/timings/presentation/pages/timings_pages.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/salah_status_provider.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/salah_times_providers.dart';
import '../../domain/entities/salah_prayer.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

const String _bg = "assets/images/home/mosque2.jpeg";

class TodayTimesCard extends ConsumerWidget {
  const TodayTimesCard({
    super.key,
    this.height = 360, // content height
  });

  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final isDark = theme.brightness == Brightness.dark;

    final fg = isDark ? cs.onSurface : cs.onPrimary;
    final highlightColor = isDark ? cs.primary : cs.tertiary;

    return SizedBox(
      height: height,
      child: Stack(
        clipBehavior: Clip.none,

        children: [
          // BACKGROUND IMAGE
          Positioned.fill(child: Image.asset(_bg, fit: BoxFit.cover)),

          // DARK OVERLAY
          Positioned.fill(child: Container(color: Colors.black.withAlpha(120))),

          Column(
            children: [
              //APPBAR
              _TimingsCardAppbar(foregroundColor: fg),

              //HIJRI DATE
              const HijriDateToday(foregroundColor: Colors.white, fontSize: 16),

              const SizedBox(height: 16),

              //CONTENT
              TimingsStatus(
                foregroundColor: fg,
                highlightColor: highlightColor,
              ),
            ],
          ),

          // QUICK ACTIONS
          const QuickHomeActions(),
        ],
      ),
    );
  }
}

class QuickHomeActions extends ConsumerWidget {
  const QuickHomeActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: -48,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: HomeQuickActionsRow(
          onQuran: () {
            ref.read(tabsScreenIndexProvider.notifier).state = 1;
          },
          onAdhkar: () {
            ref.read(tabsScreenIndexProvider.notifier).state = 2;
          },
          onAllahNames: () {
            AppNav.push(context, const AllahNamesPage());
          },
        ),
      ),
    );
  }
}

class TimingsStatus extends ConsumerWidget {
  const TimingsStatus({
    super.key,
    required this.foregroundColor,
    required this.highlightColor,
  });
  final Color foregroundColor;
  final Color highlightColor;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(salahStatusProvider);
    final progress = ref.watch(
      salahStatusProvider.select((s) => s.value?.progress ?? 0),
    );

    final current = ref.watch(
      salahStatusProvider.select((s) => s.value?.current),
    );

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final fg = foregroundColor;

    return statusAsync.when(
      data: (status) => Center(
        child: Column(
          children: [
            RepaintBoundary(
              child: SleekCircularSlider(
                min: 0,
                max: 1,
                initialValue: progress.clamp(0, 1),
                appearance: CircularSliderAppearance(
                  size: 120,
                  startAngle: 180,
                  angleRange: 180,
                  customWidths: CustomSliderWidths(
                    trackWidth: 6,
                    progressBarWidth: 6,
                  ),
                  customColors: CustomSliderColors(
                    progressBarColor: highlightColor,
                    trackColor: cs.surface.withAlpha(90),
                  ),
                  animationEnabled: false,
                ),
                innerWidget: (_) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          current?.label ?? '',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: fg,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 8),

                        InkWell(
                          onTap: () {
                            AppNav.push(context, const SalahTimingsPage()).then(
                              (_) => RafeeqAnalytics.logScreenView(
                                "salah_times_page",
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'View times',
                                style: theme.textTheme.labelMedium!.copyWith(
                                  color: highlightColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                PhosphorIcons.caretRight(),
                                size: 16,
                                color: highlightColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            _NextPrayerText(
              theme: theme,
              fg: fg,
              highlightColor: highlightColor,
            ),
          ],
        ),
      ),

      error: (error, stackTrace) => AppStateView(
        title: "Error fetching times",
        message: "Please check your Internet connection and try again.",
        foregroundColor: fg,
        buttonText: "Retry",
        onPressed: () => ref.refresh(todaySalahTimesProvider),
      ),

      loading: () => Center(child: CircularProgressIndicator(color: fg)),
    );
  }
}

class _NextPrayerText extends ConsumerWidget {
  const _NextPrayerText({
    required this.theme,
    required this.fg,
    required this.highlightColor,
  });

  final ThemeData theme;
  final Color fg;
  final Color highlightColor;
  @override
  Widget build(BuildContext context, ref) {
    final next = ref.watch(salahStatusProvider.select((s) => s.value));

    return RichText(
      text: TextSpan(
        text: "${next?.next.label ?? 'null'} is approaching in ",
        style: theme.textTheme.bodyMedium!.copyWith(color: fg),
        children: [
          if (next?.timeToNext != null)
            TextSpan(
              text: formatRemaining(next!.timeToNext),
              style: theme.textTheme.bodyMedium!.copyWith(
                color: highlightColor,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}

class _TimingsCardAppbar extends StatelessWidget {
  const _TimingsCardAppbar({required this.foregroundColor});
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 18, // safe area + some spacing
      ),
      child: Row(
        children: [
          const Align(alignment: Alignment.topLeft, child: UserLocationChip()),

          const Spacer(),

          IconButton(
            onPressed: () async {
              pushLeftPage(context, const SettingsPage());
            },
            icon: Icon(PhosphorIcons.gear(), color: foregroundColor),
          ),
        ],
      ),
    );
  }
}

class UserLocationChip extends ConsumerWidget {
  const UserLocationChip({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final userLocationAsync = ref.watch(userLocationProvider);

    return userLocationAsync.when(
      error: (error, stackTrace) => _MyUserLocChip(
        icon: Icons.error_outline,
        label: 'retry',
        onTap: () => ref.read(userLocationProvider.notifier).refresh(),
      ),
      loading: () => const Chip(label: CupertinoActivityIndicator()),
      data: (userLocation) => _MyUserLocChip(
        icon: PhosphorIcons.mapPin(),
        label: userLocation?.city ?? '',
        onTap: () => AppNav.push(context, const UserLocSettingsPage()),
      ),
    );
  }
}

class _MyUserLocChip extends StatelessWidget {
  const _MyUserLocChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Chip(
        label: Row(
          children: [
            Icon(icon, size: 16, color: cs.onSurface),
            const SizedBox(width: 2),

            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium!.copyWith(color: cs.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}

String formatRemaining(Duration d) {
  final hours = d.inHours;
  final minutes = d.inMinutes.remainder(60);

  if (hours == 0) {
    return "$minutes min";
  } else if (minutes == 0) {
    return "$hours hr";
  } else {
    return "$hours hr $minutes min";
  }
}
