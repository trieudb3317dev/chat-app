import 'package:dio/dio.dart';
import 'api_client.dart';

class MessageService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> getMessages(
    int userId,
    {int page = 1, int limit = 20}
  ) async {
    try {
      final response = await _apiClient.dio.get(
        '/messages/chat/$userId',
        queryParameters: {'page': page, 'limit': limit},
      );
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      return {};
    } on DioException catch (e) {
      // Using a generic error handler from another service is not ideal,
      // but for simplicity, we'll re-throw a clearer message.
      if (e.response != null) {
        throw Exception('Failed to get messages: ${e.response!.data?['message'] ?? 'Unknown error'}');
      } else {
        throw Exception('Failed to connect to the server.');
      }
    }
  }

  Future<void> sendMessage(int userId, String text) async {
    try {
      await _apiClient.dio.post(
        '/messages/chat/$userId',
        data: {'text': text},
      );
    } on DioException catch (e) {
       if (e.response != null) {
        throw Exception('Failed to send message: ${e.response!.data?['message'] ?? 'Unknown error'}');
      } else {
        throw Exception('Failed to connect to the server.');
      }
    }
  }
}
