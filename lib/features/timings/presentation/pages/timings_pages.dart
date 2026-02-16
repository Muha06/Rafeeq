import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rafeeq/core/features/location/presentation/provider/user_location_provider.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
import 'package:rafeeq/core/widgets/snackbars.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/disable_salah_reminders_provider.dart';

import '../../domain/entities/salah_prayer.dart';
import '../riverpod/salah_times_providers.dart';

class SalahTimingsPage extends ConsumerStatefulWidget {
  const SalahTimingsPage({super.key});

  @override
  ConsumerState<SalahTimingsPage> createState() => _SalahTimingsPageState();
}

class _SalahTimingsPageState extends ConsumerState<SalahTimingsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final timesAsync = ref.watch(todaySalahTimesProvider);
    final userLoc = ref.watch(userLocationProvider);
    final formattedDate = _formatDate(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Timings'),
        bottom: appBarBottomDivider(context),
      ),
      body: timesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Failed to load timings.\n$e',
            style: theme.textTheme.bodyMedium,
          ),
        ),
        data: (times) {
          final order = const [
            SalahPrayer.fajr,
            SalahPrayer.sunrise,
            SalahPrayer.dhuha,
            SalahPrayer.dhuhr,
            SalahPrayer.asr,
            SalahPrayer.maghrib,
            SalahPrayer.isha,
            SalahPrayer.tahajjud,
          ];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Chip(text: formattedDate, icon: Icons.date_range),

                  Chip(
                    text: userLoc.when(
                      loading: () => 'Loading',
                      error: (error, stackTrace) => 'Unknown',
                      data: (loc) => '${loc?.country}/${loc?.city}',
                    ),
                    icon: Icons.pin_drop_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              ...order.map((p) {
                final t = times.at(p);
                return _TimingTile(
                  prayer: p,
                  title: p.label,
                  timeText: _formatHm(t),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class Chip extends StatelessWidget {
  const Chip({super.key, required this.text, required this.icon});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),

          Text(text, style: theme.textTheme.labelLarge),
        ],
      ),
    );
  }
}

class _TimingTile extends ConsumerWidget {
  const _TimingTile({
    required this.prayer,
    required this.title,
    required this.timeText,
  });

  final SalahPrayer prayer;
  final String title;
  final String timeText;

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

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FaIcon(prayer.icon, size: 16),
          const SizedBox(width: 8),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: theme.textTheme.labelLarge),
              const SizedBox(height: 12),
              //time
              Text(timeText, style: theme.textTheme.titleMedium),
            ],
          ),

          const Spacer(),

          if (showBell)
            IconButton(
              onPressed: () async {
                await ref
                    .read(disabledSalahPrayersProvider.notifier)
                    .toggle(prayer);

                if (!isDisabled) {
                  AppSnackBar.showSimple(
                    context: context,
                    isDark: ref.read(isDarkProvider),
                    message: 'Disabled reminders for ${prayer.label}',
                  );
                }
              },

              icon: FaIcon(
                isDisabled ? FontAwesomeIcons.bellSlash : FontAwesomeIcons.bell,
                color: isDisabled
                    ? theme.colorScheme.error
                    : theme.colorScheme.onSurface,
              ),
            ),
        ],
      ),
    );
  }
}

String _two(int n) => n.toString().padLeft(2, '0');

String _formatHm(DateTime t) => '${_two(t.hour)}:${_two(t.minute)}';

String _formatDate(DateTime d) => '${_two(d.day)}-${_two(d.month)}-${d.year}';
