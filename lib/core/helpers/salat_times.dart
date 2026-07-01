import 'package:intl/intl.dart';
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


String formatTime(DateTime dateTime) {
  return DateFormat('h.mma').format(dateTime).toLowerCase();
}

String formatRemaining(Duration d) {
  final hours = d.inHours;
  final minutes = d.inMinutes.remainder(60);

  if (hours == 0) {
    return "$minutes min";
  } else if (minutes == 0) {
    return "$hours hr";
  } else {
    return "$hours hr $minutes min";
  }
}
