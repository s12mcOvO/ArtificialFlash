import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:artificial_flash/core/theme/app_theme.dart';
import 'package:artificial_flash/presentation/pages/main_shell.dart';
import 'package:artificial_flash/presentation/providers/settings_provider.dart';
import 'package:artificial_flash/l10n/app_localizations.dart';

Future<void> _launchBackend() async {
  try {
    final execDir = Directory.current;
    final beDir = Directory('${execDir.path}/backend');

    if (!await beDir.exists()) {
      return;
    }

    Process.start(
      Platform.isWindows ? 'python' : 'python3',
      ['main.py'],
      workingDirectory: beDir.path,
      runInShell: true,
    );
  } catch (_) {
    // Silently fail if backend can't be started
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    _launchBackend();
  }

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
