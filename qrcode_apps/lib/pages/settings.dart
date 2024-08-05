import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SETTINGS PAGE"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Settings Page"),
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).go('/');
              },
             child: Text("Back to Home"),
             ),
          ],
        ),
      ),
    );
  }
}