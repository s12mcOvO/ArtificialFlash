import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:artificial_flash/core/theme/app_theme.dart';
import 'package:artificial_flash/presentation/pages/main_shell.dart';
import 'package:artificial_flash/presentation/providers/settings_provider.dart';
import 'package:artificial_flash/l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: ArtificialFlashApp()));
}

class ArtificialFlashApp extends ConsumerWidget {
  const ArtificialFlashApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'ArtificialFlash 能工智人',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: const [Locale('en'), Locale('zh')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const MainShell(),
    );
  }
}

/// ===========================================================
/// QUICK START GUIDE
/// ===========================================================
///
/// To run the full application with backend:
///
/// 1. Start the backend server:
///    cd backend
///    pip install -r requirements.txt
///    python main.py
///
/// 2. In another terminal, run Flutter:
///    flutter run
///
/// Or use the convenience script:
///    ./start.sh
///
/// Default backend runs at: http://localhost:8000
/// API documentation: http://localhost:8000/docs
///
/// ===========================================================
