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

String formatHms(Duration d) {
  if (d.isNegative) d = Duration.zero;

  String two(int n) => n.toString().padLeft(2, '0');

  final hours = d.inHours;
  final minutes = d.inMinutes.remainder(60);
  final seconds = d.inSeconds.remainder(60);

  return '${two(hours)}:${two(minutes)}:${two(seconds)}';
}
