import 'package:flutter/material.dart';
import 'package:rafeeq/features/haramain-live/presentation/pages/haramain_live_page.dart';
import 'package:rafeeq/features/quran_radio/presentation/pages/radios_list_page.dart';

class LiveHubTabs extends StatefulWidget {
  const LiveHubTabs({super.key});

  @override
  State<LiveHubTabs> createState() => _LiveHubTabsState();
}

class _LiveHubTabsState extends State<LiveHubTabs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Live Hub'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Radio'),
              Tab(text: "Haramain"),
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [RadioListPage(), HaramainLivePage()],
        ),
      ),
    );
  }
}
