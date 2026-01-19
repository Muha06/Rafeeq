import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri_date/hijri.dart';
import 'package:rafeeq/core/animations/navigation_animations.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
import 'package:rafeeq/features/home/presentation/widgets/ayah_of_the_day.dart';
import 'package:rafeeq/features/Quran/presentation/widgets/QURAN_PAGE/greetings_row.dart';
import 'package:rafeeq/features/home/presentation/widgets/home_reminder_carouel.dart';
import 'package:rafeeq/features/settings/presentation/pages/settings_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final todayHijri = HijriDate.now();
  String get formattedHijri => todayHijri.toFormat('MMMM dd, yyyy h');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: false,
              toolbarHeight: theme.appBarTheme.toolbarHeight!,
              title: Text('Rafeeq', style: theme.appBarTheme.titleTextStyle),
              actions: [
                IconButton(
                  onPressed: () {
                    pushLeftPage(context, const SettingsPage());
                  },
                  icon: const Icon(CupertinoIcons.settings),
                ),
              ],
              bottom: appBarBottomDivider(context),
            ),

            //GREETINGS
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  right: 12,
                  top: 20,
                  bottom: 8,
                ),
                child: GreetingsRow(formattedHijri: formattedHijri),
              ),
            ),

            // SliverToBoxAdapter(
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 12.0,
            //       vertical: 16,
            //     ),
            //     child: Stack(
            //       children: [
            //         // ✅ Background image with radius
            //         ClipRRect(
            //           borderRadius: BorderRadius.circular(16),
            //           child: Image.asset(
            //             'assets/salat/isha.jpeg',
            //             height: 180,
            //             width: double.infinity,
            //             fit: BoxFit.cover,
            //           ),
            //         ),

            //         // ✅ Gradient overlay so text is always readable
            //         Positioned.fill(
            //           child: ClipRRect(
            //             borderRadius: BorderRadius.circular(16),
            //             child: DecoratedBox(
            //               decoration: BoxDecoration(
            //                 color: Colors.black.withAlpha(100),
            //               ),
            //             ),
            //           ),
            //         ),

            //         // ✅ Content
            //         Positioned.fill(
            //           child: Padding(
            //             padding: const EdgeInsets.all(14),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 // Top row: prev + next
            //                 const Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     _MiniPrayerTime(
            //                       title: 'Dhuhr',
            //                       time: '12:32 PM',
            //                     ),
            //                     _MiniPrayerTime(
            //                       title: 'Asr',
            //                       time: '03:56 PM',
            //                       alignRight: true,
            //                     ),
            //                   ],
            //                 ),

            //                 const Spacer(),

            //                 // Middle: progress bar
            //                 ClipRRect(
            //                   borderRadius: BorderRadius.circular(99),
            //                   child: const LinearProgressIndicator(
            //                     value: 0.62, // mock (0 -> 1)
            //                     minHeight: 6,
            //                     backgroundColor: Colors.white24,
            //                   ),
            //                 ),

            //                 const SizedBox(height: 10),

            //                 // Bottom: countdown + meta chip
            //                 Row(
            //                   crossAxisAlignment: CrossAxisAlignment.end,
            //                   children: [
            //                     Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Text(
            //                           'Next prayer in',
            //                           style: TextStyle(
            //                             color: Colors.white.withOpacity(0.9),
            //                             fontSize: 12,
            //                           ),
            //                         ),
            //                         const SizedBox(height: 4),
            //                         const Text(
            //                           '01:23:19',
            //                           style: TextStyle(
            //                             color: Colors.white,
            //                             fontSize: 30,
            //                             fontWeight: FontWeight.w800,
            //                             letterSpacing: 1.0,
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                     const Spacer(),
            //                     const _InfoChip(
            //                       text: 'Nairobi • MWL • Shāfiʿī',
            //                     ),
            //                   ],
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            const SliverToBoxAdapter(child: HomeRemindersCarousel()),

            //AYAH OF THE DAY
            const SliverToBoxAdapter(child: AyahOfTheDay()),
          ],
        ),
      ),
    );
  }
}
