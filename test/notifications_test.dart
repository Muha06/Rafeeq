import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rafeeq/features/notifications/data/datasources/app_notifications_remote_ds.dart';
import 'package:rafeeq/features/notifications/data/models/app_notification_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  late SupabaseClient supabase;
  late NotificationRemoteDataSource ds;
  setUpAll(() async {
    await dotenv.load(fileName: ".env");

    // Initialize Supabase
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );

    supabase = Supabase.instance.client;
    ds = NotificationRemoteDataSource(supabase);
  });

  tearDown(() async {
    await supabase.from('notifications').delete().eq('type', 'test');
  });
  
  group('NotificationRemoteDataSource', () {
    test('should fetch notification by id', () async {
      // arrange: insert test data first
      final insert = await supabase
          .from('notifications')
          .insert({
            'title': 'Test Notification',
            'body': 'Hello world',
            'type': 'test',
          })
          .select()
          .single();

      final id = insert['id'];

      // act
      final result = await ds.getNotificationById(id);

      // assert
      expect(result.title, 'Test Notification');
      expect(result.body, 'Hello world');
    });

    test('should return list of notifications', () async {
      // ARRANGE: insert test data
      await supabase.from('notifications').insert([
        {'title': 'Notif 1', 'body': 'Body 1', 'type': 'test'},
        {'title': 'Notif 2', 'body': 'Body 2', 'type': 'test'},
      ]);

      // ACT
      final result = await ds.getAllNotifications();

      // ASSERT
      expect(result, isA<List<AppNotificationModel>>());
      expect(result.length, greaterThanOrEqualTo(2));

      expect(result.first.title, isNotEmpty);
    });
  });
}
