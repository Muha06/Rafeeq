//converts string salat timings to datetime
//eg 05:25 => datetime((todays date) hour, minute)

DateTime parseAladhanTime({required String raw, required DateTime date}) {
  final match = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(raw);
  if (match == null) {
    throw FormatException('Invalid time format: $raw');
  }

  final hour = int.parse(match.group(1)!);
  final minute = int.parse(match.group(2)!);

  return DateTime(date.year, date.month, date.day, hour, minute);
}
