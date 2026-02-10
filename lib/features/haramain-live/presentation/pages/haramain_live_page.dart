import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class HaramainAloulaLivePage extends StatefulWidget {
  const HaramainAloulaLivePage({
    super.key,
    required this.title,
    required this.liveUrl,
  });

  final String title;
  final String liveUrl;

  @override
  State<HaramainAloulaLivePage> createState() => _HaramainAloulaLivePageState();
}

class _HaramainAloulaLivePageState extends State<HaramainAloulaLivePage> {
  late final WebViewController _controller;

  bool _isLoading = true;
  bool _failed = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setUserAgent(
        'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120 Mobile Safari/537.36',
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() {
              _isLoading = true;
              _failed = false;
              _errorText = null;
            });
          },
          onPageFinished: (_) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (err) {
            debugPrint(
              'WEBVIEW ERROR: code=${err.errorCode} desc=${err.description} url=${err.url}',
            );
            setState(() {
              _failed = true;
              _isLoading = false;
              _errorText = '${err.errorCode}: ${err.description}';
            });
          },
          onNavigationRequest: (req) => NavigationDecision.navigate,
        ),
      )
      ..loadRequest(Uri.parse(widget.liveUrl));

    // ✅ Android-only: allow autoplay without user gesture
    final platform = _controller.platform;
    if (platform is AndroidWebViewController) {
      platform.setMediaPlaybackRequiresUserGesture(false);
    }
  }

  Future<void> _openExternal() async {
    final uri = Uri.parse(widget.liveUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _reload() async {
    setState(() {
      _failed = false;
      _errorText = null;
      _isLoading = true;
    });
    await _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: 'Open externally',
            onPressed: _openExternal,
            icon: const Icon(Icons.open_in_new),
          ),
          IconButton(
            tooltip: 'Reload',
            onPressed: _reload,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_failed)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off, size: 40),
                    const SizedBox(height: 10),
                    Text(
                      'Couldn’t load the live stream in-app.',
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    if (_errorText != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        _errorText!,
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 14,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _reload,
                          child: const Text('Try again'),
                        ),
                        OutlinedButton(
                          onPressed: _openExternal,
                          child: Text(
                            'Open externally',
                            style: theme.textTheme.bodySmall!.copyWith(
                              fontSize: 12,
                              color: theme.textTheme.bodyLarge!.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          else
            WebViewWidget(controller: _controller),

          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
