import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:cross_file/cross_file.dart';
import 'package:artificial_flash/presentation/providers/dataset_provider.dart';
import 'package:artificial_flash/domain/entities/dataset.dart';
import 'package:artificial_flash/core/theme/app_theme.dart';

class DataPage extends ConsumerStatefulWidget {
  const DataPage({super.key});

  @override
  ConsumerState<DataPage> createState() => _DataPageState();
}

class _DataPageState extends ConsumerState<DataPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Management'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Local Files'),
            Tab(text: 'URL Download'),
            Tab(text: 'Built-in'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _LocalFilesTab(
            isDragging: _isDragging,
            onDragStateChanged: (v) => setState(() => _isDragging = v),
          ),
          _UrlDownloadTab(),
          _BuiltInTab(onDownload: _downloadBuiltIn),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDatasetDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Dataset'),
      ),
    );
  }

  void _showAddDatasetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _AddDatasetDialog(),
    );
  }

  void _downloadBuiltIn(BuildContext context, String name) {
    ref.read(downloadProgressProvider.notifier).downloadDataset(name);
    _showDownloadDialog(context, name);
  }

  void downloadFromUrl(String name) {
    ref.read(downloadProgressProvider.notifier).downloadDataset(name);
    _showDownloadDialog(context, name);
  }

  void _showDownloadDialog(BuildContext context, String name) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Consumer(
        builder: (dialogContext, dialogRef, _) {
          final progress = ref.watch(downloadProgressProvider);

          if (progress == null || progress.datasetName != name) {
            return AlertDialog(
              title: Text('Downloading $name'),
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Preparing download...'),
                ],
              ),
            );
          }

          if (progress.isCompleted) {
            return AlertDialog(
              title: const Text('Download Complete'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text('$name has been downloaded successfully.'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    ref.read(downloadProgressProvider.notifier).clear();
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          }

          return AlertDialog(
            title: Text('Downloading $name'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(
                  value: progress.progress,
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  '${(progress.progress * 100).toStringAsFixed(0)}% downloaded',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  ref.read(downloadProgressProvider.notifier).cancelDownload();
                  Navigator.pop(dialogContext);
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LocalFilesTab extends ConsumerWidget {
  final bool isDragging;
  final Function(bool) onDragStateChanged;

  const _LocalFilesTab({
    required this.isDragging,
    required this.onDragStateChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final datasets = ref.watch(datasetsProvider);

    return DropTarget(
      onDragEntered: (_) => onDragStateChanged(true),
      onDragExited: (_) => onDragStateChanged(false),
      onDragDone: (details) {
        onDragStateChanged(false);
        _handleDroppedFiles(context, ref, details.files);
      },
      child: Stack(
        children: [
          datasets.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (data) {
              if (data.isEmpty) {
                return _buildEmptyState(context);
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final dataset = data[index];
                  return _DatasetCard(dataset: dataset);
                },
              );
            },
          ),
          if (isDragging)
            Container(
              color: AppColors.primary.withAlpha(51),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cloud_upload,
                        size: 64,
                        color: AppColors.primary,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Drop files here',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No datasets yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Click the + button or drag files here to add',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void _handleDroppedFiles(
    BuildContext context,
    WidgetRef ref,
    List<dynamic> files,
  ) async {
    if (files.isEmpty) return;

    final paths = files.map((f) => (f as XFile).path).toList();
    final firstPath = paths.first;
    final ext = firstPath.split('.').last.toLowerCase();

    DatasetType type = DatasetType.mixed;
    if (['jpg', 'jpeg', 'png', 'bmp', 'gif', 'webp'].contains(ext)) {
      type = DatasetType.image;
    } else if (['txt', 'csv', 'json', 'jsonl'].contains(ext)) {
      type = DatasetType.text;
    }

    final name = 'Dataset_${DateTime.now().millisecondsSinceEpoch}';

    await ref
        .read(datasetsProvider.notifier)
        .addDataset(name: name, path: firstPath, type: type);

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Added ${paths.length} files')));
    }
  }
}

class _DatasetCard extends ConsumerWidget {
  final Dataset dataset;

  const _DatasetCard({required this.dataset});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showDatasetDetails(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getTypeColor(dataset.type).withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getTypeIcon(dataset.type),
                  color: _getTypeColor(dataset.type),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dataset.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _StatusBadge(status: dataset.status),
                        const SizedBox(width: 8),
                        Text(
                          '${dataset.fileCount} files',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (dataset.path.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              dataset.path,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'preview',
                    child: Row(
                      children: [
                        Icon(Icons.preview),
                        SizedBox(width: 8),
                        Text('Preview'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: AppColors.error),
                        SizedBox(width: 8),
                        Text(
                          'Delete',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'delete') {
                    _showDeleteConfirmation(context, ref);
                  } else if (value == 'preview') {
                    _showDatasetDetails(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(DatasetType type) {
    switch (type) {
      case DatasetType.image:
        return Icons.image;
      case DatasetType.text:
        return Icons.text_snippet;
      case DatasetType.mixed:
        return Icons.folder;
    }
  }

  Color _getTypeColor(DatasetType type) {
    switch (type) {
      case DatasetType.image:
        return AppColors.primary;
      case DatasetType.text:
        return AppColors.secondary;
      case DatasetType.mixed:
        return AppColors.accent;
    }
  }

  void _showDatasetDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (sheetCtx, scrollController) => Consumer(
          builder: (sheetCtx, ref, _) => _DatasetDetailsContent(
            dataset: dataset,
            scrollController: scrollController,
            onPreview: () => _showDataPreview(context, ref),
          ),
        ),
      ),
    );
  }

  void _showDataPreview(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => _DataPreviewDialog(dataset: dataset),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Dataset'),
        content: Text('Are you sure you want to delete "${dataset.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ref.read(datasetsProvider.notifier).deleteDataset(dataset.id);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final DatasetStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;
    switch (status) {
      case DatasetStatus.pending:
        color = Colors.orange;
        text = 'Pending';
      case DatasetStatus.uploading:
        color = AppColors.primary;
        text = 'Uploading';
      case DatasetStatus.ready:
        color = AppColors.success;
        text = 'Ready';
      case DatasetStatus.error:
        color = AppColors.error;
        text = 'Error';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label, value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _UrlDownloadTab extends StatefulWidget {
  @override
  State<_UrlDownloadTab> createState() => _UrlDownloadTabState();
}

class _UrlDownloadTabState extends State<_UrlDownloadTab> {
  final _urlController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Download Dataset from URL',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Dataset Name',
              hintText: 'Enter a name',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(
              labelText: 'URL',
              hintText: 'Enter the download URL',
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _startDownload,
              icon: const Icon(Icons.download),
              label: const Text('Download'),
            ),
          ),
        ],
      ),
    );
  }

  void _startDownload() {
    if (_urlController.text.isEmpty || _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final name = _nameController.text.trim();
    context.findAncestorStateOfType<_DataPageState>()?.downloadFromUrl(name);
  }
}

class _BuiltInTab extends StatelessWidget {
  final void Function(BuildContext, String) onDownload;

  const _BuiltInTab({required this.onDownload});

  @override
  Widget build(BuildContext context) {
    final builtInDatasets = [
      {
        'name': 'MNIST',
        'description': 'Handwritten digit images (60k training, 10k test)',
        'type': 'image',
        'size': '~50MB',
      },
      {
        'name': 'CIFAR-10',
        'description': '10-class image dataset',
        'type': 'image',
        'size': '~170MB',
      },
      {
        'name': 'Fashion-MNIST',
        'description': '10-class fashion product images',
        'type': 'image',
        'size': '~30MB',
      },
      {
        'name': 'WanJuan2.0',
        'description': 'Chinese web corpus (100B tokens)',
        'type': 'text',
        'size': '~500GB',
      },
      {
        'name': 'IMDB Reviews',
        'description': 'Movie review sentiment data',
        'type': 'text',
        'size': '~80MB',
      },
      {
        'name': 'SST-2',
        'description': 'Stanford Sentiment Treebank',
        'type': 'text',
        'size': '~10MB',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: builtInDatasets.length,
      itemBuilder: (context, index) {
        final dataset = builtInDatasets[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Icon(
              dataset['type'] == 'image' ? Icons.image : Icons.text_snippet,
              color: AppColors.primary,
            ),
            title: Text(dataset['name'] as String),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dataset['description'] as String),
                Text(
                  'Size: ${dataset['size']}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            isThreeLine: true,
            trailing: ElevatedButton(
              onPressed: () => onDownload(context, dataset['name'] as String),
              child: const Text('Download'),
            ),
          ),
        );
      },
    );
  }
}

class _AddDatasetDialog extends ConsumerStatefulWidget {
  const _AddDatasetDialog();

  @override
  ConsumerState<_AddDatasetDialog> createState() => _AddDatasetDialogState();
}

class _AddDatasetDialogState extends ConsumerState<_AddDatasetDialog> {
  final _nameController = TextEditingController();
  DatasetType _selectedType = DatasetType.image;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Dataset'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Dataset Name',
                hintText: 'Enter a name',
              ),
            ),
            const SizedBox(height: 16),
            const Text('Dataset Type'),
            const SizedBox(height: 8),
            SegmentedButton<DatasetType>(
              segments: const [
                ButtonSegment(value: DatasetType.image, label: Text('Image')),
                ButtonSegment(value: DatasetType.text, label: Text('Text')),
                ButtonSegment(value: DatasetType.mixed, label: Text('Mixed')),
              ],
              selected: {_selectedType},
              onSelectionChanged: (selected) =>
                  setState(() => _selectedType = selected.first),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _pickAndAddFiles,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Select Files'),
        ),
      ],
    );
  }

  Future<void> _pickAndAddFiles() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a name')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: _selectedType == DatasetType.image
            ? FileType.image
            : FileType.custom,
        allowedExtensions: _selectedType == DatasetType.image
            ? ['jpg', 'jpeg', 'png', 'bmp', 'gif']
            : ['txt', 'csv', 'json'],
      );
      if (result != null && result.files.isNotEmpty) {
        final path = result.files.first.path ?? '';
        await ref
            .read(datasetsProvider.notifier)
            .addDataset(
              name: _nameController.text,
              path: path,
              type: _selectedType,
            );
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Added ${result.files.length} files')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

class _DatasetDetailsContent extends StatelessWidget {
  final Dataset dataset;
  final ScrollController scrollController;
  final VoidCallback onPreview;

  const _DatasetDetailsContent({
    required this.dataset,
    required this.scrollController,
    required this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            dataset.name,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _StatusBadge(status: dataset.status),
          const SizedBox(height: 24),
          _DetailRow(label: 'Type', value: dataset.type.name),
          _DetailRow(label: 'Files', value: '${dataset.fileCount}'),
          _DetailRow(
            label: 'Path',
            value: dataset.path.isNotEmpty ? dataset.path : 'N/A',
          ),
          _DetailRow(
            label: 'Created',
            value: dataset.createdAt.toString().substring(0, 19),
          ),
          const SizedBox(height: 24),
          if (dataset.type == DatasetType.image && dataset.fileCount > 0) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onPreview,
                icon: const Icon(Icons.preview),
                label: const Text('Preview Images'),
              ),
            ),
          ] else if (dataset.type == DatasetType.text &&
              dataset.fileCount > 0) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onPreview,
                icon: const Icon(Icons.preview),
                label: const Text('Preview Text'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DataPreviewDialog extends ConsumerStatefulWidget {
  final Dataset dataset;

  const _DataPreviewDialog({required this.dataset});

  @override
  ConsumerState<_DataPreviewDialog> createState() => _DataPreviewDialogState();
}

class _DataPreviewDialogState extends ConsumerState<_DataPreviewDialog> {
  List<String> _previewItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreview();
  }

  Future<void> _loadPreview() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _previewItems = List.generate(
          widget.dataset.fileCount > 10 ? 10 : widget.dataset.fileCount,
          (i) => 'Sample item ${i + 1}',
        );
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Preview: ${widget.dataset.name}'),
      content: SizedBox(
        width: 400,
        height: 300,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : widget.dataset.type == DatasetType.image
            ? _buildImagePreview()
            : widget.dataset.type == DatasetType.text
            ? _buildTextPreview()
            : _buildMixedPreview(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _previewItems.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Center(
            child: Icon(Icons.image, color: Colors.grey[400], size: 32),
          ),
        );
      },
    );
  }

  Widget _buildTextPreview() {
    return ListView.separated(
      itemCount: _previewItems.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        return ListTile(
          dense: true,
          leading: const Icon(Icons.text_snippet),
          title: Text(
            'Text sample ${index + 1}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            'This is sample text content for preview...',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        );
      },
    );
  }

  Widget _buildMixedPreview() {
    return ListView.separated(
      itemCount: _previewItems.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final isImage = index % 2 == 0;
        return ListTile(
          dense: true,
          leading: Icon(isImage ? Icons.image : Icons.text_snippet),
          title: Text(
            isImage ? 'Image sample ${index + 1}' : 'Text sample ${index + 1}',
          ),
        );
      },
    );
  }
}
