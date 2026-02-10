import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/features/Ramadan/domain/ramadan_reflection.dart';
import 'package:rafeeq/features/Ramadan/presentation/providers/ramadan_timings_provider.dart';
import 'package:rafeeq/features/Ramadan/presentation/providers/ramadan_reflections_provider.dart';
import 'package:rafeeq/features/Ramadan/presentation/widgets/reflection_bottom_sheet.dart';
import 'package:rafeeq/features/calendar/presentation/providers/hijri_date_providers.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class RamadanDailyCard extends ConsumerStatefulWidget {
  const RamadanDailyCard({super.key});

  @override
  ConsumerState<RamadanDailyCard> createState() => _RamadanDailyCardState();
}

class _RamadanDailyCardState extends ConsumerState<RamadanDailyCard> {
  String format12h(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final ramadanAsync = ref.watch(ramadanTimesProvider);
    final hijri = ref.watch(hijriDateProvider).hijri;

    final reflection = ref.watch(ramadanReflectionByDayProvider(hijri));

    if (reflection == null) {
      return const SizedBox.shrink();
    }

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RamadanHeader(isDark: isDark, reflection: reflection),

              const SizedBox(height: 12),

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

              const SizedBox(height: 12),

              Divider(
                height: 1,
                thickness: 1,
                color: (isDark ? Colors.white : Colors.black).withAlpha(18),
              ),

              const SizedBox(height: 12),

              RamadanReflectionPreview(
                reflection: reflection,
                isDark: isDark,
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) =>
                      RamadanReflectionSheet(reflection: reflection),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RamadanHeader extends StatelessWidget {
  const _RamadanHeader({required this.isDark, required this.reflection});

  final bool isDark;
  final RamadanReflection reflection;
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(child: Text('Ramadan Today', style: tt.titleMedium)),
        TypeChip(label: 'Day ${reflection.day}', isDark: isDark),
      ],
    );
  }
}

class RamadanReflectionPreview extends StatelessWidget {
  const RamadanReflectionPreview({
    super.key,
    required this.reflection,
    required this.isDark,
    this.onTap,
  });

  final RamadanReflection reflection;
  final bool isDark;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    final bg = isDark
        ? AppDarkColors.onDarkSurface
        : AppLightColors.onLightSurface;

    final label = switch (reflection.type) {
      ReminderType.quran => 'Qur’an',
      ReminderType.hadith => 'Hadith',
      ReminderType.narration => 'Narration',
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: type chip + "Read"
            Row(
              children: [
                TypeChip(label: label, isDark: isDark),
                const Spacer(),
                Text(
                  'Read',
                  style: tt.labelMedium!.copyWith(
                    color: isDark
                        ? AppDarkColors.amber
                        : AppLightColors.textPrimary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Topic
            Text(reflection.topic, style: tt.titleMedium),

            const SizedBox(height: 8),

            // Main text preview
            Text(
              reflection.mainText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: tt.bodyMedium,
            ),

            const SizedBox(height: 10),

            // Source label
            Text(reflection.sourceLabel, style: tt.labelSmall),

            // Optional lesson preview (super subtle)
            if (reflection.lesson != null &&
                reflection.lesson!.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                reflection.lesson!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: tt.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class TypeChip extends StatelessWidget {
  const TypeChip({super.key, required this.label, required this.isDark});

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: (isDark ? AppDarkColors.tealSoft : AppLightColors.amber),
      ),
      child: Text(
        label,
        style: tt.labelMedium!.copyWith(
          color: isDark ? AppDarkColors.textPrimary : Colors.black,
        ),
      ),
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
