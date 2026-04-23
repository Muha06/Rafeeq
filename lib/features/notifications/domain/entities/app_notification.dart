class AppNotification {
  final String id;
  final String title;
  final String body;
  final String? imageUrl;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    this.isRead = false,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    String? imageUrl,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      isRead: isRead ?? this.isRead,
    );
  }
}
