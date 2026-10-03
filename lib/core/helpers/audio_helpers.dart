class AudioHelpers {
  AudioHelpers._();

  static String secureUrl(String url) {
    if (url.startsWith('http://')) {
      return url.replaceFirst('http://', 'https://');
    }
    return url;
  }
}
