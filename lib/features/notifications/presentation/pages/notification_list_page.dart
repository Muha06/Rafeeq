import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/features/notifications/domain/entities/app_notification.dart';
import 'package:rafeeq/features/notifications/presentation/pages/notif_details_page.dart';
import 'package:rafeeq/features/notifications/presentation/providers/notification_provider.dart';

class NotificationsInboxPage extends ConsumerWidget {
  const NotificationsInboxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(allNotificationsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: notificationsAsync.when(
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState(error: e.toString()),
        data: (notifications) {
          if (notifications.isEmpty) {
            return const EmptyState();
          }

          return NotificationsList(
            notifications: notifications,
            onRefresh: () =>
                ref.read(allNotificationsProvider.notifier).refresh(),
          );
        },
      ),
    );
  }
}

class NotificationsList extends StatelessWidget {
  final List<AppNotification> notifications;
  final Future<void> Function() onRefresh;

  const NotificationsList({
    super.key,
    required this.notifications,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: notifications.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return NotificationTile(notification: notifications[index]);
        },
      ),
    );
  }
}

class NotificationTile extends ConsumerWidget {
  final AppNotification notification;

  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context, ref) {
    final isRead = notification.isRead;
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final cs = theme.colorScheme;

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          AppNav.push(
            context,
            NotificationDetailPage(notificationId: notification.id),
          );

          await ref
              .read(allNotificationsProvider.notifier)
              .markAsRead(notification.id);
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Unread dot
              if (!isRead)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),

              PhosphorIcon(PhosphorIcons.bell()),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notification.title, style: tt.labelLarge),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tt.bodyMedium,
                    ),
                  ],
                ),
              ),

              PhosphorIcon(PhosphorIcons.caretRight(), size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("No notifications yet"));
  }
}

class ErrorState extends StatelessWidget {
  final String error;

  const ErrorState({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Something went wrong: $error"));
  }
}
