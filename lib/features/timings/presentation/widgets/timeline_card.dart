// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/app/providers/tabs_screen_provider.dart';
import 'package:rafeeq/core/animations/navigation_animations.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/rafeeq_analytics.dart';
import 'package:rafeeq/core/widgets/app_state_view.dart';
import 'package:rafeeq/features/asma_ul_husna/presentation/pages/asma_ul_husna_list_page.dart';
import 'package:rafeeq/features/home/presentation/home_page.dart';
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
    required this.assetsByPrayer,
    this.height = 340, // content height
  });

  final Map<SalahPrayer, String> assetsByPrayer;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _CardBody(height: height);
  }
}

class _CardBody extends ConsumerWidget {
  const _CardBody({required this.height});

  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final isDark = theme.brightness == Brightness.dark;

    final fg = isDark ? cs.onSurface : cs.onPrimary;
    final highlightColor = isDark ? cs.primary : cs.tertiary;

    return SafeArea(
      top: true,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // BACKGROUND IMAGE
            Positioned.fill(child: Image.asset(_bg, fit: BoxFit.cover)),

            // DARK OVERLAY
            Positioned.fill(
              child: Container(color: Colors.black.withAlpha(120)),
            ),

            // FOREGROUND CONTENT
            Column(
              children: [
                //Custom AppBar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: UserLocationChip(),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () async {
                          pushLeftPage(context, const SettingsPage());
                        },
                        icon: Icon(PhosphorIcons.gear()),
                      ),
                    ],
                  ),
                ),

                //Hijri date
                HijriDateToday(foregroundColor: fg, fontSize: 16),

                const SizedBox(height: 16),

                // MAIN CARD CONTENT
                Consumer(
                  builder: (context, ref, child) {
                    final statusAsync = ref.watch(salahStatusProvider);

                    return statusAsync.when(
                      data: (status) => Expanded(
                        child: SalahCardStack(
                          height: height,
                          content: Center(
                            child: Column(
                              children: [
                                RepaintBoundary(
                                  child: SleekCircularSlider(
                                    min: 0,
                                    max: 1,
                                    initialValue: status.progress.clamp(0, 1),
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
                                    ),
                                    innerWidget: (_) {
                                      return Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              status.current.label,
                                              style: theme.textTheme.labelLarge
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: fg,
                                                    fontSize: 20,
                                                  ),
                                            ),
                                            const SizedBox(height: 8),
                                            InkWell(
                                              onTap: () {
                                                AppNav.push(
                                                  context,
                                                  const SalahTimingsPage(),
                                                ).then(
                                                  (_) =>
                                                      RafeeqAnalytics.logScreenView(
                                                        "salah_times_page",
                                                      ),
                                                );
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'View times',
                                                    style: theme
                                                        .textTheme
                                                        .labelMedium!
                                                        .copyWith(
                                                          color: highlightColor,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
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

                                RichText(
                                  text: TextSpan(
                                    text:
                                        "${status.next.label} is approaching in ",
                                    style: theme.textTheme.bodyMedium!.copyWith(
                                      color: fg,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: formatRemaining(
                                          status.timeToNext,
                                        ),
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(
                                              color: highlightColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      error: (error, stackTrace) => SalahCardStack(
                        height: height,
                        content: AppStateView(
                          title: "Error fetching times",
                          message:
                              "Please check your Internet connection and try again.",
                          foregroundColor: fg,
                          buttonText: "Retry",
                          onPressed: () => ref.refresh(todaySalahTimesProvider),
                        ),
                      ),

                      loading: () => SalahCardStack(
                        height: height,
                        content: Center(
                          child: CircularProgressIndicator(color: fg),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SalahCardStack extends ConsumerStatefulWidget {
  const SalahCardStack({
    super.key,
    required this.content,
    required this.height,
  });
  final Widget content;
  final double height;
  @override
  ConsumerState<SalahCardStack> createState() => _SalahCardStackState();
}

class _SalahCardStackState extends ConsumerState<SalahCardStack> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Content only
          widget.content,

          // Quick actions
          Positioned(
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
          ),
        ],
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
