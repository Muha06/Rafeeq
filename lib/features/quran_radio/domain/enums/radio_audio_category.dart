import 'package:flutter/material.dart';
import 'package:hugeicons_pro/hugeicons.dart';

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
  IconData get icon {
    switch (this) {
      case RadioAudioCategory.quran:
        return HugeIconsStroke.book01; // revelation / reading
      case RadioAudioCategory.hadith:
        return HugeIconsStroke.chat; // narration / sayings
      case RadioAudioCategory.tafsir:
        return HugeIconsStroke.search01; // explanation / deep dive
      case RadioAudioCategory.adhkar:
        return HugeIconsStroke.sun01; // remembrance / du'a vibe
      case RadioAudioCategory.seerah:
        return HugeIconsStroke.user; // life story / biography
      case RadioAudioCategory.fiqh:
        return HugeIconsStroke.weightScale; // rulings / balance / law
      case RadioAudioCategory.qisas:
        return HugeIconsStroke.bookBookmark01; // stories / narratives
      case RadioAudioCategory.fatwa:
        return HugeIconsStroke.question; // asking rulings / Q&A
    }
  }

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
