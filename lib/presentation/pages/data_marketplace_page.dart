import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:artificial_flash/core/theme/app_theme.dart';
import 'package:artificial_flash/presentation/providers/dataset_provider.dart';

class DataMarketplacePage extends ConsumerWidget {
  const DataMarketplacePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadProgress = ref.watch(downloadProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Marketplace'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _MarketplaceGrid(downloadProgress: downloadProgress),
    );
  }
}

class _MarketplaceGrid extends StatelessWidget {
  final DownloadProgress? downloadProgress;

  const _MarketplaceGrid({this.downloadProgress});

  @override
  Widget build(BuildContext context) {
    final datasets = _getMarketplaceDatasets();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.3,
      ),
      itemCount: datasets.length,
      itemBuilder: (context, index) {
        return _MarketplaceCard(dataset: datasets[index]);
      },
    );
  }

  List<_MarketplaceDataset> _getMarketplaceDatasets() {
    return [
      _MarketplaceDataset(
        name: 'MNIST',
        description: 'Handwritten digits 0-9',
        size: '45 MB',
        downloads: 50000,
        image: 'https:// commutativityMNIST-image.png',
        tags: ['image', 'classification'],
        source: 'http://yann.lecun.com/exdb/mnist/',
      ),
      _MarketplaceDataset(
        name: 'CIFAR-10',
        description: '10-class colored images',
        size: '170 MB',
        downloads: 45000,
        image: 'https://www.cs.toronto.edu/~kriz/cifar.html',
        tags: ['image', 'classification'],
        source: 'https://www.cs.toronto.edu/~kriz/cifar.html',
      ),
      _MarketplaceDataset(
        name: 'Fashion-MNIST',
        description: 'Zalando fashion articles',
        size: '26 MB',
        downloads: 40000,
        image: 'https://github.com/zalandoresearch/fashion-mnist',
        tags: ['image', 'classification'],
        source: 'https://github.com/zalandoresearch/fashion-mnist',
      ),
      _MarketplaceDataset(
        name: 'IMDB Reviews',
        description: 'Movie review sentiment',
        size: '80 MB',
        downloads: 30000,
        image: 'https://ai.stanford.edu/~amaas/data/sentiment/',
        tags: ['text', 'sentiment'],
        source: 'https://ai.stanford.edu/~amaas/data/sentiment/',
      ),
      _MarketplaceDataset(
        name: 'SST-2',
        description: 'Stanford sentiment treebank',
        size: '10 MB',
        downloads: 25000,
        image: 'https://nlp.stanford.edu/sentiment/',
        tags: ['text', 'sentiment'],
        source: 'https://nlp.stanford.edu/sentiment/',
      ),
      _MarketplaceDataset(
        name: 'COCO',
        description: 'Object detection & segmentation',
        size: '25 GB',
        downloads: 20000,
        image: 'http://cocodataset.org/',
        tags: ['image', 'detection', 'segmentation'],
        source: 'http://cocodataset.org/',
      ),
    ];
  }
}

class _MarketplaceDataset {
  final String name;
  final String description;
  final String size;
  final int downloads;
  final String image;
  final List<String> tags;
  final String source;

  _MarketplaceDataset({
    required this.name,
    required this.description,
    required this.size,
    required this.downloads,
    required this.image,
    required this.tags,
    required this.source,
  });
}

class _MarketplaceCard extends ConsumerWidget {
  final _MarketplaceDataset dataset;

  const _MarketplaceCard({required this.dataset});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDownloading =
        ref.watch(downloadProgressProvider)?.isDownloading ?? false;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isDownloading ? null : () => _downloadDataset(context, ref),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 80,
              width: double.infinity,
              color: AppColors.primary.withAlpha(26),
              child: Center(
                child: Icon(
                  _getIconForType(dataset.tags),
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dataset.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dataset.description,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.download, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          _formatDownloads(dataset.downloads),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          dataset.size,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(List<String> tags) {
    if (tags.contains('image')) return Icons.image;
    if (tags.contains('text')) return Icons.text_fields;
    if (tags.contains('detection')) return Icons.center_focus_strong;
    return Icons.folder;
  }

  String _formatDownloads(int downloads) {
    if (downloads >= 1000) {
      return '${(downloads / 1000).toStringAsFixed(1)}K';
    }
    return downloads.toString();
  }

  void _downloadDataset(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Download ${dataset.name}?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Size: ${dataset.size}'),
            const SizedBox(height: 8),
            Text('Description: ${dataset.description}'),
            const SizedBox(height: 8),
            Text('Source: ${dataset.source}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(downloadProgressProvider.notifier)
                  .downloadDataset(dataset.source);
            },
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }
}
