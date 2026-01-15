String cleanAyah(String text) {
  // Remove unwanted ornamental marks (06D6–06ED includes 06DF)
  return text.replaceAll(RegExp(r'[\u06D6-\u06ED]'), '');
}

String cleanDhikr(String s) {
  return s
      .replaceAll(',', '،') // latin comma -> arabic comma
      .replaceAll(';', '؛') // latin semicolon -> arabic semicolon
      .replaceAll('?', '؟'); // latin question -> arabic question mark
}
