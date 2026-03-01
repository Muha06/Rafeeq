import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/rafeeq_analytics.dart';
import 'package:rafeeq/features/haramain-live/presentation/pages/haramain_live_page.dart';

class HaramainCard extends ConsumerWidget {
  const HaramainCard({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: cs.surface,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //title
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const FaIcon(FontAwesomeIcons.kaaba),
              const SizedBox(width: 8),
              Text('Haramain • Live', style: textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 4),

          //subtitle
          Text('Live from the sacred mosques', style: textTheme.bodyMedium),
          const SizedBox(height: 8),

          //cards
          const MosqueCard(mosqueName: 'Makkah'),

          const SizedBox(height: 12),

          const MosqueCard(mosqueName: 'Madinah'),
        ],
      ),
    );
  }
}

class MosqueCard extends ConsumerWidget {
  const MosqueCard({super.key, required this.mosqueName});

  final String mosqueName;

  @override
  Widget build(BuildContext context, ref) {
    const makkahLive = 'https://makkahlive.net/makkahlive.aspx';
    const madinahLive = 'https://makkahlive.net/madinalive.aspx';

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: () async {
        final liveUrl = mosqueName == 'Madinah' ? madinahLive : makkahLive;
        final title = mosqueName;

        if (context.mounted) {
          AppNav.push(
            context,
            HaramainAloulaLivePage(title: title, liveUrl: liveUrl),
          ).then((value) => RafeeqAnalytics.logScreenView("haramain_live"));
        }
      },

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: cs.surfaceContainerHighest,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(mosqueName, style: theme.textTheme.labelLarge),
                  const SizedBox(height: 8),

                  const LiveChip(),
                ],
              ),
            ),

            const Spacer(),

            const FaIcon(FontAwesomeIcons.chevronRight, size: 16),
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
