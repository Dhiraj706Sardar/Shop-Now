import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../network/api_client.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const apiKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im96ZHF2dHltbGF2bnptcG5pYWl3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM5NTc5NzUsImV4cCI6MjA3OTUzMzk3NX0.KkUEZ4czOpRsYkfxhSzKCh9ElczF7D7Dw0_uzd9pCMs';

@module
abstract class NetworkModule {
  @lazySingleton
  ApiClient apiClient(@lazySingleton Dio dio) => ApiClient(dio);

  @lazySingleton
  Dio dio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://ozdqvtymlavnzmpniaiw.supabase.co',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
          'Accept': 'application/json',
        },
      ),
    );
    dio.interceptors.addAll([
      PrettyDioLogger(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        maxWidth: 90,
        compact: true,
        logPrint: (message) {
          print(message);
        },
      ),
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Authorization'] = 'Bearer $apiKey';
          return handler.next(options);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    ]);
    return dio;
  }
}
