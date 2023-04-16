import 'package:dio/dio.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../../core/app_error.dart';
import 'api_method.dart';

class BaseApi {
  BaseApi({
    required final String baseUrl,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
          ),
        );

  final Dio _dio;

  Future<Result<Map<String, dynamic>, AppError>> request({
    required final ApiMethod method,
    required final String path,
    final Map<String, dynamic>? headers,
    final dynamic data,
  }) async {
    try {
      Response<Map<String, dynamic>> response;
      final options = Options(
        headers: headers,
      );
      if (method == ApiMethod.get) {
        response = await _dio.get<Map<String, dynamic>>(
          path,
          data: data,
          options: options,
        );
      } else if (method == ApiMethod.post) {
        response = await _dio.post<Map<String, dynamic>>(
          path,
          data: data,
          options: options,
        );
      } else if (method == ApiMethod.put) {
        response = await _dio.put<Map<String, dynamic>>(
          path,
          data: data,
          options: options,
        );
      } else if (method == ApiMethod.delete) {
        response = await _dio.delete<Map<String, dynamic>>(
          path,
          data: data,
          options: options,
        );
      } else {
        return Result.error(
          AppError(
            type: AppErrorType.http,
            data: 'Invalid HTTP method',
          ),
        );
      }
      return Result.success(response.data ?? {});
    } on DioError catch (e) {
      final message = e.response?.data?['error']?['message'];
      return Result.error(
        AppError(
          data: message ?? e.message,
          type: AppErrorType.http,
          code: e.response?.statusCode,
        ),
      );
    } on Exception catch (e) {
      return Result.error(
        AppError(data: e),
      );
    }
  }
}
