import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
import 'package:rafeeq/core/helpers/snackbars.dart';
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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final timesAsync = ref.watch(fetchTodaySalahTimesProvider);

    return timesAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),

      error: (e, _) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Failed to load timings.\n$e',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ),

      data: (times) {
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
              bottom: appBarBottomDivider(context),
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 100,
                  child: AllSalatTimingsCard(times: times, current: current),
                ),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 8),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
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
                        Text('Other Times', style: theme.textTheme.labelSmall),
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
        );
      },
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
      children: [
        //image
        Image.asset('assets/images/salah/masjid_dark.jpeg', fit: BoxFit.cover),

        //DARK OVERLAY
        const DecoratedBox(decoration: BoxDecoration(color: Colors.black38)),

        Center(
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: salats.map((p) {
                final t = times.at(p);
                final isCurrent = p == current;

                final lightColors = isCurrent
                    ? Colors.amber
                    : cs.onPrimary.withAlpha(200);
                final lightColors2 = isCurrent ? Colors.amber : cs.onPrimary;

                final darkColors = isCurrent
                    ? Colors.amber
                    : cs.onSurface.withAlpha(200);
                final darkColors2 = isCurrent ? Colors.amber : cs.onSurface;

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
                        fontWeight: FontWeight.bold,
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
      await ref.read(disabledSalahPrayersProvider.notifier).toggle(prayer);

      if (!isDisabled && context.mounted) {
        AppSnackBar.showSimple(
          context: context,
          message: 'Disabled reminders for ${prayer.label}',
        );
      }
    }

    return ListTile(
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
                      : CupertinoIcons.speaker_1,
                  color: isDisabled
                      ? theme.colorScheme.error
                      : theme.colorScheme.onSurface,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

String _two(int n) => n.toString().padLeft(2, '0');

String _formatHm(DateTime t) => '${_two(t.hour)}:${_two(t.minute)}';
