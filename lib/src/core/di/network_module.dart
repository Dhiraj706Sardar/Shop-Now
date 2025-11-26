import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../network/api_client.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  ApiClient apiClient(Dio dio) => ApiClient(dio);
}
