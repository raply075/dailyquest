import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';
import 'providers/theme_provider.dart';

class DailyQuestApp extends StatelessWidget {
  const DailyQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'DailyQuest 2.0',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,
      home: session != null ? const HomeScreen() : const LoginScreen(),
    );
  }
}
