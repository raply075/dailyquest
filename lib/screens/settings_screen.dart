import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Mode Gelap'),
            value: themeProvider.isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Versi Aplikasi'),
            subtitle: const Text('DailyQuest 2.0.0'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Pembuat Aplikasi'),
            subtitle: const Text(
              'Raply Fediansyah\n'
              'Maheswara HRK\n'
              'Alip Akbar Andriyansah\n'
              'Muchamad Syarif Hidayatullah',
            ),
            isThreeLine: true,
          ),
        ],
      ),
    );
  }
}
