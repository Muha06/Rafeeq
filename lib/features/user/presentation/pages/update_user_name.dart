import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/app_toast.dart';
import 'package:rafeeq/features/user/presentation/providers/user_provider.dart';

class UpdateUserNamePage extends ConsumerStatefulWidget {
  const UpdateUserNamePage({super.key});

  @override
  ConsumerState<UpdateUserNamePage> createState() => _UpdateUserNamePageState();
}

class _UpdateUserNamePageState extends ConsumerState<UpdateUserNamePage> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();

    final currentName = ref.read(userNameProvider);
    _nameController = TextEditingController(text: currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _updateName() {
    final newName = _nameController.text.trim();

    if (newName.isEmpty) return;
    FocusScope.of(context).unfocus();

    AppNav.pop(context);

    if (!mounted) return;

    AppToast.showSuccess(context: context, message: "Name changed!");

    ref.read(userNameProvider.notifier).updateName(newName);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final currentName = ref.watch(userNameProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Update your name')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What would you like us to call you, $currentName?',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),

              Text(
                'We’ll use this name throughout Rafeeq.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),

              TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _updateName(),
                decoration: InputDecoration(
                  labelText: 'New name',
                  hintText: 'Enter your new name',
                  filled: true,
                  fillColor: cs.surface,
                  prefixIcon: const Icon(HugeIconsStroke.user),
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateName,
                  child: const Text('Update name'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
