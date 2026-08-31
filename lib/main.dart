import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rafeeq/app/connectivity_plus/app_wrapper.dart';
import 'package:rafeeq/core/constants/hive_boxes.dart';
import 'package:rafeeq/core/features/local_notifications/providers/general_notifications_provider.dart';
import 'package:rafeeq/core/helpers/app_update_service.dart';
import 'package:rafeeq/features/home/presentation/pages/tabs_screen.dart';
import 'package:rafeeq/core/app_keys.dart';
import 'package:rafeeq/core/features/audio/data/audio_handler.dart';
import 'package:rafeeq/core/features/local_notifications/repository/local_notifs_service.dart';
import 'package:rafeeq/core/themes/dark_theme.dart';
import 'package:rafeeq/core/themes/light_theme.dart';
import 'package:rafeeq/features/adhkar/data/models/hive/adhkar_hive_wrapper.dart';
import 'package:rafeeq/features/adhkar/data/models/hive/category_hive_wrapper.dart';
import 'package:rafeeq/features/adhkar/data/models/hive/dhikr_category_hive.dart';
import 'package:rafeeq/features/adhkar/data/models/hive/dhikr_hive_model.dart';
import 'package:rafeeq/features/notifications/data/datasources/app_notifications_remote_ds.dart';
import 'package:rafeeq/features/notifications/data/datasources/push_notification_services.dart';
import 'package:rafeeq/features/asma_ul_husna/data/models/hive/name_hive_model.dart';
import 'package:rafeeq/features/bookmarks/data/models/dhikr_bookmark_hive_model.dart';
import 'package:rafeeq/features/bookmarks/data/models/quran_bookmark_hive_model.dart';
import 'package:rafeeq/features/onboarding/presentation/pages/onboarding_scaffold.dart';
import 'package:rafeeq/features/onboarding/presentation/provider/providers.dart';
import 'package:rafeeq/features/quran/data/dataSources/quran_db_manager.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/ayah_of_day_scheduler.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/wiring_providers.dart';
import 'package:rafeeq/features/quran_audio/data/models/hive/reciter_playlist_tracks_hive.dart';
import 'package:rafeeq/features/quran_audio/data/models/hive/surah_track_hive.dart';
import 'package:rafeeq/features/quran_goal/data/models/hive/quran_goal_hive.dart';
import 'package:rafeeq/features/quran_goal/data/models/hive/quran_goal_type_hive.dart';
import 'package:rafeeq/features/quran_goal/data/models/hive/quran_log_hive.dart';
import 'package:rafeeq/features/quran_goal/data/models/hive/quran_target_unit_hive.dart';
import 'package:rafeeq/features/timings/data/models/hive/cached_salah_times_hive.dart';
import 'package:rafeeq/firebase_options.dart';
import 'package:smooth_sheets/smooth_sheets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rafeeq/core/features/audio/presentation/providers/audio_handler_provider.dart';

late AppAudioHandler audioHandler;

