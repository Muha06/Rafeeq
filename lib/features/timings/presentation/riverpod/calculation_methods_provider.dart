import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rafeeq/features/settings/presentation/provider/settings_notifcation_provider.dart';
import 'package:rafeeq/features/timings/data/datasources/calculation_methods.dart';
import 'package:rafeeq/features/timings/domain/entities/prayer_calculation_method.dart';

final calculationMethodsProvider = Provider<List<PrayerCalculationMethod>>((
  ref,
) {
  return prayerCalculationMethods;
});

final selectedCalculationMethodProvider =
    NotifierProvider<SelectedCalculationMethod, PrayerCalculationMethod>(
      SelectedCalculationMethod.new,
    );

class SelectedCalculationMethod extends Notifier<PrayerCalculationMethod> {
  static const _methodIdKey = 'prayer_calculation_method_id';

  late final Box settingsBox;

  @override
  PrayerCalculationMethod build() {
    settingsBox = ref.read(settingsBoxProvider);

    final savedId = settingsBox.get(_methodIdKey) as int?;
    final methods = ref.read(calculationMethodsProvider);

    if (savedId == null) {
      return methods.first;
    }

    return methods.firstWhere(
      (method) => method.id == savedId,
      orElse: () => methods.first,
    );
  }

  Future<void> select(PrayerCalculationMethod method) async {
    state = method;
    await settingsBox.put(_methodIdKey, method.id);
  }
}
