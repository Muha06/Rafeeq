class AladhanTimingsModel {
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  final String timezone; // meta.timezone
  final DateTime date; // derived from data.date.gregorian.date (dd-mm-yyyy)

  const AladhanTimingsModel({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,

    required this.timezone,
    required this.date,
  });

//from api 
  factory AladhanTimingsModel.fromJson({
    required Map<String, dynamic> timingsJson, //salah timings
    required Map<String, dynamic> metaJson, //Time zone
    required Map<String, dynamic> dateJson,// date
  }) {
    // AlAdhan gregorian date often looks like "20-01-2026"
    final greg = dateJson['gregorian'] as Map<String, dynamic>;
    final dateStr = greg['date'] as String; // "dd-mm-yyyy"
    final parts = dateStr.split('-'); //20 - 01 - 2026
    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);

    return AladhanTimingsModel(
      fajr: timingsJson['Fajr'] as String,
      dhuhr: timingsJson['Dhuhr'] as String,
      asr: timingsJson['Asr'] as String,
      maghrib: timingsJson['Maghrib'] as String,
      isha: timingsJson['Isha'] as String,
      timezone: metaJson['timezone'] as String,
      date: DateTime(year, month, day),
    );
  }
}
