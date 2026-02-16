import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

//options

class ThemeOption extends ConsumerWidget {
  final String title;
  final IconData icon;
  final AppThemeMode value;

  const ThemeOption({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(16),
      color: cs.surfaceContainerHighest,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          RadioGroup.maybeOf<AppThemeMode>(context)?.onChanged.call(value);
        },
        child: AnimatedContainer(
          duration: Durations.short2,
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: theme.textTheme.labelLarge)),
              Radio<AppThemeMode>(value: value),
            ],
          ),
        ),
      ),
    );
  }
}
