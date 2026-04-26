import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:artificial_flash/presentation/providers/connection_provider.dart';
import 'package:artificial_flash/presentation/providers/settings_provider.dart';
import 'package:artificial_flash/core/theme/app_theme.dart';
import 'package:artificial_flash/core/constants/app_constants.dart';
import 'package:artificial_flash/l10n/app_localizations.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _hostController = TextEditingController();
  final _portController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final config = ref.read(connectionConfigProvider);
    _hostController.text = config.host;
    _portController.text = config.port.toString();
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final connectionConfig = ref.watch(connectionConfigProvider);
    final settings = ref.watch(appSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAppearanceSection(l10n, settings),
          const SizedBox(height: 16),
          _buildConnectionSection(l10n, connectionConfig),
          const SizedBox(height: 16),
          _buildServerSection(l10n),
          const SizedBox(height: 16),
          _buildAboutSection(l10n),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection(AppLocalizations l10n, AppSettings settings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.appearance,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.palette),
              title: Text(l10n.theme),
              trailing: DropdownButton<AppThemeMode>(
                value: settings.themeMode,
                underline: const SizedBox(),
                items: [
                  DropdownMenuItem(
                    value: AppThemeMode.light,
                    child: Text(l10n.lightTheme),
                  ),
                  DropdownMenuItem(
                    value: AppThemeMode.dark,
                    child: Text(l10n.darkTheme),
                  ),
                  DropdownMenuItem(
                    value: AppThemeMode.system,
                    child: Text(l10n.systemTheme),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref.read(appSettingsProvider.notifier).setThemeMode(value);
                  }
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(l10n.language),
              trailing: DropdownButton<Locale>(
                value: settings.locale,
                underline: const SizedBox(),
                items: [
                  DropdownMenuItem(
                    value: const Locale('en'),
                    child: Text(l10n.english),
                  ),
                  DropdownMenuItem(
                    value: const Locale('zh'),
                    child: Text(l10n.chinese),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref.read(appSettingsProvider.notifier).setLocale(value);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionSection(
    AppLocalizations l10n,
    ConnectionConfig config,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.connectionMode,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(l10n.remoteServerMode),
              subtitle: Text(l10n.connectToRemote),
              value: config.isRemote,
              onChanged: (value) {
                ref.read(connectionConfigProvider.notifier).setRemote(value);
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                config.isConnected ? Icons.cloud_done : Icons.cloud_off,
                color: config.isConnected ? AppColors.success : AppColors.error,
              ),
              title: Text(
                config.isConnected ? l10n.connected : l10n.disconnected,
              ),
              subtitle: Text('${config.host}:${config.port}'),
              trailing: TextButton(
                onPressed: _testConnection,
                child: Text(l10n.testConnection),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServerSection(AppLocalizations l10n) {
    final config = ref.watch(connectionConfigProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.serverConfig,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _hostController,
              decoration: InputDecoration(
                labelText: l10n.serverHost,
                hintText: 'e.g., localhost or 192.168.1.100',
                prefixIcon: const Icon(Icons.dns),
              ),
              enabled: config.isRemote,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _portController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.serverPort,
                hintText: 'e.g., 8000',
                prefixIcon: const Icon(Icons.numbers),
              ),
              enabled: config.isRemote,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveServerConfig,
                icon: const Icon(Icons.save),
                label: Text(l10n.saveConfig),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.about,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.psychology),
              title: Text(AppConstants.appName),
              subtitle: Text('${l10n.version} ${AppConstants.appVersion}'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.description),
              title: Text(l10n.description),
              subtitle: Text(
                'A beginner-friendly AI model training assistant that supports Visual, NLP, and Generative models.',
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.code),
              title: Text(l10n.features),
              subtitle: Text(
                '- ${l10n.visualModels} (Image Classification, Object Detection)\n'
                '- ${l10n.nlpModels} (Text Classification, Sentiment Analysis)\n'
                '- ${l10n.generativeModels}\n'
                '- ${l10n.localAndRemote}\n'
                '- ${l10n.realTimeMonitoring}\n'
                '- ${l10n.modelExport} (ONNX, TFLite)',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveServerConfig() {
    final host = _hostController.text.trim();
    final port =
        int.tryParse(_portController.text.trim()) ?? ApiConstants.defaultPort;

    ref.read(connectionConfigProvider.notifier).updateHost(host);
    ref.read(connectionConfigProvider.notifier).updatePort(port);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.saveConfig)),
    );
  }

  void _testConnection() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.testConnection)),
    );
  }
}
