import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:artificial_flash/presentation/providers/connection_provider.dart';
import 'package:artificial_flash/core/theme/app_theme.dart';
import 'package:artificial_flash/core/constants/app_constants.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  bool _isRemoteMode = false;

  @override
  void initState() {
    super.initState();
    final config = ref.read(connectionConfigProvider);
    _hostController.text = config.host;
    _portController.text = config.port.toString();
    _isRemoteMode = config.isRemote;
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connectionConfig = ref.watch(connectionConfigProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildConnectionSection(connectionConfig),
          const SizedBox(height: 16),
          _buildServerSection(),
          const SizedBox(height: 16),
          _buildAboutSection(),
        ],
      ),
    );
  }

  Widget _buildConnectionSection(ConnectionConfig config) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connection Mode',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Remote Server Mode'),
              subtitle: const Text('Connect to a remote training server'),
              value: _isRemoteMode,
              onChanged: (value) {
                setState(() => _isRemoteMode = value);
                ref.read(connectionConfigProvider.notifier).setRemote(value);
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                config.isConnected ? Icons.cloud_done : Icons.cloud_off,
                color: config.isConnected ? AppColors.success : AppColors.error,
              ),
              title: Text(config.isConnected ? 'Connected' : 'Disconnected'),
              subtitle: Text('${config.host}:${config.port}'),
              trailing: TextButton(
                onPressed: () => _testConnection(),
                child: const Text('Test'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServerSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Server Configuration',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _hostController,
              decoration: const InputDecoration(
                labelText: 'Server Host',
                hintText: 'e.g., localhost or 192.168.1.100',
                prefixIcon: Icon(Icons.dns),
              ),
              enabled: _isRemoteMode,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _portController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Server Port',
                hintText: 'e.g., 8000',
                prefixIcon: Icon(Icons.numbers),
              ),
              enabled: _isRemoteMode,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveServerConfig,
                icon: const Icon(Icons.save),
                label: const Text('Save Configuration'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.psychology),
              title: const Text(AppConstants.appName),
              subtitle: const Text('Version ${AppConstants.appVersion}'),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.description),
              title: Text('Description'),
              subtitle: Text(
                'A beginner-friendly AI model training assistant that supports Visual, NLP, and Generative models.',
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('Features'),
              subtitle: const Text(
                '- Visual Model Training (Image Classification, Object Detection)\n'
                '- NLP Model Training (Text Classification, Sentiment Analysis)\n'
                '- Generative Models\n'
                '- Local and Remote Training\n'
                '- Real-time Progress Monitoring\n'
                '- Model Export (ONNX, TFLite)',
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

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Configuration saved')));
  }

  void _testConnection() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Testing connection...')));
  }
}
