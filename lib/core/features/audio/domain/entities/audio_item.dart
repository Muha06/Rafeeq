class AudioItem {
  final String id;
  final String title;
  final String url;
  final String? artist;
  final String? imageUrl;

  const AudioItem({
    required this.id,
    required this.title,
    required this.url,
    this.imageUrl,
    this.artist,
  });
}
