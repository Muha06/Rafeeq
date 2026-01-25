import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rafeeq/app/notifications.dart';
import 'package:rafeeq/core/themes/app_theme.dart';
import 'package:rafeeq/features/Quran/data/models/ayah_hive.dart';
import 'package:rafeeq/features/Quran/data/models/surah_hive.dart';
import 'package:rafeeq/app/tabs_screen.dart';
import 'package:rafeeq/features/asma_ul_husna/data/models/hive/name_hive_model.dart';
import 'package:rafeeq/features/bookmarks/data/models/dhikr_bookmark_hive_model.dart';
import 'package:rafeeq/features/bookmarks/data/models/quran_bookmark_hive_model.dart';
import 'package:rafeeq/features/settings/presentation/provider/notifcation_provider.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';
import 'package:rafeeq/features/salat-times/data/models/hive/cached_salah_times_hive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Init HIVE
  await Hive.initFlutter();

  //register adapters
  Hive.registerAdapter(SurahHiveAdapter());
  Hive.registerAdapter(AyahHiveAdapter());
  Hive.registerAdapter(QuranBookmarkHiveModelAdapter());
  Hive.registerAdapter(DhikrBookmarkHiveModelAdapter());
  Hive.registerAdapter(CachedSalahTimesHiveAdapter());
Hive.registerAdapter(AllahNameHiveAdapter());  
 
  //open boxes
  await Hive.openBox<SurahHive>('surahs');
  await Hive.openBox<AyahHive>('ayahs');
  await Hive.openBox('lastReadBox'); // for LastReadAyah
  await Hive.openBox('settingsBox'); //settings

  await Hive.openBox<QuranBookmarkHiveModel>('quran_bookmarks_box');
  await Hive.openBox<DhikrBookmarkHiveModel>('dhikr_bookmarks_box');
  await Hive.openBox<CachedSalahTimesHive>('salah_times_cache_box');
  await Hive.openBox<AllahNameHive>('allah_names_box');

  //------------------NOTIFICATIONS---------------//
  await NotificationService.instance.init(); //init
  final settings = Hive.box('settingsBox');

  final adhkarOn =
      settings.get('adhkar_notif_enabled', defaultValue: true) as bool;

  await NotificationService.instance.cancel(200); //cancel firsts
  await NotificationService.instance.cancel(201);

  if (adhkarOn) {
    await NotificationService.instance.scheduleDaily(
      id: 200,
      title: 'Morning Adhkār ☀️',
      body: 'Take 2 minutes for your morning adhkār.',
      time: kmorningAdhkarTime,
    );

    await NotificationService.instance.scheduleDaily(
      id: 201,
      title: 'Evening Adhkār 🌙',
      body: 'Don’t miss your evening adhkār.',
      time: keveningAdhkarTime,
    );
  } else {
    await NotificationService.instance.cancel(200); //else cancel
    await NotificationService.instance.cancel(201); //else cancel
  }

  //dotenv
  await dotenv.load(fileName: ".env");

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final mode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Rafeeq',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: switch (mode) {
        AppThemeMode.dark => ThemeMode.dark,
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.system => ThemeMode.system,
      },
      debugShowCheckedModeBanner: false,
      home: const TabsScreen(),
    );
  }
}
