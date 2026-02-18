import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/home/providers/reminder_providers.dart';

class HomeRemindersCarousel extends ConsumerWidget {
  const HomeRemindersCarousel({super.key});

  int hm(int h, int m) => h * 60 + m;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(homeRemindersProvider);

    if (items.isEmpty) return const SizedBox.shrink();

    final canAutoPlay = items.length > 1;

    return CarouselSlider(
      items: items,
      options: CarouselOptions(
        padEnds: true,
        height: 180, // match your card height area
        viewportFraction: 1, // full width (banner style)
        enlargeCenterPage: false,
        enableInfiniteScroll: canAutoPlay,
        autoPlay: canAutoPlay,
        pauseAutoPlayOnTouch: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 650),
      ),
    );
  }
}
