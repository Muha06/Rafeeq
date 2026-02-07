enum AudioSourceType { quranSurah, quranAyah, adhkar }

class AudioState {
  final AudioSourceType? source;
  final String? id; // adhkarId, chapterId, or verseKey
  final String? title; // what to show in "Now Playing"
  final String? url;

  const AudioState({this.source, this.id, this.title, this.url});

  static const empty = AudioState();

  AudioState copyWith({
    AudioSourceType? source,
    String? id,
    String? title,
    String? url,
  }) {
    return AudioState(
      source: source ?? this.source,
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
    );
  }
}
