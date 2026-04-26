class ApiConstants {
  static const String defaultLocalHost = 'localhost';
  static const int defaultPort = 8000;
  static const String wsProtocol = 'ws';
  static const String httpProtocol = 'http';
  static const String wsEndpoint = '/ws';
  static const String apiVersion = '/api/v1';

  static const String datasetsEndpoint = '$apiVersion/datasets';
  static const String modelsEndpoint = '$apiVersion/models';
  static const String trainingEndpoint = '$apiVersion/training';
  static const String inferenceEndpoint = '$apiVersion/inference';
}

class AppConstants {
  static const String appName = 'ArtificialFlash';
  static const String appVersion = '1.0.0';

  static const int maxTrainingLogs = 1000;
  static const int wsReconnectDelay = 3000;
  static const int trainingUpdateInterval = 1000;

  static const List<String> supportedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'bmp',
    'gif',
    'webp',
  ];

  static const List<String> supportedTextFormats = [
    'txt',
    'csv',
    'json',
    'jsonl',
  ];

  static const List<String> supportedModelFormats = [
    'onnx',
    'tflite',
    'pt',
    'h5',
    'pb',
  ];
}

class ModelTypes {
  static const String visual = 'visual';
  static const String nlp = 'nlp';
  static const String generative = 'generative';
  static const String custom = 'custom';

  static const List<String> visualModels = [
    'image_classification',
    'object_detection',
    'image_segmentation',
  ];

  static const List<String> nlpModels = [
    'text_classification',
    'sentiment_analysis',
    'question_answering',
  ];

  static const List<String> generativeModels = [
    'text_to_image',
    'image_to_image',
  ];
}
