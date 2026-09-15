/// Contract implemented by [DioClient], so data sources depend on this
/// interface instead of `dio` directly (keeps them testable/mockable).
abstract interface class HttpClient {
  Future<HttpResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  });

  Future<HttpResponse<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  });

  Future<HttpResponse<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  });

  Future<HttpResponse<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  });
}

/// Transport-agnostic response returned by [HttpClient], so callers don't
/// depend on `dio`'s `Response` type directly.
class HttpResponse<T> {
  const HttpResponse({required this.data, required this.statusCode});

  final T? data;
  final int? statusCode;
}
