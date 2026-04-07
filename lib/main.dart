import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rafeeq/app/connectivity_plus/app_wrapper.dart';
import 'package:rafeeq/app/notifications.dart';
import 'package:rafeeq/app/providers/general_notifications_provider.dart';
import 'package:rafeeq/app/tabs_screen.dart';
import 'package:rafeeq/core/app_keys.dart';
import 'package:rafeeq/core/themes/dark_theme.dart';
import 'package:rafeeq/core/themes/light_theme.dart';
import 'package:rafeeq/features/adhkar/data/models/dhikr_hive_model.dart';
import 'package:rafeeq/features/quran/data/models/ayah_hive.dart';
import 'package:rafeeq/features/quran/data/models/surah_hive.dart';
import 'package:rafeeq/features/asma_ul_husna/data/models/hive/name_hive_model.dart';
import 'package:rafeeq/features/bookmarks/data/models/dhikr_bookmark_hive_model.dart';
import 'package:rafeeq/features/bookmarks/data/models/quran_bookmark_hive_model.dart';
import 'package:rafeeq/features/onboarding/presentation/pages/onboarding_scaffold.dart';
import 'package:rafeeq/features/onboarding/presentation/provider/providers.dart';
import 'package:rafeeq/features/quran_reading_plan/data/models/quran_reading_plan_hive.dart';
import 'package:rafeeq/features/quran_reading_plan/data/models/quran_log_hive.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/salah_times_providers.dart';
import 'package:rafeeq/features/settings/presentation/provider/settings_notifcation_provider.dart';
import 'package:rafeeq/features/timings/data/models/hive/cached_salah_times_hive.dart';
import 'package:rafeeq/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  // Make zone errors fatal before binding init
  BindingBase.debugZoneErrorsAreFatal = false;

  // Ensure Flutter bindings in the root zone
  WidgetsFlutterBinding.ensureInitialized();

  // Run everything in a single guarded zone
  runZonedGuarded(
    () async {
      // Load env
      try {
        await dotenv.load(fileName: ".env");
      } catch (e) {
        debugPrint('dotenv failed to load: $e');
      }

      // Initialize Hive
      await Hive.initFlutter();

      // Initialize Supabase
      await Supabase.initialize(
        url: dotenv.env['SUPABASE_URL']!,
        anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
      );

      // Initialize Firebase
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      debugPrint('Firebase apps: ${Firebase.apps.length}');

      // Flutter errors → Crashlytics
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;

      // Register Hive adapters
      Hive.registerAdapter(SurahHiveAdapter());
      Hive.registerAdapter(AyahHiveAdapter());
      Hive.registerAdapter(QuranBookmarkHiveModelAdapter());
      Hive.registerAdapter(DhikrBookmarkHiveModelAdapter());
      Hive.registerAdapter(DhikrHiveModelAdapter());
      Hive.registerAdapter(CachedSalahTimesHiveAdapter());
      Hive.registerAdapter(AllahNameHiveAdapter());
      Hive.registerAdapter(QuranReadingPlanHiveAdapter());
      Hive.registerAdapter(QuranHiveLogAdapter());

      // Open Hive boxes
      await Hive.openBox<QuranReadingPlanHive>('quran_reading_plan');
      await Hive.openBox<QuranHiveLog>('quran_logs');
      await Hive.openBox<SurahHive>('surahs');
      await Hive.openBox<AyahHive>('ayahs');
      await Hive.openBox<QuranBookmarkHiveModel>('quran_bookmarks_box');
      await Hive.openBox<DhikrBookmarkHiveModel>('dhikr_bookmarks_box');
      await Hive.openBox<List<dynamic>>('adhkar_cache');
      await Hive.openBox('lastReadBox');
      await Hive.openBox<AllahNameHive>('allah_names_box');
      await Hive.openBox<CachedSalahTimesHive>('salah_times_cache_box');
      await Hive.openBox('settingsBox');

      // Notifications
      await NotificationService.instance.init();

      // ✅ Finally, run the app synchronously inside the same zone
      runApp(const ProviderScope(child: MyApp()));
    },
    (error, stack) {
      debugPrint("Error, $stack");
      try {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      } catch (_) {
        debugPrint('Crashlytics not ready yet');
      }
    },
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bootstrap();
    });
  }

  Future<void> _bootstrap() async {
    final hasSeen = ref.read(hasSeenOnboardingProvider);
    if (!hasSeen) return;

    //SYNC
    await ref.read(systemNotifAccessProvider.notifier).sync();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    final hasSeenOnboarding = ref.watch(hasSeenOnboardingProvider);

    //ACTIVATE
    ref.watch(salahNotificationsControllerProvider);
    ref.watch(adhkarNotificationsControllerProvider);

    return MaterialApp(
      title: 'Rafeeq',
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
      theme: appLightThemeData(),
      darkTheme: appDarkThemeData(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: hasSeenOnboarding
          ? const AppWrapper(child: TabsScreen())
          : const OnboardingPage(),
    );
  }
}
