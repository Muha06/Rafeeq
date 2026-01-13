import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rafeeq/core/themes/app_theme.dart';
import 'package:rafeeq/features/Quran/data/models/ayah_hive.dart';
import 'package:rafeeq/features/Quran/data/models/surah_hive.dart';
import 'package:rafeeq/features/Quran/presentation/pages/tabs_screen.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';
import 'package:rafeeq/features/Quran/presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Init HIVE
  await Hive.initFlutter();

  //register adapters
  Hive.registerAdapter(SurahHiveAdapter());
  Hive.registerAdapter(AyahHiveAdapter());

  //open boxes
  await Hive.openBox<SurahHive>('surahs');
  await Hive.openBox<AyahHive>('ayahs');
  await Hive.openBox('lastReadBox'); // for LastReadAyah

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
