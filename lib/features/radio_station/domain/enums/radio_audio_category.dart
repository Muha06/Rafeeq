enum RadioAudioCategory {
  quran,
  hadith,
  tafsir,
  adhkar,
  seerah,
  fiqh,
  qisas,
  fatwa,
}

extension RadioAudioCategoryX on RadioAudioCategory {
  String get label {
    switch (this) {
      case RadioAudioCategory.quran:
        return "Quran";
      case RadioAudioCategory.hadith:
        return "Hadith";
      case RadioAudioCategory.tafsir:
        return "Tafsir";
      case RadioAudioCategory.adhkar:
        return "Adhkar";
      case RadioAudioCategory.seerah:
        return "Seerah";
      case RadioAudioCategory.fiqh:
        return "Fiqh";
      case RadioAudioCategory.qisas:
        return "Stories";
      case RadioAudioCategory.fatwa:
        return "Fatwa";
    }
  }
}
