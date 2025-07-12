part of '_client.dart';

final _options = Options(
  receiveTimeout: const Duration(seconds: 5000),
  sendTimeout: const Duration(seconds: 6000),
);

Future<Response<T>> getIt<T>(
  String url, {
  Map<String, String>? headers,
  Map<String, dynamic>? queryParameters,
}) async {
  final getHeaders = headers ?? PrefService.getHeaders();
  if (kDebugMode) {
    LoggerService.i({
      'url': url,
      'headers': headers,
    });
  }
  final resp = await get<Dio>().get<T>(
    url,
    options: _options.copyWith(
      headers: getHeaders,
    ),
    queryParameters: queryParameters,
  );

  if (kDebugMode) {
    LoggerService.i({
      'response': '${resp.data}',
      'statusCode': '${resp.statusCode}',
    });
  }

  return resp;
}

Future<Response<T>> postIt<T>(
  String url, {
  Map<String, String>? headers,
  Map<String, dynamic>? model,
  Map<String, dynamic>? queryParameters,
}) async {
  final getHeaders = headers ?? PrefService.getHeaders();
  if (kDebugMode) {
    LoggerService.i({
      'url': url,
      'headers': headers,
      'model': '$model',
    });
  }
  final resp = await get<Dio>().post<T>(
    url,
    data: json.encode(model),
    options: _options.copyWith(
      headers: getHeaders,
    ),
    queryParameters: queryParameters,
  );
  if (kDebugMode) {
    LoggerService.i({
      'response': '${resp.data}',
      'statusCode': '${resp.statusCode}',
    });
  }
  return resp;
}

Future<Response<T>> putIt<T>(
  String url, {
  Map<String, String>? headers,
  Map<String, dynamic>? model,
  Map<String, dynamic>? queryParameters,
}) async {
  final getHeaders = headers ?? PrefService.getHeaders();
  if (kDebugMode) {
    LoggerService.i({
      'url': url,
      'headers': headers,
      'model': '$model',
    });
  }
  final resp = await get<Dio>().put<T>(
    url,
    data: json.encode(model),
    options: _options.copyWith(
      headers: getHeaders,
    ),
    queryParameters: queryParameters,
  );
  if (kDebugMode) {
    LoggerService.i({
      'response': '${resp.data}',
      'statusCode': '${resp.statusCode}',
    });
  }
  return resp;
}
