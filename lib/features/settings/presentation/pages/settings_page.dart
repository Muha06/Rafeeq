import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/helpers/app_haptics.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/features/feedback/presentation/pages/feedback_page.dart';
import 'package:rafeeq/features/settings/presentation/provider/notiffications_controller.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: theme.appBarTheme.titleTextStyle),
      ),
      body: ListView(
        children: [
          SettingsTile(
            leading: const PhosphorIcon(PhosphorIcons.bell),
            title: 'Salah reminders',
            subtitle: 'Get Salah reminders',
            trailing: Consumer(
              builder: (context, ref, _) {
                final enabled = ref.watch(salahNotifControllerProvider);
                final controller = ref.read(
                  salahNotifControllerProvider.notifier,
                );

                return Switch(
                  value: enabled,
                  onChanged: (val) {
                    AppHaptics.light();

                    controller.toggleSalahReminders(val, context);
                  },
                );
              },
            ),
          ),

          SettingsTile(
            leading: const PhosphorIcon(PhosphorIcons.bell),
            title: 'Adhkar reminders',
            subtitle: 'Morning & evening adhkars reminders',
            trailing: Consumer(
              builder: (context, ref, _) {
                final enabled = ref.watch(adhkarNotifControllerProvider);
                final controller = ref.read(
                  adhkarNotifControllerProvider.notifier,
                );

                return Switch(
                  value: enabled,
                  onChanged: (val) {
                    AppHaptics.light();

                    controller.toggleAdhkarReminders(val, context);
                  },
                );
              },
            ),
          ),

          //send feedback
          SettingsTile(
            leading: const PhosphorIcon(PhosphorIcons.chatTeardropText),
            title: 'Share Your Thoughts',
            subtitle:
                'Share your suggestions and make Rafeeq more beneficial, In shaa Allah',
            onTap: () => AppNav.push(context, const FeedbackPage()),
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
  final Widget? trailing;
  final EdgeInsetsGeometry? contentPadding;
  final bool enabled;

  const SettingsTile({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.contentPadding,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: enabled,
      onTap: enabled ? onTap : null,
      contentPadding:
          contentPadding ?? const EdgeInsets.symmetric(horizontal: 16),
      leading: leading,
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: trailing ?? const Icon(Icons.keyboard_arrow_right, size: 24),
    );
  }
}
