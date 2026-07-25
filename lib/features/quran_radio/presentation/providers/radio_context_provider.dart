import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran_radio/domain/entities/radio_context.dart';

final radioPlaybackSessionProvider = StateProvider<RadioPlaybackSession?>(
  (_) => null,
);
