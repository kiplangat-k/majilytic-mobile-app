import 'package:dio/dio.dart';
import 'auth_interceptor.dart';

class DioProvider {
  final AuthInterceptor authInterceptor; // 👈 Make sure this line exists!

  DioProvider(this.authInterceptor);

  Dio createDioInstance() {
    final dio = Dio();
    dio.interceptors.add(authInterceptor);
    return dio;
  }
}