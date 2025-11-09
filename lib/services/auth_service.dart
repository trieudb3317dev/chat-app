import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>?> sendOtp(String phoneNumber) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/send-otp',
        data: {'phoneNumber': phoneNumber},
      );

      final cookies = response.headers['set-cookie'];
      if (cookies != null && cookies.isNotEmpty) {
        final sessionCookie = cookies.first.split(';').first;
        final token = sessionCookie.split('=').last;
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        return decodedToken;
      }
      return null;
    } on DioException catch (e) {
      _handleDioError(e, 'Failed to send OTP');
      return null;
    }
  }

  Future<void> register(String username, String otp, String phoneNumber) async {
    try {
      await _apiClient.dio.post(
        '/auth/register',
        data: {'name': username, 'otp': otp, 'phone_number': phoneNumber},
      );
    } on DioException catch (e) {
      _handleDioError(e, 'Failed to register');
    }
  }

  Future<void> login(String phoneNumber, String otp) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/login',
        data: {'phone_number': phoneNumber, 'otp': otp},
      );

      if (response.data is Map<String, dynamic>) {
        final accessToken = response.data['accessToken'] as String?;
        final refreshToken = response.data['refreshToken'] as String?;

        if (accessToken != null && refreshToken != null) {
          await _saveTokens(accessToken, refreshToken);
        }
      }
    } on DioException catch (e) {
      _handleDioError(e, 'Failed to log in');
    }
  }

  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final response = await _apiClient.dio.get('/auth/profile');
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } on DioException catch (e) {
      _handleDioError(e, 'Failed to get profile');
      return null;
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? gender,
    String? dayOfBirth,
  }) async {
    try {
      final data = {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (gender != null) 'gender': gender,
        if (dayOfBirth != null) 'day_of_birth': dayOfBirth,
      };

      if (data.isEmpty) return;

      await _apiClient.dio.patch(
        '/auth/profile',
        data: data,
      );
    } on DioException catch (e) {
      _handleDioError(e, 'Failed to update profile');
    }
  }

  Future<void> updateAvatar(String avatarUrl) async {
    try {
      await _apiClient.dio.patch(
        '/auth/profile/avatar',
        data: {'avatar': avatarUrl},
      );
    } on DioException catch (e) {
      _handleDioError(e, 'Failed to update avatar');
    }
  }

  Future<Map<String, dynamic>?> searchUserByPhone(String phoneNumber) async {
    try {
      final response = await _apiClient.dio.get(
        '/auth/users/find-by-phone/$phoneNumber',
        // queryParameters: {'phoneNumber': phoneNumber},
      );
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      _handleDioError(e, 'Failed to search user');
      return null;
    }
  }

  Future<void> assignToFriend(String phoneNumber) async {
    try {
      await _apiClient.dio.post('/auth/add/$phoneNumber/friend');
    } on DioException catch (e) {
      _handleDioError(e, 'Failed to add friend');
    }
  }

  Future<List<Map<String, dynamic>>> getFriends() async {
    try {
      final response = await _apiClient.dio.get('/auth/users/friends');
      // The API returns { "data": [...] }, so we extract the list from the 'data' key.
      if (response.data != null && response.data['data'] is List) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      }
      return [];
    } on DioException catch (e) {
      _handleDioError(e, 'Failed to get friends');
      return [];
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.dio.post('/auth/logout');
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('accessToken');
      await prefs.remove('refreshToken');
    } on DioException catch (e) {
      _handleDioError(e, 'Failed to log out');
    }
  }

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
  }

  void _handleDioError(DioException e, String defaultMessage) {
    if (e.response != null) {
      print('Error response: ${e.response!.data}');
      throw Exception('$defaultMessage: ${e.response!.data?['message'] ?? 'Unknown error'}');
    } else {
      print('Error sending request: $e');
      throw Exception('Failed to connect to the server.');
    }
  }
}
