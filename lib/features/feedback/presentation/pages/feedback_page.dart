import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/snackbars.dart';
import 'package:rafeeq/features/feedback/data/models/feedback_model.dart';
import 'package:rafeeq/features/feedback/presentation/providers/feedback_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FeedbackPage extends ConsumerStatefulWidget {
  const FeedbackPage({super.key});

  @override
  ConsumerState<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends ConsumerState<FeedbackPage> {
  final _controller = TextEditingController();

  bool get _isValid => _controller.text.trim().isNotEmpty;

  Future<String> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();
    // Returns something like '1.0.0+1'
    return '${info.version}+${info.buildNumber}';
  }

  void _submit() async {
    final version = await getAppVersion();

    try {
      final feedback = FeedbackItem.create(
        message: _controller.text.trim(),
        appVersion: version,
      );

      await ref.read(feedbackControllerProvider.notifier).send(feedback);

      if (!mounted) return;

      AppSnackBar.showSimple(
        context: context,
        message: "Thanks for making Rafeeq better!",
      );
      FocusScope.of(context).unfocus();

      AppNav.pop(context);
    } catch (e) {
      AppSnackBar.showSimple(
        context: context,
        message: "Something went wrong.",
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final state = ref.watch(feedbackControllerProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Give Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Help Us Improve', style: theme.textTheme.titleLarge),

                const SizedBox(height: 12),

                Text(
                  'Your suggestions shape Rafeeq. If something feels off, missing, or could be better — tell us. Even small ideas matter.',
                  style: theme.textTheme.bodyMedium,
                ),

                const SizedBox(height: 24),

                TextField(
                  controller: _controller,
                  maxLines: 5,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Share your idea or suggestion...',
                    hintStyle: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
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
        ),
      ),
    );
  }
}
