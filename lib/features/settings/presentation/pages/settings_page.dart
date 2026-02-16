import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rafeeq/app/providers/general_notifications_provider.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
import 'package:rafeeq/core/widgets/snackbars.dart';
import 'package:rafeeq/features/settings/presentation/provider/settings_notifcation_provider.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';
import 'package:rafeeq/features/settings/presentation/widgets/settings_page_widgets.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  void showThemePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (context) => const ThemePickerSheet(),
    );
  }

  //called when user toggles salah reminder settings
  // Add/ remove salah reminders
  Future<void> setSalahNotif(WidgetRef ref, bool enabled) async {
    final updating = ref.read(salahNotifUpdatingProvider);
    if (updating) return;

    ref.read(salahNotifUpdatingProvider.notifier).state = true;

    try {
      final access = ref.read(systemNotifAccessProvider);
      final sys = ref.read(systemNotifAccessProvider.notifier);

      // If user is disabling: no permission drama needed.
      if (!enabled) {
        final box = ref.read(settingsBoxProvider);
        await box.put(kSalahEnabled, false);
        ref.read(salahNotifEnabledProvider.notifier).state = false;
        return;
      }

      // Enabling: ensure required permissions exist
      if (!access.notificationsAllowed || !access.exactAlarmsAllowed) {
        final allAllowed = await sys.requestAll(includeExactAlarms: true);

        if (!allAllowed) {
          // Permission denied -> keep feature OFF (and revert UI toggle)
          final box = ref.read(settingsBoxProvider);
          await box.put(kSalahEnabled, false);
          ref.read(salahNotifEnabledProvider.notifier).state = false;

          AppSnackBar.showSimple(
            context: context,
            isDark: ref.read(isDarkProvider),
            message: 'notofication permissions denied.',
          );
          return;
        }
      }

      // Now safe to enable
      final box = ref.read(settingsBoxProvider);
      await box.put(kSalahEnabled, true);
      ref.read(salahNotifEnabledProvider.notifier).state = true;

      AppSnackBar.showSimple(
        context: context,
        isDark: ref.read(isDarkProvider),
        message: '✅ Scheduling salah reminders...',
      );
    } finally {
      ref.read(salahNotifUpdatingProvider.notifier).state = false;
    }
  }

  //Add/ remove adhkar reminders
  Future<void> setAdhkarNotif(WidgetRef ref, bool enabled) async {
    final updating = ref.read(adhkarNotifUpdatingProvider);
    if (updating) return;

    // lock ASAP
    ref.read(adhkarNotifUpdatingProvider.notifier).state = true;

    try {
      final access = ref.read(systemNotifAccessProvider);
      final sys = ref.read(systemNotifAccessProvider.notifier);

      // If user is disabling: no permission drama needed.
      if (!enabled) {
        final box = ref.read(settingsBoxProvider);
        await box.put(kAdhkarEnabled, false);
        ref.read(adhkarNotifEnabledProvider.notifier).state = false;
        return;
      }

      // Enabling: ensure required permissions exist
      if (!access.notificationsAllowed || !access.exactAlarmsAllowed) {
        final allAllowed = await sys.requestAll(includeExactAlarms: true);

        if (!allAllowed) {
          // Permission denied -> keep feature OFF (and ideally revert UI toggle)
          final box = ref.read(settingsBoxProvider);
          await box.put(kAdhkarEnabled, false);
          ref.read(adhkarNotifEnabledProvider.notifier).state = false;

          AppSnackBar.showSimple(
            context: context,
            isDark: ref.read(isDarkProvider),
            message: 'Permissions denied',
          );
          return;
        }
      }

      // Now safe to enable
      final box = ref.read(settingsBoxProvider);
      await box.put(kAdhkarEnabled, true);
      ref.read(adhkarNotifEnabledProvider.notifier).state = true;

      AppSnackBar.showSimple(
        context: context,
        isDark: ref.read(isDarkProvider),
        message: '✅ Turning on adhkar reminders...',
      );
    } finally {
      ref.read(adhkarNotifUpdatingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    final adhkarOn = ref.watch(adhkarNotifEnabledProvider);
    final salahNotifOn = ref.watch(salahNotifEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: theme.appBarTheme.titleTextStyle),
        bottom: appBarBottomDivider(context),
      ),
      body: ListView(
        children: [
          //theme preferences
          SettingsTile(
            leading: const FaIcon(FontAwesomeIcons.paintRoller),
            title: 'App Theme',
            isDark: isDark,
            trailing: const Icon(Icons.keyboard_arrow_right),
            subtitle: 'Change the app theme',
            onTap: () => showThemePicker(context),
          ),

          SettingsTile(
            leading: const FaIcon(FontAwesomeIcons.bell),
            title: 'Salah reminders',
            subtitle: 'Get Salah times reminders',
            isDark: isDark,
            trailing: Switch(
              value: salahNotifOn,
              onChanged: (val) {
                setSalahNotif(ref, val);
              },
            ),
          ),

          SettingsTile(
            leading: const FaIcon(FontAwesomeIcons.bell),
            title: 'Adhkar reminders',
            subtitle: 'Morning & evening adhkars',
            isDark: isDark,
            trailing: Switch(
              value: adhkarOn,
              onChanged: (val) {
                setAdhkarNotif(ref, val);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool isDark;
  final Widget? trailing;
  final EdgeInsetsGeometry? contentPadding;
  final bool enabled;

  const SettingsTile({
    super.key,
    required this.leading,
    required this.title,
    required this.isDark,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.contentPadding,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          enabled: enabled,

          onTap: enabled ? onTap : null,
          contentPadding:
              contentPadding ?? const EdgeInsets.symmetric(horizontal: 16),
          leading: leading,
          title: Text(title, style: theme.textTheme.titleMedium),
          subtitle: subtitle == null
              ? null
              : Text(subtitle!, style: theme.textTheme.labelMedium),
          trailing:
              trailing ?? const Icon(Icons.keyboard_arrow_right, size: 32),
        ),
        Divider(color: theme.dividerColor),
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
            Text('Theme', style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),

            const ThemeOption(
              title: 'Light mode',
              icon: CupertinoIcons.sun_max,
              value: AppThemeMode.light,
            ),
            const SizedBox(height: 12),

            const ThemeOption(
              title: 'Dark mode',
              icon: CupertinoIcons.moon,
              value: AppThemeMode.dark,
            ),
            const SizedBox(height: 8),

            const ThemeOption(
              title: 'Same as device theme',
              icon: CupertinoIcons.device_phone_portrait,
              value: AppThemeMode.system,
            ),
            const SizedBox(height: 8),

            //divider
            Divider(color: theme.dividerColor),

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
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
