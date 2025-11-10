import 'package:chat_app/services/api_client.dart';
import 'package:dio/dio.dart';

class GroupService {
  final ApiClient _apiClient = ApiClient();

  /// Fetches a paginated list of user groups from the API.
  Future<Map<String, dynamic>> getGroups({int page = 1, int limit = 20}) async {
    try {
      final response = await _apiClient.dio.get(
        '/user-groups',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.data is Map<String, dynamic>) {
        return response.data;
      }
      return {'data': [], 'pagination': {}};
    } on DioException catch (e) {
      _handleDioError(e, 'Failed to get groups');
      rethrow; // Rethrow to be handled by the provider
    }
  }

  /// Creates a new group.
  Future<void> createGroup(String name, List<int> userIds) async {
    try {
      await _apiClient.dio.post(
        '/user-groups',
        data: {
          'name': name,
          'users': userIds,
        },
      );
    } on DioException catch (e) {
      _handleDioError(e, 'Failed to create group');
      rethrow; // Rethrow to be handled by the provider
    }
  }

  // Private error handler
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