void main() {
  // Run everything in a single guarded zone
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize Firebase
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
        !kDebugMode,
      );
      if (kDebugMode) {
        FlutterError.onError = FlutterError.dumpErrorToConsole;
      } else {
        FlutterError.onError =
            FirebaseCrashlytics.instance.recordFlutterFatalError;
      }
      // Load env
      await dotenv.load(fileName: ".env");

      // Initialize Supabase
      await Supabase.initialize(
        url: dotenv.env['SUPABASE_URL']!,
        publishableKey: dotenv.env['SUPABASE_ANON_KEY']!,
      );

      //Initialize audio handler
      audioHandler = await AudioService.init(
        builder: () => AppAudioHandler(),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'rafeeq.audio',
          androidNotificationChannelName: 'Audio Playback',
          androidStopForegroundOnPause: false,
          androidShowNotificationBadge: true,
          androidNotificationIcon: 'mipmap/ic_launcher',
        ),
      );

      // Initialize Hive
      await Hive.initFlutter();

      // Register Hive adapters
      Hive.registerAdapter(QuranGoalHiveAdapter()); // TypeId = 10
      Hive.registerAdapter(QuranGoalTypeHiveAdapter()); // TypeId = 11
      Hive.registerAdapter(QuranTargetUnitHiveAdapter()); // TypeId = 11
      Hive.registerAdapter(QuranHiveLogAdapter()); // TypeId = 11
      Hive.registerAdapter(AllahNameHiveAdapter()); // TypeId = 30
      Hive.registerAdapter(QuranBookmarkHiveModelAdapter()); // TypeId = 31
      Hive.registerAdapter(DhikrBookmarkHiveModelAdapter()); // TypeId = 32
      Hive.registerAdapter(DhikrCategoryHiveAdapter()); // TypeId = 33
      Hive.registerAdapter(DhikrHiveModelAdapter()); // TypeId = 34
      Hive.registerAdapter(CategoryCacheHiveAdapter()); // TypeId = 35
      Hive.registerAdapter(AdhkarHiveWrapperAdapter()); // TypeId = 36
      Hive.registerAdapter(CachedSalahTimesHiveAdapter()); // TypeId = 41
      Hive.registerAdapter(ReciterPlaylistTracksHiveAdapter()); // TypeId = 37
      Hive.registerAdapter(SurahTrackHiveAdapter()); // TypeId = 37

      // Open Hive boxes
      await Hive.openBox<QuranGoalHive>('quran_goal');
      await Hive.openBox<QuranHiveLog>('quran_logs');
      await Hive.openBox<QuranBookmarkHiveModel>('quran_bookmarks_box');
      await Hive.openBox<DhikrBookmarkHiveModel>('dhikr_bookmarks_box');
      await Hive.openBox<List<dynamic>>('adhkar_cache');
      await Hive.openBox('lastReadBox');
      await Hive.openBox<AllahNameHive>('allah_names_box');
      await Hive.openBox<CachedSalahTimesHive>('salah_times_cache_box');
      await Hive.openBox('settingsBox');
      await Hive.openBox('read_notifications');
      await Hive.openBox('adhkar_cache_box');
      await Hive.openBox<ReciterPlaylistTracksHive>(
        HiveBoxes.reciterPlaylistTracks,
      );

      // Notifications
      await LocalNotificationService().init();
      final supabase = Supabase.instance.client;

      final notificationRemoteDataSource = NotificationRemoteDataSource(
        supabase,
      );

      final pushService = PushNotificationService(
        notificationRemoteDataSource: notificationRemoteDataSource,
      );

      await pushService.init();
      final quranDbsManager = QuranDatabaseManager();
      await quranDbsManager.init();

      runApp(
        ProviderScope(
          overrides: [
            audioHandlerProvider.overrideWithValue(audioHandler),
            quranDbsManagerProvider.overrideWithValue(quranDbsManager),
          ],
          child: const MyApp(),
        ),
      );
    },
    (error, stack) async {
      if (!kDebugMode) {
        await FirebaseCrashlytics.instance.recordError(
          error,
          stack,
          fatal: true,
        );
      }
    },
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  final AppUpdateService _updateService = const AppUpdateService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bootstrap();

      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
      );
    });
  }

  Future<void> _bootstrap() async {
    final hasSeen = ref.read(hasSeenOnboardingProvider);
    if (!hasSeen) return;

    //SYNC
    await ref.read(systemNotifAccessProvider.notifier).sync();

    // Schedule ayah of day notifications
    await ref.read(ayahNotificationSchedulerProvider.notifier).schedule();

    await _updateService.checkForUpdate(type: AppUpdateType.flexible);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    final hasSeenOnboarding = ref.watch(hasSeenOnboardingProvider);

    return MaterialApp(
      title: 'Rafeeq',
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
      theme: appLightThemeData(),
      darkTheme: appDarkThemeData(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: SheetViewport(
        child: hasSeenOnboarding
            ? const AppWrapper(child: TabsScreen())
            : const OnboardingPage(),
      ),
    );
  }
}
