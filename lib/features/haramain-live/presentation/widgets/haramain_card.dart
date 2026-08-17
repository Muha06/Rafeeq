import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
import 'package:rafeeq/features/haramain-live/presentation/pages/haramain_live_page.dart';
import 'package:rafeeq/features/quran_radio/presentation/pages/radios_list_page.dart';
import 'package:hugeicons_pro/hugeicons.dart';

class LiveHubCard extends ConsumerWidget {
  const LiveHubCard({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE
          Row(
            children: [
              Row(
                children: [
                  Icon(HugeIconsStroke.liveStreaming01, color: cs.onSurface),
                  const SizedBox(width: 8),
                  Text('Live', style: textTheme.labelLarge),
                ],
              ),

              const Spacer(),

              const LiveChip(),
            ],
          ),

        
          const SizedBox(height: 16),

          // HARAMAIN
          _LiveTile(
            title: 'Haramain',
            subtitle: 'Makkah • Madinah live',
            icon: HugeIconsStroke.mosque05,
            onTap: () {
              AppNav.push(
                context,
                const HaramainLivePage(),
              ).then((_) => RafeeqAnalytics.logScreenView("haramain_live"));
            },
          ),

          const SizedBox(height: 12),

          // RADIO
          _LiveTile(
            title: 'Quran Radio',
            subtitle: 'Reciters • Tafsir • Adhkar',
            icon: HugeIconsStroke.radio,
            onTap: () {
              AppNav.push(
                context,
                const RadioListPage(),
              ).then((_) => RafeeqAnalytics.logScreenView("radio_live"));
            },
          ),
        ],
      ),
    );
  }
}

class _LiveTile extends StatelessWidget {
  const _LiveTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.onSurfaceVariant.withAlpha(52)),
        ),
        child: Row(
          children: [
            Icon(icon, color: cs.onSurface),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.labelLarge),
                  const SizedBox(height: 2),
                  Text(subtitle, style: theme.textTheme.labelSmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LiveChip extends StatefulWidget {
  const LiveChip({super.key, this.text = 'LIVE'});

  final String text;

  @override
  State<LiveChip> createState() => _LiveChipState();
}

class _LiveChipState extends State<LiveChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulse = Tween<double>(
      begin: 0.65,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.labelSmall!.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.redAccent, // deep red/near-black
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _pulse,
            builder: (_, _) {
              return Transform.scale(
                scale: _pulse.value,
                child: Container(
                  height: 8,
                  width: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 7),
          Text(widget.text, style: textStyle),
        ],
      ),
    );
  }
}
