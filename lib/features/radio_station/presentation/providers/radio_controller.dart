import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/radio_station/domain/enums/radio_audio_category.dart';
import 'package:rafeeq/features/radio_station/presentation/providers/wiring_providers.dart';
import '../../domain/entities/radio_station.dart';
import '../../domain/repository/radio_repository.dart';

sealed class RadioState {
  const RadioState();

  //Defining what state to return for each case (initial, loading, loaded, error)
  //Using factory constructors to control the creation of state instances
  const factory RadioState.initial() = RadioInitial;
  const factory RadioState.loading() = RadioLoading;
  const factory RadioState.loaded(List<RadioStation> stations) = RadioLoaded;
  const factory RadioState.error(String message) = RadioError;
}

//Possible states: initial, loading, loaded, error
class RadioInitial extends RadioState {
  const RadioInitial();
}

class RadioLoading extends RadioState {
  const RadioLoading();
}

class RadioLoaded extends RadioState {
  final List<RadioStation> stations;

  const RadioLoaded(this.stations);
}

class RadioError extends RadioState {
  final String message;

  const RadioError(this.message);
}

class RadioController extends Notifier<RadioState> {
  RadioRepository get _repo => ref.read(radioRepositoryProvider);

  bool _isInitialized = false;

  @override
  RadioState build() {
    _autoFetch();
    return const RadioState.initial();
  }

  void _autoFetch() {
    if (_isInitialized) return;
    _isInitialized = true;

    Future.microtask(() async {
      await loadAll();
    });
  }

  Future<void> loadAll() async {
    state = const RadioState.loading();

    try {
      final radios = await _repo.getRadioStations();
      state = RadioState.loaded(radios);
    } catch (e) {
      state = RadioState.error(e.toString());
    }
  }

  Future<void> loadByCategory(RadioAudioCategory category) async {
    state = const RadioState.loading();

    try {
      final radios = await _repo.getByCategory(category);
      state = RadioState.loaded(radios);
    } catch (e) {
      state = RadioState.error(e.toString());
    }
  }
}

final radioControllerProvider = NotifierProvider<RadioController, RadioState>(
  RadioController.new,
);
