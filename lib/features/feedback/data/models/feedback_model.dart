class FeedbackItem {
  final String id;
  final String message;
  final DateTime createdAt;
  final String? appVersion;
  final String status;

  const FeedbackItem({
    required this.id,
    required this.message,
    required this.createdAt,
    this.appVersion,
    required this.status,
  });

  /// Create empty instance for new submissions
  factory FeedbackItem.create({required String message, String? appVersion}) {
    return FeedbackItem(
      id: '',
      message: message,
      createdAt: DateTime.now(),
      appVersion: appVersion,
      status: 'new',
    );
  }

  /// From Supabase map
  factory FeedbackItem.fromMap(Map<String, dynamic> map) {
    return FeedbackItem(
      id: map['id'] as String,
      message: map['message'] as String,
      createdAt: DateTime.parse(map['created_at']),
      appVersion: map['app_version'] as String?,
      status: map['status'] as String,
    );
  }

  /// To Supabase map (for insert)
  Map<String, dynamic> toMap() {
    return {'message': message, 'app_version': appVersion, 'status': status};
  }

  FeedbackItem copyWith({
    String? id,
    String? message,
    DateTime? createdAt,
    String? appVersion,
    String? status,
  }) {
    return FeedbackItem(
      id: id ?? this.id,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      appVersion: appVersion ?? this.appVersion,
      status: status ?? this.status,
    );
  }
}
