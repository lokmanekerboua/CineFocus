import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/supabase/supabase_client.dart';
import 'router.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://yfryyrxrfigtmzdznulb.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlmcnl5cnhyZmlndG16ZHpudWxiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY2NzU0MzcsImV4cCI6MjA5MjI1MTQzN30.BRynmexnlfgsBq1kqewCM95sO0TA5c0j2IGVmj6ccfs',
  );

  runApp(const ProviderScope(child: CineFocus()));
}

class CineFocus extends ConsumerWidget {
  const CineFocus({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'CineFocus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}