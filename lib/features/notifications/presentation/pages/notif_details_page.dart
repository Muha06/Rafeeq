import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          error: (e, _) => Center(child: Text("Error: $e")),
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
                        Text(notif.body, style: tt.bodyLarge),
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
