import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/features/Ramadan/presentation/providers/ramadan_card_provider.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class RamadanDailyCard extends ConsumerWidget {
  const RamadanDailyCard({super.key});

  String format12h(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final ramadanAsync = ref.watch(ramadanTimesProvider);

    return ramadanAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (times) {
        final suhur = times.suhurEnd;
        final iftar = times.iftar;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: isDark
                ? AppDarkColors.darkSurface
                : AppLightColors.lightSurface,
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              //Card title
              const Text('Ramadan Reflection'),

              Row(
                children: [
                  Expanded(
                    child: BuildRamadanTimeCard(
                      icon: FontAwesomeIcons.cloudSun,
                      title: 'Suhur end',
                      time: format12h(suhur),
                      isDark: isDark,
                    ),
                  ),
                  const Spacer(),

                  Expanded(
                    child: BuildRamadanTimeCard(
                      icon: FontAwesomeIcons.utensils,
                      title: 'Iftar',
                      time: format12h(iftar),
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class BuildRamadanTimeCard extends StatelessWidget {
  const BuildRamadanTimeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.time,
    required this.isDark,
  });

  final IconData icon;
  final String title;
  final String time;
  final bool isDark;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isDark
            ? AppDarkColors.onDarkSurface
            : AppLightColors.onLightSurface,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          //icon
          FaIcon(icon, size: 18),
          const SizedBox(height: 8),

          //title
          Text(title, style: textTheme.bodyMedium),
          const SizedBox(height: 4),

          Text(time, style: textTheme.titleMedium),
        ],
      ),
    );
  }
}
