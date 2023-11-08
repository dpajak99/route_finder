import 'package:dio/dio.dart';

class ApiManager {
  Future<Response<T>> get<T>({
    required Uri networkUri,
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      Dio httpClient = Dio(BaseOptions(
        baseUrl: networkUri.toString(),
        headers: headers,
      ));
      _printUrl(method: 'GET', networkUri: networkUri.toString(), path: path, queryParameters: queryParameters);
      return await httpClient.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioError {
      rethrow;
    }
  }

  Future<Response<T>> post<T>({
    required Uri networkUri,
    required String path,
    required Map<String, dynamic> body,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      Dio httpClient = Dio(BaseOptions(
        baseUrl: networkUri.toString(),
        headers: headers,
      ));
      _printUrl(method: 'POST', networkUri: networkUri.toString(), path: path, queryParameters: queryParameters);
      return await httpClient.post<T>(
        path,
        data: body,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioError {
      rethrow;
    }
  }

  void _printUrl({
    required String method,
    required String networkUri,
    String? path,
    Map<String, dynamic>? queryParameters,
    dynamic body,
  }) {
    String printValue = '$method | $networkUri';
    if (path != null) {
      printValue += path;
    }
    if (queryParameters != null) {
      printValue +=
          '?${queryParameters.keys.map((String key) => queryParameters[key] != null ? '$key=${queryParameters[key]}' : '').toList().where((String e) => e != '').join('&')}';
    }
    print(printValue);
    if (body != null) {
      print('Body: $body');
    }
  }
}
