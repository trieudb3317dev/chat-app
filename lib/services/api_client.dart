import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  late final Dio dio;
  final CookieJar _cookieJar = CookieJar();

  ApiClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://g9ctx057-8080.asse.devtunnels.ms/api/v1',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    dio.interceptors.add(CookieManager(_cookieJar));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final accessToken = prefs.getString('accessToken');
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          try {
            // If a 401 response is received, refresh the token
            final prefs = await SharedPreferences.getInstance();
            final refreshToken = prefs.getString('refreshToken');

            if (refreshToken != null) {
              final refreshDio = Dio(); // Create a new Dio instance for the refresh token request
              final response = await refreshDio.post(
                '${dio.options.baseUrl}/auth/refresh',
                data: {'refreshToken': refreshToken},
              );

              if (response.statusCode == 200) {
                final newAccessToken = response.data['accessToken'] as String;
                await prefs.setString('accessToken', newAccessToken);

                // Update the header of the original request with the new token
                e.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

                // Retry the original request
                return handler.resolve(await dio.fetch(e.requestOptions));
              }
            }
          } catch (refreshError) {
            // If refresh fails, pass the original error
            return handler.next(e);
          }
        }
        return handler.next(e);
      },
    ));

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() {
    return _instance;
  }
}
