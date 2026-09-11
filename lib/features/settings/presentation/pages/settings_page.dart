import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/helpers/app_haptics.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/features/feedback/presentation/pages/feedback_page.dart';
import 'package:rafeeq/features/settings/presentation/provider/notiffications_controller.dart';
import 'package:rafeeq/features/user/presentation/pages/update_user_name.dart';
import 'package:rafeeq/features/user/presentation/providers/user_provider.dart';

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
          SettingsSection(
            title: 'Reminders',
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
            ],
          ),

          const SizedBox(height: 8),

          SettingsSection(
            title: 'Personalization',
            children: [
              Consumer(
                builder: (_, ref, _) {
                  final userName = ref.watch(userNameProvider);

                  return SettingsTile(
                    leading: const Icon(HugeIconsStroke.user),
                    title: 'Update name',
                    subtitle: 'Change what we call you',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 120),
                          child: Text(
                            userName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                    onTap: () =>
                        AppNav.push(context, const UpdateUserNamePage()),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 8),

          //send feedback
          SettingsSection(
            title: 'Support',
            children: [
              SettingsTile(
                leading: const PhosphorIcon(PhosphorIcons.chatTeardropText),
                title: 'Share Your Thoughts',
                subtitle:
                    'Share your suggestions and make Rafeeq more beneficial, In shaa Allah',
                onTap: () => AppNav.push(context, const FeedbackPage()),
              ),
            ],
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
      title: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Text(title),
      ),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: trailing ?? const Icon(Icons.keyboard_arrow_right, size: 24),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
 
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(title, style: theme.textTheme.labelMedium),
        ),

        ...children,
      ],
    );
  }
}
