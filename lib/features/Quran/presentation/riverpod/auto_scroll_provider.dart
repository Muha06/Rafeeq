import 'package:riverpod/legacy.dart';

class AutoScrollState {
  final bool on; //is currently auto scrolling
  final double ayahsPerMinute; // speed

  const AutoScrollState({required this.on, required this.ayahsPerMinute});

  AutoScrollState copyWith({bool? on, double? ayahsPerMinute}) {
    return AutoScrollState(
      on: on ?? this.on,
      ayahsPerMinute: ayahsPerMinute ?? this.ayahsPerMinute,
    );
  }
}

class AutoScrollNotifier extends StateNotifier<AutoScrollState> {
  AutoScrollNotifier()
    : super(const AutoScrollState(on: false, ayahsPerMinute: 20));

  void setOn(bool v) => state = state.copyWith(on: v); //start auto scrol
  void toggle() => state = state.copyWith(on: !state.on); //in settings

  void setSpeed(double v) => state = state.copyWith(ayahsPerMinute: v); //speed
}

final autoScrollProvider =
    StateNotifierProvider<AutoScrollNotifier, AutoScrollState>(
      (ref) => AutoScrollNotifier(),
    );
