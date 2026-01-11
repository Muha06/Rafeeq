import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  void showThemePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const ThemePickerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = ref.read(isDarkProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: theme.appBarTheme.titleTextStyle),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          //theme preferences
          Material(
            color: Colors.transparent,
            child: ListTile(
              splashColor: isDark
                  ? AppDarkColors.darkSurface
                  : AppLightColors.lightSurface,
              onTap: () {
                showThemePicker(context);
              },
              leading: const SizedBox(
                height: 48,
                width: 48,
                child: Icon(CupertinoIcons.paintbrush),
              ),
              title: Text('Theme', style: theme.textTheme.titleMedium),
              subtitle: Text(
                'Change the app theme',
                style: theme.textTheme.bodySmall,
              ),
              trailing: const Icon(Icons.keyboard_arrow_right, size: 32),
            ),
          ),
        ],
      ),
    );
  }
}

//theme picker
class ThemePickerSheet extends ConsumerStatefulWidget {
  const ThemePickerSheet({super.key});

  @override
  ConsumerState<ThemePickerSheet> createState() => _ThemePickerSheetState();
}

class _ThemePickerSheetState extends ConsumerState<ThemePickerSheet> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mode = ref.watch(themeModeProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: RadioGroup(
        groupValue: mode,
        onChanged: (value) {
          //todo: persist with Hive
          setState(() {
            ref.read(themeModeProvider.notifier).state = value!;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 6,
              width: 48,
              decoration: BoxDecoration(
                color: AppLightColors.textSecondary,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Theme',
              style: theme.textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            const _ThemeOption(
              title: 'Light mode',
              icon: CupertinoIcons.sun_max,
              value: AppThemeMode.light,
            ),
            const SizedBox(height: 12),

            const _ThemeOption(
              title: 'Dark mode',
              icon: CupertinoIcons.moon,
              value: AppThemeMode.dark,
            ),
            const SizedBox(height: 8),

            const _ThemeOption(
              title: 'Same as device theme',
              icon: CupertinoIcons.device_phone_portrait,
              value: AppThemeMode.system,
            ),
            const SizedBox(height: 8),

            //divider
            Divider(color: theme.dividerColor),
            const SizedBox(height: 0),

            //cancel btn
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Close',
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//options
class _ThemeOption extends ConsumerWidget {
  final String title;
  final IconData icon;
  final AppThemeMode value;

  const _ThemeOption({
    required this.title,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final mode = ref.watch(themeModeProvider);
    final isDark = mode == AppThemeMode.dark;
    bool selected = mode == value;

    return Material(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(16),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: isDark
            ? AppDarkColors.textSecondary.withAlpha(35)
            : AppLightColors.textSecondary.withAlpha(35),
        onTap: () {
          RadioGroup.maybeOf<AppThemeMode>(context)?.onChanged.call(value);
        },
        child: AnimatedContainer(
          duration: Durations.short2,
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppLightColors.amber : theme.dividerColor,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: theme.textTheme.titleSmall)),
              Radio<AppThemeMode>(value: value),
            ],
          ),
        ),
      ),
    );
  }
}
