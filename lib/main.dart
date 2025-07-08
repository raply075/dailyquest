import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/theme_provider.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://btahvjpnulclzyfpvine.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ0YWh2anBudWxjbHp5ZnB2aW5lIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA2ODQ3NTksImV4cCI6MjA2NjI2MDc1OX0.635bG21-AQbZul5NNLsLhod8lnT-Ctbq3WjQy6ZuLFY',
  );

  await NotificationService.init();
  await NotificationService.requestPermission();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const DailyQuestApp(),
    ),
  );
}
