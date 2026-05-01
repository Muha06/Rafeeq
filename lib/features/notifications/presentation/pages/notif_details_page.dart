import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/url_launcher.dart';
import 'package:rafeeq/core/widgets/app_state_view.dart';
import 'package:rafeeq/features/notifications/presentation/providers/notification_provider.dart';

class NotificationDetailPage extends ConsumerWidget {
  final String notificationId;

  const NotificationDetailPage({super.key, required this.notificationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final cs = theme.colorScheme;
    final notifAsync = ref.watch(notificationByIdProvider(notificationId));

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(title: const Text("Notification")),
        body: notifAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => AppStateView(
            title: 'Failed to load notification',
            message: "Something went wrong. \n Please try again later.",
            buttonText: 'Retry',
            onPressed: () =>
                ref.refresh(notificationByIdProvider(notificationId)),
          ),
          data: (notif) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🖼️ Image (optional)
                  if (notif.imageUrl != null)
                    ClipRRect(
                      child: Image.network(
                        notif.imageUrl!,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          notif.title,
                          style: tt.headlineSmall!.copyWith(
                            color: cs.onSurface,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Divider
                        Container(height: 1, color: cs.outlineVariant),

                        const SizedBox(height: 16),

                        // Body
                        Linkify(
                          text: notif.body,
                          style: tt.bodyLarge,
                          linkStyle: tt.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          onOpen: (link) async {
                            await AppUrlLauncher.openExternal(link.url);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
