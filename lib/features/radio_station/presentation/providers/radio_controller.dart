import 'package:flutter/rendering.dart';
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
  const factory RadioState.loaded(
    List<RadioStation> stations,
    RadioAudioCategory selectedCategory,
  ) = RadioLoaded;
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
  final RadioAudioCategory selectedCategory;

  const RadioLoaded(this.stations, this.selectedCategory);
}

class RadioError extends RadioState {
  final String message;

  const RadioError(this.message);
}

class RadioController extends Notifier<RadioState> {
  RadioRepository get _repo => ref.read(radioRepositoryProvider);

  bool _isInitialized = false;

  List<RadioStation> _allStations = [];
  RadioAudioCategory _currentCategory = RadioAudioCategory.quran;

  @override
  RadioState build() {
    _autoFetch();
    return const RadioState.loading();
  }

  void _autoFetch() {
    if (_isInitialized) return;
    _isInitialized = true;

    Future.microtask(() async {
      await loadAll();
    });
  }

  // Load all stations (initial load)
  Future<void> loadAll() async {
    state = const RadioState.loading();

    try {
      final radios = await _repo.getRadioStations();

      // Cache all stations for category filtering
      _allStations = radios;

      state = RadioState.loaded(
        _filterByCategory(_currentCategory),
        _currentCategory,
      );
    } catch (e) {
      state = RadioState.error(e.toString());
    }
  }

  // Load by category (when user selects a tab)
  void setCategory(RadioAudioCategory category) {
    _currentCategory = category;

    if (_allStations.isEmpty) {
      state = const RadioState.loading();
      return;
    }

    debugPrint("Selected category: $category");

    state = RadioState.loaded(_filterByCategory(category), category);
  }

  //Helper method to filter cached stations by category
  List<RadioStation> _filterByCategory(RadioAudioCategory category) {
    return _allStations
        .where((station) => station.category == category)
        .toList();
  }
}

final radioControllerProvider = NotifierProvider<RadioController, RadioState>(
  RadioController.new,
);
