import 'package:url_launcher/url_launcher.dart';

class AppUrlLauncher {
  AppUrlLauncher._(); // private constructor (no instances)

  /// Open a URL in external browser
  static Future<void> openExternal(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  /// Open a URL inside the app (custom tabs / safari view)
  static Future<void> openInApp(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }

  /// Smart opener (tries in-app first, falls back to external)
  static Future<void> open(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    } else {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
