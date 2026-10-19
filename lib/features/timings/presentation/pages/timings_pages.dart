import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/features/location/presentation/provider/general_location_permission_provider.dart';
import 'package:rafeeq/core/features/location/presentation/provider/user_location_provider.dart';
import 'package:rafeeq/core/helpers/app_toast.dart';
import 'package:rafeeq/core/widgets/app_state_view.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_times.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/disable_salah_reminders_provider.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/fetch_salah_times_provider.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/salah_status_provider.dart';

import '../../domain/entities/salah_prayer.dart';

class SalahTimingsPage extends ConsumerStatefulWidget {
  const SalahTimingsPage({super.key});

  @override
  ConsumerState<SalahTimingsPage> createState() => _SalahTimingsPageState();
}

class _SalahTimingsPageState extends ConsumerState<SalahTimingsPage> {
  final now = DateTime.now();
  bool _refreshingLocation = false;

  void _retry(WidgetRef ref) {
    ref.invalidate(fetchSalahTimesProvider);
    ref.invalidate(salahStatusProvider);
  }

  Future<void> _refreshLocation() async {
    if (_refreshingLocation) return;

    setState(() => _refreshingLocation = true);

    try {
      final permissionGranted = await ref
          .read(systemLocationAccessProvider.notifier)
          .requestLocationAccess();

      if (!mounted) return;

      if (!permissionGranted) {
        AppToast.showError(
          context: context,
          message: 'Please grant location permissions to refresh your location',
        );
        return;
      }

      await ref.read(userLocationProvider.notifier).refresh();
      await ref.read(fetchSalahTimesProvider.future);

      if (!mounted) return;

      AppToast.showSuccess(
        context: context,
        message: 'Location and prayer times updated',
      );
    } catch (e) {
      debugPrint('Failed to refresh location and prayer times: $e');
      if (mounted) {
        AppToast.showError(
          context: context,
          message: 'Could not refresh location. Check location services and try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _refreshingLocation = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final timesAsync = ref.watch(fetchSalahTimesProvider);

    return timesAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(
          title: const Text('Today\'s Timings'),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),

      error: (e, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Today\'s Timings'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: AppStateView(
            title: 'Failed to fetch Prayer times',
            message: 'Please check your internet connection then try again',
            buttonText: 'Retry',
            onPressed: () => _retry(ref),
          ),
        ),
      ),

      data: (times) {
        final location = ref.watch(userLocationProvider).value;

        const salats = [
          SalahPrayer.fajr,
          SalahPrayer.dhuhr,
          SalahPrayer.asr,
          SalahPrayer.maghrib,
          SalahPrayer.isha,
        ];

        const otherTimes = [
          SalahPrayer.sunrise,
          SalahPrayer.dhuha,
          SalahPrayer.tahajjud,
        ];
        final status = ref.watch(salahStatusProvider).value;
        final current = status?.current;

        return SafeArea(
          top: false,
          bottom: true,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Today\'s Timings'),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _LocationLabel(
                          city: location?.city ?? 'Location unavailable',
                          country: location?.country,
                        ),
                      ),

                      const SizedBox(width: 12),

                      IconButton.filledTonal(
                        tooltip: 'Refresh current location',
                        color: cs.surface,
                        onPressed: _refreshingLocation
                            ? null
                            : _refreshLocation,
                        icon: _refreshingLocation
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(Icons.refresh_rounded, color: cs.onSurface),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    height: 100,
                    child: AllSalatTimingsCard(times: times, current: current),
                  ),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 24),
                      child: ListView(
                        children: [
                          // 🕌 Obligatory prayers
                          Text(
                            'Obligatory Prayers',
                            style: theme.textTheme.labelSmall,
                          ),
                          const SizedBox(height: 12),

                          ...salats.map((p) {
                            final t = times.at(p);
                            return _TimingTile(
                              prayer: p,
                              title: p.label,
                              timeText: _formatHm(t),
                            );
                          }),

                          const SizedBox(height: 16),

                          // 🌤️ Other times
                          Text(
                            'Other Times',
                            style: theme.textTheme.labelSmall,
                          ),
                          const SizedBox(height: 12),

                          ...otherTimes.map((p) {
                            final t = times.at(p);
                            return _TimingTile(
                              prayer: p,
                              title: p.label,
                              timeText: _formatHm(t),
                              canToggle: false,
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      skipLoadingOnRefresh: true,
    );
  }
}

class _LocationLabel extends StatelessWidget {
  const _LocationLabel({required this.city, this.country});

  final String city;
  final String? country;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final location = [
      city,
      if (country != null && country!.isNotEmpty && country != city) country!,
    ].join(', ');

    return Row(
      children: [
        Icon(PhosphorIcons.mapPin, size: 20, color: colorScheme.primary),
        const SizedBox(width: 10),

        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PRAYER TIMES FOR',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 0.6,
                ),
              ),
              Text(
                location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AllSalatTimingsCard extends StatelessWidget {
  const AllSalatTimingsCard({
    super.key,
    required this.times,
    required this.current,
  });

  final SalahTimesEntity times;
  final SalahPrayer? current;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    const salats = [
      SalahPrayer.fajr,
      SalahPrayer.dhuhr,
      SalahPrayer.asr,
      SalahPrayer.maghrib,
      SalahPrayer.isha,
    ];

    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.antiAlias,
      children: [
        //image
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.asset(
            'assets/images/salah/salah_card.png',
            fit: BoxFit.cover,
          ),
        ),

        Center(
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: salats.map((p) {
                final t = times.at(p);
                final isCurrent = p == current;

                final lightColors = isCurrent
                    ? cs.tertiary
                    : cs.onPrimary.withAlpha(200);
                final lightColors2 = isCurrent ? cs.tertiary : cs.onPrimary;

                final darkColors = isCurrent
                    ? cs.tertiary
                    : cs.onSurface.withAlpha(200);
                final darkColors2 = isCurrent ? cs.tertiary : cs.onSurface;

                final isDark = theme.brightness == Brightness.dark;

                final color = isDark ? darkColors : lightColors;
                final timesColor = isDark ? darkColors2 : lightColors2;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PhosphorIcon(p.icon, size: 24, color: color),

                    const SizedBox(height: 4),

                    Text(
                      p.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: color,
                        fontWeight: isCurrent ? FontWeight.bold : null,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Text(
                      _formatHm(t),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: timesColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _TimingTile extends ConsumerWidget {
  const _TimingTile({
    required this.prayer,
    required this.title,
    required this.timeText,
    this.canToggle = true,
  });

  final SalahPrayer prayer;
  final String title;
  final String timeText;
  final bool? canToggle;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final disabled = ref.watch(disabledSalahPrayersProvider);
    final isDisabled = disabled.contains(prayer);

    const actualSalats = {
      SalahPrayer.fajr,
      SalahPrayer.dhuhr,
      SalahPrayer.asr,
      SalahPrayer.maghrib,
      SalahPrayer.isha,
    };

    final showBell = actualSalats.contains(prayer);

    Future<void> toggleSalahReminders() async {
      await ref
          .read(disabledSalahPrayersProvider.notifier)
          .toggle(prayer, context);

      if (!isDisabled && context.mounted) {
        AppToast.showCompact(
          context: context,
          message: 'Disabled reminders for ${prayer.label}',
        );
      }

      if (isDisabled) {
        AppToast.showCompact(
          context: context,
          message: 'Enabled reminders for ${prayer.label}',
        );
      }
    }

    return AnimatedOpacity(
      opacity: isDisabled ? 0.4 : 1,
      duration: 250.ms,
      child: ListTile(
        leading: Icon(prayer.icon, size: 24, color: cs.onSurfaceVariant),
        title: Text(title),
        contentPadding: EdgeInsets.zero,
        onTap: canToggle! ? toggleSalahReminders : null,
        trailing: IntrinsicWidth(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                timeText,
                style: theme.textTheme.labelLarge?.copyWith(fontSize: 16),
              ),

              const SizedBox(width: 8),

              if (showBell)
                IconButton(
                  onPressed: toggleSalahReminders,

                  icon: Icon(
                    isDisabled
                        ? CupertinoIcons.speaker_slash
                        : CupertinoIcons.speaker_3,
                    color: isDisabled
                        ? theme.colorScheme.error
                        : theme.colorScheme.onSurface,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

String _two(int n) => n.toString().padLeft(2, '0');

String _formatHm(DateTime t) => '${_two(t.hour)}:${_two(t.minute)}';
