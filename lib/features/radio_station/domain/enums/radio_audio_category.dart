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

  String get dbValue => name;

  static RadioAudioCategory fromDb(String value) {
    switch (value.toLowerCase()) {
      case "quran":
        return RadioAudioCategory.quran;
      case "hadith":
        return RadioAudioCategory.hadith;
      case "tafsir":
        return RadioAudioCategory.tafsir;
      case "adhkar":
        return RadioAudioCategory.adhkar;
      case "seerah":
        return RadioAudioCategory.seerah;
      case "fiqh":
        return RadioAudioCategory.fiqh;
      case "qisas":
        return RadioAudioCategory.qisas;
      case "fatwa":
        return RadioAudioCategory.fatwa;
      default:
        return RadioAudioCategory.quran; // safe fallback
    }
  }
}
