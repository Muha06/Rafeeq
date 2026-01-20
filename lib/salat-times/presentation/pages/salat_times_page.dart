import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

import '../../domain/entities/salah_prayer.dart';
import '../riverpod/salah_times_providers.dart';

class SalahTimingsPage extends ConsumerWidget {
  const SalahTimingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final timesAsync = ref.watch(todaySalahTimesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Salah Timings'),
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
            SalahPrayer.dhuhr,
            SalahPrayer.asr,
            SalahPrayer.maghrib,
            SalahPrayer.isha,
          ];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _HeaderChipRow(
                dateText: _formatDate(times.date),
                timezone: times.timezone,
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

class _HeaderChipRow extends StatelessWidget {
  const _HeaderChipRow({required this.dateText, required this.timezone});

  final String dateText;
  final String timezone;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 18,
      runSpacing: 10,
      children: [
        _Chip(text: dateText, icon: Icons.calendar_today_rounded),
        _Chip(text: timezone, icon: Icons.public_rounded),
      ],
    );
  }
}

class _Chip extends ConsumerWidget {
  const _Chip({required this.text, required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? AppDarkColors.darkSurface
            : theme.colorScheme.surfaceContainerHighest.withOpacity(0.6),
        borderRadius: BorderRadius.circular(999),
      ),
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
