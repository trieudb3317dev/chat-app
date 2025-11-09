import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'api_client.dart';

class FileService {
  final ApiClient _apiClient = ApiClient();

  // Returns the URL of the uploaded image
  Future<String?> uploadImage(XFile imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(imageFile.path, filename: fileName),
      });

      // Correct endpoint as per your API specification
      final response = await _apiClient.dio.post(
        '/auth/profile/upload',
        data: formData,
      );

      if (response.data is Map<String, dynamic>) {
        // The API returns { "message": "...", "url": "..." }
        return response.data['url'];
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Failed to upload image: ${e.response!.data?['message'] ?? 'Unknown error'}');
      } else {
        throw Exception('Failed to connect to the server.');
      }
    }
  }
}
