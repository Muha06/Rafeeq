class WordByWord {
  final int surahNumber;
  final int ayahNumber;
  final List<WordByWordWord> words;

  const WordByWord({
    required this.words,
    required this.surahNumber,
    required this.ayahNumber,
  });
}

class WordByWordWord {
  final int wordNumber; // eg 1, 2, 3
  final String arabic;
  final String english;

  const WordByWordWord({
    required this.wordNumber,
    required this.arabic,
    required this.english,
  });
}
