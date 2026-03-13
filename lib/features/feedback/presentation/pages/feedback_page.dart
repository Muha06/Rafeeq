import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/snackbars.dart';
import 'package:rafeeq/features/feedback/data/models/feedback_model.dart';
import 'package:rafeeq/features/feedback/presentation/providers/wiring_providers.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FeedbackPage extends ConsumerStatefulWidget {
  const FeedbackPage({super.key});

  @override
  ConsumerState<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends ConsumerState<FeedbackPage> {
  final _controller = TextEditingController();
  FeedbackItem? _submittedFeedback;

  bool get _isValid => _controller.text.trim().isNotEmpty;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    // Returns something like '1.0.0+1'
    return '${info.version}+${info.buildNumber}';
  }

  void _submit() async {
    final version = await getAppVersion();

    final feedback = FeedbackItem.create(
      message: _controller.text.trim(),
      appVersion: version,
    );

    setState(() {
      _submittedFeedback = feedback;
    });

    ref.refresh(sendFeedbackProvider(feedback));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final asyncState = _submittedFeedback == null
        ? null
        : ref.watch(sendFeedbackProvider(_submittedFeedback!));

    final isLoading = asyncState?.isLoading ?? false;

    // If success → pop automatically
    if (asyncState is AsyncData<void>) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
        AppSnackBar.showSimple(
          context: context,
          message: "'Thank you for helping improve Rafeeq 🤍",
        );
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Give Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Help Us Improve', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(
              'Your suggestions shape Rafeeq. If something feels off, missing, or could be better — tell us. Even small ideas matter.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              maxLines: 5,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Share your idea or suggestion...',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isValid && !isLoading ? _submit : null,

                child: isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Send Feedback'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
