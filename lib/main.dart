import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rafeeq/app/notifications.dart';
import 'package:rafeeq/app/providers/general_notifications_provider.dart';
import 'package:rafeeq/app/tabs_screen.dart';
import 'package:rafeeq/core/app_keys.dart';
import 'package:rafeeq/core/themes/dark_theme.dart';
import 'package:rafeeq/features/quran/data/models/ayah_hive.dart';
import 'package:rafeeq/features/quran/data/models/surah_hive.dart';
import 'package:rafeeq/features/asma_ul_husna/data/models/hive/name_hive_model.dart';
import 'package:rafeeq/features/bookmarks/data/models/dhikr_bookmark_hive_model.dart';
import 'package:rafeeq/features/bookmarks/data/models/quran_bookmark_hive_model.dart';
import 'package:rafeeq/features/onborading/presentation/pages/onboarding_scaffold.dart';
import 'package:rafeeq/features/onborading/presentation/provider/providers.dart';
import 'package:rafeeq/features/quran_goal/data/models/quran_goal_hive.dart';
import 'package:rafeeq/features/quran_goal/data/models/quran_log_hive.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/salah_times_providers.dart';
import 'package:rafeeq/features/settings/presentation/provider/settings_notifcation_provider.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';
import 'package:rafeeq/features/timings/data/models/hive/cached_salah_times_hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  //Init HIVE
  await Hive.initFlutter();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  //register adapters
  Hive.registerAdapter(SurahHiveAdapter());
  Hive.registerAdapter(AyahHiveAdapter());
  Hive.registerAdapter(QuranBookmarkHiveModelAdapter());
  Hive.registerAdapter(DhikrBookmarkHiveModelAdapter());
  Hive.registerAdapter(CachedSalahTimesHiveAdapter());
  Hive.registerAdapter(AllahNameHiveAdapter());

  Hive.registerAdapter(QuranHiveGoalAdapter());
  Hive.registerAdapter(QuranHiveLogAdapter());

  // Open boxes
  await Hive.openBox<QuranHiveGoal>('quran_goal');
  await Hive.openBox<QuranHiveLog>('quran_logs');

  await Hive.openBox<SurahHive>('surahs');
  await Hive.openBox<AyahHive>('ayahs');
  await Hive.openBox<QuranBookmarkHiveModel>('quran_bookmarks_box');
  await Hive.openBox<DhikrBookmarkHiveModel>('dhikr_bookmarks_box');
  await Hive.openBox('lastReadBox'); // for LastReadAyah

  await Hive.openBox<AllahNameHive>('allah_names_box');
  await Hive.openBox<CachedSalahTimesHive>('salah_times_cache_box');
  await Hive.openBox('settingsBox'); //settings

  //------------------NOTIFICATIONS---------------
  await NotificationService.instance.init(); //init

  runApp(const ProviderScope(child: MyApp()));
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

    //ACTIVATE
    ref.read(salahNotificationsControllerProvider);
    ref.read(adhkarNotificationsControllerProvider);
    //SYNC
    await ref.read(systemNotifAccessProvider.notifier).sync();
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(themeModeProvider);
    final hasSeenOnboarding = ref.watch(hasSeenOnboardingProvider);

    return MaterialApp(
      title: 'Rafeeq',
      // theme: appLightThemeData(),
      darkTheme: appDarkThemeData(),
      themeMode: switch (mode) {
        AppThemeMode.dark => ThemeMode.dark,
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.system => ThemeMode.system,
      },
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: hasSeenOnboarding ? const TabsScreen() : const OnboardingPage(),
    );
  }
}
