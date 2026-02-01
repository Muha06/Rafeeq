import 'package:flutter/material.dart';

class UserLocSettingsPage extends StatefulWidget {
  const UserLocSettingsPage({super.key});

  @override
  State<UserLocSettingsPage> createState() => _UserLocSettingsPageState();
}

class _UserLocSettingsPageState extends State<UserLocSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('My location')));
  }
}
