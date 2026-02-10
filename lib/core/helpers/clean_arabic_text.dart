String cleanAyah(String text) {
  // Removes only:
  // 06DF–06E8 (small high rounded zero, tiny waw/yeh/noon etc.)
  // and 06ED (small low meem)
  // Keeps:
  // 06D6–06DC (quranic annotation signs), 06DD (end of ayah),
  // 06DE (rub el hizb), 06E9 (sajdah), 06EA–06EC (stop signs)
  return text.replaceAll(RegExp(r'[\u06DF-\u06E8\u06ED]'), '');
}

String cleanDhikr(String s) {
  return s.replaceAll('،', ' ');
}
