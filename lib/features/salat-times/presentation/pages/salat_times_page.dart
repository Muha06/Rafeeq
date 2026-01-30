import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/location/presentation/provider/user_location_provider.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

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
                children: [
                  Chip(text: formattedDate, icon: Icons.date_range),

                  GestureDetector(
                    onTap: () async {
                      await ref.read(userLocationProvider.notifier).refresh();
                      await ref.refresh(todaySalahTimesProvider.future);
                    },
                    child: Chip(
                      text: userLoc.when(
                        loading: () => 'Loading',
                        error: (error, stackTrace) => 'Unknown',
                        data: (loc) => '${loc?.country}/${loc?.city}',
                      ),
                      icon: Icons.refresh,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              ...order.map((p) {
                final t = times.at(p);
                return _TimingTile(title: p.label, timeText: _formatHm(t));
              }),
            ],
          );
        },
      ),
    );
  }
}

class Chip extends ConsumerWidget {
  const Chip({super.key, required this.text, required this.icon});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: theme.textTheme.bodyMedium!.copyWith(
              color: isDark
                  ? AppDarkColors.textPrimary
                  : AppLightColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimingTile extends StatelessWidget {
  const _TimingTile({required this.title, required this.timeText});

  final String title;
  final String timeText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            timeText,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
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
