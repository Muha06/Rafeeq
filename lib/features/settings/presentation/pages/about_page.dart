import 'package:flutter/material.dart';
import 'package:rafeeq/core/constants/app_assets.dart';

class AboutRafeeqPage extends StatelessWidget {
  const AboutRafeeqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('About Rafeeq')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // App icon
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(AppAssets.appIcon, height: 64, width: 64),
                ),

                const SizedBox(height: 8),

                Text('Rafeeq', style: tt.titleLarge),

                Text('Your Islamic companion', style: tt.bodyMedium),

                const SizedBox(height: 32),

                // Content
                const _AboutAppSection(
                  title: 'How Rafeeq began',
                  body:
                      "I once found myself wondering: is there an Islamic companion app made specifically for campus students—something that could help them stay close to their deen even in an environment like university, where distractions are everywhere and life can get pretty busy? That thought eventually became Rafeeq. I wanted to create something that would make practicing Islam a little easier for Muslim students, bringing useful Islamic tools and reminders into their everyday campus life. And from that idea, Rafeeq began.",
                ),

                const _AboutAppSection(
                  title: 'For the Ummah 🤍',
                  body:
                      "As Rafeeq grew, I realized that the app could be useful beyond the university campus. Its purpose and features could benefit Muslims from all walks of life, not just students. So I decided to make Rafeeq for everyone — a companion for any Muslim who wants to stay connected to their deen, wherever they are.",
                ),

                const _AboutAppSection(
                  title: 'Free forever, in shaa Allah ✨',
                  body:
                      "Since Rafeeq was created to benefit the Ummah, we don't want cost to ever be a barrier to using it. No Muslim should have to pay to access the features and resources in Rafeeq. In shaa Allah, Rafeeq will remain completely free — no subscriptions, no paywalls, and no premium features. We built it as a contribution to the Ummah, and that's how we intend to keep it. In the future, we may add an optional way for those who wish to support the project through donations, but using Rafeeq will always remain free, in shaa Allah. ",
                ),

                // TODO: share Rafeeq card
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AboutAppSection extends StatelessWidget {
  const _AboutAppSection({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: tt.labelMedium),
          const SizedBox(height: 8),
          Text(body, style: tt.bodyLarge?.copyWith(fontSize: 15)),
        ],
      ),
    );
  }
}
