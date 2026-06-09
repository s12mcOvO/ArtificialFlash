import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:artificial_flash/core/theme/app_theme.dart';
import 'package:artificial_flash/presentation/pages/main_shell.dart';
import 'package:artificial_flash/presentation/providers/settings_provider.dart';
import 'package:artificial_flash/l10n/app_localizations.dart';

Future<Process?> _launchBackend() async {
  try {
    final execDir = Directory.current;
    final beDir = Directory('${execDir.path}/backend');

    if (!await beDir.exists()) {
      return null;
    }

    final pythonPath = Platform.isWindows ? 'python' : 'python3';
    final pythonCheck = await Process.run(
      pythonPath,
      ['-c', 'import sys; print(sys.executable)'],
      workingDirectory: beDir.path,
    );

    if (pythonCheck.exitCode != 0) {
      return null;
    }

    final pythonExecutable = pythonCheck.stdout.toString().trim();

    final process = await Process.start(
      pythonExecutable,
      ['main.py'],
      workingDirectory: beDir.path,
      runInShell: false,
    );

    process.stdout
        .transform(utf8.decoder)
        .listen((data) => debugPrint('[backend] $data'));
    process.stderr
        .transform(utf8.decoder)
        .listen((data) => debugPrint('[backend:error] $data'));

    process.exitCode.then((code) {
      debugPrint('[backend] exited with code $code');
    });

    return process;
  } catch (_) {
    return null;
  }
}

Process? _backendProcess;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    _backendProcess = await _launchBackend();
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
