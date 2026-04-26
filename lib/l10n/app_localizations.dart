import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'ArtificialFlash',
      'appSubtitle': 'AI Training Assistant',
      'home': 'Home',
      'data': 'Data',
      'model': 'Model',
      'train': 'Train',
      'models': 'Models',
      'settings': 'Settings',
      'help': 'Help',
      'about': 'About',
      'connected': 'Connected',
      'disconnected': 'Disconnected',
      'offlineMode': 'Offline Mode',
      'serverConnected': 'Server Connected',
      'noDatasets': 'No datasets yet',
      'noModels': 'No trained models yet',
      'addDataset': 'Add Dataset',
      'uploadData': 'Upload Data',
      'newModel': 'New Model',
      'startTrain': 'Start Training',
      'localFiles': 'Local Files',
      'urlDownload': 'URL Download',
      'builtIn': 'Built-in',
      'datasetName': 'Dataset Name',
      'datasetType': 'Dataset Type',
      'image': 'Image',
      'text': 'Text',
      'mixed': 'Mixed',
      'selectFiles': 'Select Files',
      'download': 'Download',
      'downloading': 'Downloading...',
      'modelName': 'Model Name',
      'modelType': 'Model Type',
      'category': 'Category',
      'visual': 'Visual',
      'nlp': 'NLP',
      'generative': 'Generative',
      'custom': 'Custom',
      'architecture': 'Architecture',
      'trainingData': 'Training Data',
      'selectDataset': 'Select Dataset',
      'trainingParams': 'Training Parameters',
      'learningRate': 'Learning Rate',
      'epochs': 'Epochs',
      'batchSize': 'Batch Size',
      'imageSize': 'Image Size',
      'dataAugmentation': 'Data Augmentation',
      'dataSplit': 'Data Split',
      'trainSplit': 'Train',
      'validationSplit': 'Validation',
      'createModel': 'Create Model',
      'trainingConfiguration': 'Training Configuration',
      'selectModel': 'Select Model',
      'trainingMode': 'Training Mode',
      'local': 'Local',
      'remote': 'Remote',
      'startTraining': 'Start Training',
      'trainingInProgress': 'Training in Progress...',
      'trainingProgress': 'Training Progress',
      'loss': 'Loss',
      'accuracy': 'Accuracy',
      'pause': 'Pause',
      'resume': 'Resume',
      'stopTraining': 'Stop Training',
      'stopTrainingConfirm':
          'Are you sure you want to stop the training? Progress will be lost.',
      'cancel': 'Cancel',
      'stop': 'Stop',
      'noActiveTraining': 'No Active Training',
      'trainingLogs': 'Training Logs',
      'lossCurve': 'Loss Curve',
      'trainedModels': 'Trained Models',
      'refresh': 'Refresh',
      'test': 'Test',
      'export': 'Export',
      'delete': 'Delete',
      'exportModel': 'Export Model',
      'deleteModel': 'Delete Model',
      'deleteModelConfirm': 'Are you sure you want to delete this model?',
      'testModel': 'Test Model',
      'connectionMode': 'Connection Mode',
      'remoteServerMode': 'Remote Server Mode',
      'connectToRemote': 'Connect to a remote training server',
      'serverConfig': 'Server Configuration',
      'serverHost': 'Server Host',
      'serverPort': 'Server Port',
      'saveConfig': 'Save Configuration',
      'testConnection': 'Test',
      'appearance': 'Appearance',
      'theme': 'Theme',
      'lightTheme': 'Light',
      'darkTheme': 'Dark',
      'systemTheme': 'System',
      'language': 'Language',
      'english': 'English',
      'chinese': 'Chinese',
      'version': 'Version',
      'description': 'Description',
      'features': 'Features',
      'visualModels': 'Visual Model Training',
      'nlpModels': 'NLP Model Training',
      'generativeModels': 'Generative Models',
      'localAndRemote': 'Local and Remote Training',
      'realTimeMonitoring': 'Real-time Progress Monitoring',
      'modelExport': 'Model Export',
      'status': 'Status',
      'pending': 'Pending',
      'preparing': 'Preparing',
      'training': 'Training',
      'paused': 'Paused',
      'completed': 'Completed',
      'error': 'Error',
      'ready': 'Ready',
      'exported': 'Exported',
      'files': 'files',
      'created': 'Created',
      'trained': 'Trained',
      'type': 'Type',
      'path': 'Path',
      'baseModel': 'Base Model',
      'dropFilesHere': 'Drop files here',
      'quickActions': 'Quick Actions',
      'gettingStarted': 'Getting Started',
      'step1': 'Upload Your Data',
      'step1Desc':
          'Go to Data tab to upload images or text files for training.',
      'step2': 'Configure Model',
      'step2Desc': 'Choose model type and customize parameters in Model tab.',
      'step3': 'Start Training',
      'step3Desc':
          'Begin training your model and monitor progress in Train tab.',
      'step4': 'Export & Use',
      'step4Desc': 'View and export your trained models in Models tab.',
      'view': 'View',
      'preview': 'Preview',
    },
    'zh': {
      'appTitle': 'ArtificialFlash',
      'appSubtitle': 'AI训练助手',
      'home': '首页',
      'data': '数据',
      'model': '模型',
      'train': '训练',
      'models': '模型库',
      'settings': '设置',
      'help': '帮助',
      'about': '关于',
      'connected': '已连接',
      'disconnected': '未连接',
      'offlineMode': '离线模式',
      'serverConnected': '服务器已连接',
      'noDatasets': '暂无数据集',
      'noModels': '暂无训练模型',
      'addDataset': '添加数据集',
      'uploadData': '上传数据',
      'newModel': '新建模型',
      'startTrain': '开始训练',
      'localFiles': '本地文件',
      'urlDownload': 'URL下载',
      'builtIn': '内置',
      'datasetName': '数据集名称',
      'datasetType': '数据集类型',
      'image': '图像',
      'text': '文本',
      'mixed': '混合',
      'selectFiles': '选择文件',
      'download': '下载',
      'downloading': '下载中...',
      'modelName': '模型名称',
      'modelType': '模型类型',
      'category': '类别',
      'visual': '视觉',
      'nlp': 'NLP',
      'generative': '生成式',
      'custom': '自定义',
      'architecture': '网络架构',
      'trainingData': '训练数据',
      'selectDataset': '选择数据集',
      'trainingParams': '训练参数',
      'learningRate': '学习率',
      'epochs': '轮次',
      'batchSize': '批量大小',
      'imageSize': '图像尺寸',
      'dataAugmentation': '数据增强',
      'dataSplit': '数据划分',
      'trainSplit': '训练集',
      'validationSplit': '验证集',
      'createModel': '创建模型',
      'trainingConfiguration': '训练配置',
      'selectModel': '选择模型',
      'trainingMode': '训练模式',
      'local': '本地',
      'remote': '远程',
      'startTraining': '开始训练',
      'trainingInProgress': '训练进行中...',
      'trainingProgress': '训练进度',
      'loss': '损失',
      'accuracy': '准确率',
      'pause': '暂停',
      'resume': '继续',
      'stopTraining': '停止训练',
      'stopTrainingConfirm': '确定要停止训练吗？进度将会丢失。',
      'cancel': '取消',
      'stop': '停止',
      'noActiveTraining': '无进行中的训练',
      'trainingLogs': '训练日志',
      'lossCurve': '损失曲线',
      'trainedModels': '已训练模型',
      'refresh': '刷新',
      'test': '测试',
      'export': '导出',
      'delete': '删除',
      'exportModel': '导出模型',
      'deleteModel': '删除模型',
      'deleteModelConfirm': '确定要删除此模型吗？',
      'testModel': '测试模型',
      'connectionMode': '连接模式',
      'remoteServerMode': '远程服务器模式',
      'connectToRemote': '连接到远程训练服务器',
      'serverConfig': '服务器配置',
      'serverHost': '服务器地址',
      'serverPort': '服务器端口',
      'saveConfig': '保存配置',
      'testConnection': '测试',
      'appearance': '外观',
      'theme': '主题',
      'lightTheme': '浅色',
      'darkTheme': '深色',
      'systemTheme': '跟随系统',
      'language': '语言',
      'english': '英语',
      'chinese': '中文',
      'version': '版本',
      'description': '描述',
      'features': '功能特点',
      'visualModels': '视觉模型训练',
      'nlpModels': 'NLP模型训练',
      'generativeModels': '生成式模型',
      'localAndRemote': '本地和远程训练',
      'realTimeMonitoring': '实时进度监控',
      'modelExport': '模型导出',
      'status': '状态',
      'pending': '待处理',
      'preparing': '准备中',
      'training': '训练中',
      'paused': '已暂停',
      'completed': '已完成',
      'error': '错误',
      'ready': '就绪',
      'exported': '已导出',
      'files': '个文件',
      'created': '创建时间',
      'trained': '训练时间',
      'type': '类型',
      'path': '路径',
      'baseModel': '基础模型',
      'dropFilesHere': '拖放文件到此处',
      'quickActions': '快捷操作',
      'gettingStarted': '入门指南',
      'step1': '上传数据',
      'step1Desc': '在数据标签页上传图像或文本文件进行训练。',
      'step2': '配置模型',
      'step2Desc': '在模型标签页选择模型类型并自定义参数。',
      'step3': '开始训练',
      'step3Desc': '在训练标签页开始训练并监控进度。',
      'step4': '导出使用',
      'step4Desc': '在模型库标签页查看并导出训练好的模型。',
      'view': '查看',
      'preview': '预览',
    },
  };

  String _translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key] ??
        key;
  }

  String get appTitle => _translate('appTitle');
  String get appSubtitle => _translate('appSubtitle');
  String get home => _translate('home');
  String get data => _translate('data');
  String get model => _translate('model');
  String get train => _translate('train');
  String get models => _translate('models');
  String get settings => _translate('settings');
  String get help => _translate('help');
  String get about => _translate('about');
  String get connected => _translate('connected');
  String get disconnected => _translate('disconnected');
  String get offlineMode => _translate('offlineMode');
  String get serverConnected => _translate('serverConnected');
  String get noDatasets => _translate('noDatasets');
  String get noModels => _translate('noModels');
  String get addDataset => _translate('addDataset');
  String get uploadData => _translate('uploadData');
  String get newModel => _translate('newModel');
  String get startTrain => _translate('startTrain');
  String get localFiles => _translate('localFiles');
  String get urlDownload => _translate('urlDownload');
  String get builtIn => _translate('builtIn');
  String get datasetName => _translate('datasetName');
  String get datasetType => _translate('datasetType');
  String get image => _translate('image');
  String get text => _translate('text');
  String get mixed => _translate('mixed');
  String get selectFiles => _translate('selectFiles');
  String get download => _translate('download');
  String get downloading => _translate('downloading');
  String get modelName => _translate('modelName');
  String get modelType => _translate('modelType');
  String get category => _translate('category');
  String get visual => _translate('visual');
  String get nlp => _translate('nlp');
  String get generative => _translate('generative');
  String get custom => _translate('custom');
  String get architecture => _translate('architecture');
  String get trainingData => _translate('trainingData');
  String get selectDataset => _translate('selectDataset');
  String get trainingParams => _translate('trainingParams');
  String get learningRate => _translate('learningRate');
  String get epochs => _translate('epochs');
  String get batchSize => _translate('batchSize');
  String get imageSize => _translate('imageSize');
  String get dataAugmentation => _translate('dataAugmentation');
  String get dataSplit => _translate('dataSplit');
  String get trainSplit => _translate('trainSplit');
  String get validationSplit => _translate('validationSplit');
  String get createModel => _translate('createModel');
  String get trainingConfiguration => _translate('trainingConfiguration');
  String get selectModel => _translate('selectModel');
  String get trainingMode => _translate('trainingMode');
  String get local => _translate('local');
  String get remote => _translate('remote');
  String get startTraining => _translate('startTraining');
  String get trainingInProgress => _translate('trainingInProgress');
  String get trainingProgress => _translate('trainingProgress');
  String get loss => _translate('loss');
  String get accuracy => _translate('accuracy');
  String get pause => _translate('pause');
  String get resume => _translate('resume');
  String get stopTraining => _translate('stopTraining');
  String get stopTrainingConfirm => _translate('stopTrainingConfirm');
  String get cancel => _translate('cancel');
  String get stop => _translate('stop');
  String get noActiveTraining => _translate('noActiveTraining');
  String get trainingLogs => _translate('trainingLogs');
  String get lossCurve => _translate('lossCurve');
  String get trainedModels => _translate('trainedModels');
  String get refresh => _translate('refresh');
  String get test => _translate('test');
  String get export => _translate('export');
  String get delete => _translate('delete');
  String get exportModel => _translate('exportModel');
  String get deleteModel => _translate('deleteModel');
  String get deleteModelConfirm => _translate('deleteModelConfirm');
  String get testModel => _translate('testModel');
  String get connectionMode => _translate('connectionMode');
  String get remoteServerMode => _translate('remoteServerMode');
  String get connectToRemote => _translate('connectToRemote');
  String get serverConfig => _translate('serverConfig');
  String get serverHost => _translate('serverHost');
  String get serverPort => _translate('serverPort');
  String get saveConfig => _translate('saveConfig');
  String get testConnection => _translate('testConnection');
  String get appearance => _translate('appearance');
  String get theme => _translate('theme');
  String get lightTheme => _translate('lightTheme');
  String get darkTheme => _translate('darkTheme');
  String get systemTheme => _translate('systemTheme');
  String get language => _translate('language');
  String get english => _translate('english');
  String get chinese => _translate('chinese');
  String get version => _translate('version');
  String get description => _translate('description');
  String get features => _translate('features');
  String get visualModels => _translate('visualModels');
  String get nlpModels => _translate('nlpModels');
  String get generativeModels => _translate('generativeModels');
  String get localAndRemote => _translate('localAndRemote');
  String get realTimeMonitoring => _translate('realTimeMonitoring');
  String get modelExport => _translate('modelExport');
  String get status => _translate('status');
  String get pending => _translate('pending');
  String get preparing => _translate('preparing');
  String get training => _translate('training');
  String get paused => _translate('paused');
  String get completed => _translate('completed');
  String get error => _translate('error');
  String get ready => _translate('ready');
  String get exported => _translate('exported');
  String get files => _translate('files');
  String get created => _translate('created');
  String get trained => _translate('trained');
  String get type => _translate('type');
  String get path => _translate('path');
  String get baseModel => _translate('baseModel');
  String get dropFilesHere => _translate('dropFilesHere');
  String get quickActions => _translate('quickActions');
  String get gettingStarted => _translate('gettingStarted');
  String get step1 => _translate('step1');
  String get step1Desc => _translate('step1Desc');
  String get step2 => _translate('step2');
  String get step2Desc => _translate('step2Desc');
  String get step3 => _translate('step3');
  String get step3Desc => _translate('step3Desc');
  String get step4 => _translate('step4');
  String get step4Desc => _translate('step4Desc');
  String get view => _translate('view');
  String get preview => _translate('preview');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
