enum AllahNameLanguage { english, bangla, indonesian, urdu }

extension AllahNameLanguageX on AllahNameLanguage {
  String get jsonKey => name;

  static AllahNameLanguage fromJsonKey(String key) {
    return AllahNameLanguage.values.firstWhere(
      (language) => language.name == key,
      orElse: () =>
          throw FormatException('Unsupported Allah name language: $key'),
    );
  }

  String get displayName {
    switch (this) {
      case AllahNameLanguage.english:
        return 'English';
      case AllahNameLanguage.bangla:
        return 'বাংলা';
      case AllahNameLanguage.indonesian:
        return 'Indonesia';
      case AllahNameLanguage.urdu:
        return 'اردو';
    }
  }
}
