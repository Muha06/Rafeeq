String cleanAyah(String text) {
  return text.replaceAll(RegExp(r'[\u06DF-\u06E8\u06ED]'), '');
}

String cleanDhikr(String s) {
  return s.replaceAll('،', '');
}
