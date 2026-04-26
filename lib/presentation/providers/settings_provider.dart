import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark, system }

class AppSettings {
  final AppThemeMode themeMode;
  final Locale locale;

  const AppSettings({
    this.themeMode = AppThemeMode.system,
    this.locale = const Locale('en'),
  });

  AppSettings copyWith({AppThemeMode? themeMode, Locale? locale}) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }

  Map<String, dynamic> toJson() {
    return {'themeMode': themeMode.index, 'locale': locale.languageCode};
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      themeMode: AppThemeMode.values[json['themeMode'] as int? ?? 2],
      locale: Locale(json['locale'] as String? ?? 'en'),
    );
  }
}

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier() : super(const AppSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt('themeMode');
      final localeCode = prefs.getString('locale');

      state = AppSettings(
        themeMode: themeIndex != null
            ? AppThemeMode.values[themeIndex]
            : AppThemeMode.system,
        locale: localeCode != null ? Locale(localeCode) : const Locale('en'),
      );
    } catch (e) {
      // Use default settings
    }
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _saveSettings();
  }

  Future<void> setLocale(Locale locale) async {
    state = state.copyWith(locale: locale);
    await _saveSettings();
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('themeMode', state.themeMode.index);
      await prefs.setString('locale', state.locale.languageCode);
    } catch (e) {
      // Ignore save errors
    }
  }
}

final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
      return AppSettingsNotifier();
    });

final themeModeProvider = Provider<ThemeMode>((ref) {
  final settings = ref.watch(appSettingsProvider);
  switch (settings.themeMode) {
    case AppThemeMode.light:
      return ThemeMode.light;
    case AppThemeMode.dark:
      return ThemeMode.dark;
    case AppThemeMode.system:
      return ThemeMode.system;
  }
});

final localeProvider = Provider<Locale>((ref) {
  return ref.watch(appSettingsProvider).locale;
});
