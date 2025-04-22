import 'package:dio/dio.dart';
import '../errors/failure.dart';

class ApiServices {
  final Dio _dio;
  static const String _baseUrl = 'https://www.googleapis.com/books/v1/';

  ApiServices(this._dio) {
    _dio.options
      ..baseUrl = _baseUrl
      ..connectTimeout = const Duration(seconds: 10)
      ..receiveTimeout = const Duration(seconds: 15);
  }

  Future<Map<String, dynamic>> get({required String endPoint}) async {
    try {
      final response = await _dio.get(endPoint);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to load data',
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Object _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timed out.');
      case DioExceptionType.badResponse:
        return ServiceException(
          'Server error: ${e.response?.statusCode ?? 'Unknown'}',
        );
      case DioExceptionType.cancel:
        return ServiceException('Request was cancelled.');
      case DioExceptionType.unknown:
      default:
        return NetworkException('Unexpected network error: ${e.message}');
    }
  }
}
