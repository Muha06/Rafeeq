import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/home/presentation/widgets/friday_reminder_card.dart';
import 'package:rafeeq/features/adhkar/presentation/widgets/adhkar_reminder_card.dart';

class HomeRemindersCarousel extends ConsumerWidget {
  const HomeRemindersCarousel({super.key});

  bool _isFriday(DateTime now) => now.weekday == DateTime.friday;

  bool _isInWindow(DateTime now, int startMin, int endMin) {
    final m = now.hour * 60 + now.minute;

    // normal window
    if (startMin <= endMin) return m >= startMin && m < endMin;

    // overnight window (e.g. 20:00 -> 02:00)
    return m >= startMin || m < endMin;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();

    final items = <Widget>[];

    bool isMorning = _isInWindow(now, 5 * 60, 11 * 60);
    bool isEvening = _isInWindow(now, 17 * 60, 22 * 60);

    // Morning: 05:00 – 10:00
    if (isMorning) {
      items.add(AdhkarReminderCard(isMorning: isMorning));
    }

    // Friday reminder (all Friday)
    if (_isFriday(now)) {
      items.add(const FridayReminderCard());
    }

    // Evening: 17:00 – 21:00
    if (isEvening) {
      items.add(AdhkarReminderCard(isMorning: isMorning));
    }

    if (items.isEmpty) return const SizedBox.shrink();

    final canAutoPlay = items.length > 1;

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: CarouselSlider(
        items: items,
        options: CarouselOptions(
          height: 205, // match your card height area
          viewportFraction: 1, // full width (banner style)
          enlargeCenterPage: false,
          enableInfiniteScroll: canAutoPlay,
          autoPlay: canAutoPlay,
          pauseAutoPlayOnTouch: true,
          autoPlayInterval: const Duration(seconds: 5),
          autoPlayAnimationDuration: const Duration(milliseconds: 650),
        ),
      ),
    );
  }
}
