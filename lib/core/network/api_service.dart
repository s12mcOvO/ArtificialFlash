import 'package:dio/dio.dart';
import 'package:artificial_flash/core/constants/app_constants.dart';

class ApiService {
  late final Dio _dio;
  String _host = ApiConstants.defaultLocalHost;
  int _port = ApiConstants.defaultPort;
  bool _useHttps = false;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );
  }

  void updateConnection(String host, int port, {bool useHttps = false}) {
    _host = host;
    _port = port;
    _useHttps = useHttps;
  }

  String get baseUrl {
    final protocol = _useHttps ? 'https' : ApiConstants.httpProtocol;
    return '$protocol://$_host:$_port${ApiConstants.apiVersion}';
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.get<T>('$baseUrl$path', queryParameters: queryParameters);
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.post<T>(
      '$baseUrl$path',
      data: data,
      queryParameters: queryParameters,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.put<T>(
      '$baseUrl$path',
      data: data,
      queryParameters: queryParameters,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.delete<T>('$baseUrl$path', queryParameters: queryParameters);
  }

  Future<Response<T>> uploadFile<T>(
    String path, {
    required String filePath,
    required String fieldName,
    Map<String, dynamic>? additionalData,
    void Function(int, int)? onSendProgress,
  }) async {
    final formData = FormData.fromMap({
      fieldName: await MultipartFile.fromFile(filePath),
      ...?additionalData,
    });

    return _dio.post<T>(
      '$baseUrl$path',
      data: formData,
      onSendProgress: onSendProgress,
    );
  }

  Future<Response> downloadFile<T>(
    String url,
    String savePath, {
    void Function(int, int)? onReceiveProgress,
  }) async {
    return _dio.download(url, savePath, onReceiveProgress: onReceiveProgress);
  }
}
