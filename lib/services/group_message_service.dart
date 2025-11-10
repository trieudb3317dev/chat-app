import 'package:dio/dio.dart';
import 'api_client.dart';

class GroupMessageService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> getGroupMessages(
    int groupId,
    {int page = 1, int limit = 20}
  ) async {
    try {
      final response = await _apiClient.dio.get(
        '/messages/group/chat/$groupId',
        queryParameters: {'page': page, 'limit': limit},
      );
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }
      return {};
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to get group messages: ${e.response!.data?['message'] ?? 'Unknown error'}');
      } else {
        throw Exception('Failed to connect to the server.');
      }
    }
  }

  Future<void> sendGroupMessage(int groupId, String text) async {
    try {
      await _apiClient.dio.post(
        '/messages/group/chat/$groupId',
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
