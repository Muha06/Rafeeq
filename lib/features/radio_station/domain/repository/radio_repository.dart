import '../entities/radio_station.dart';

abstract class RadioRepository {
  Future<List<RadioStation>> getRadioStations();
}
