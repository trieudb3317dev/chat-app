import 'package:chat_app/services/file_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';

class ProfileProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FileService _fileService = FileService();


  Map<String, dynamic>? _userProfile;
  bool _isLoading = false;
  String? _error;

  // For friend search
  Map<String, dynamic>? _searchedUser;
  bool _isSearching = false;

  Map<String, dynamic>? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Map<String, dynamic>? get searchedUser => _searchedUser;
  bool get isSearching => _isSearching;

  Future<void> fetchProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _userProfile = await _authService.getProfile();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateProfile({
    String? name,
    String? email,
    String? gender,
    String? dayOfBirth,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.updateProfile(
        name: name,
        email: email,
        gender: gender,
        dayOfBirth: dayOfBirth,
      );
      await fetchProfile();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Future<bool> updateAvatar(String avatarUrl) async {
  //   _isLoading = true;
  //   _error = null;
  //   notifyListeners();
  //
  //   try {
  //     await _authService.updateAvatar(avatarUrl);
  //     await fetchProfile();
  //     return true;
  //   } catch (e) {
  //     _error = e.toString();
  //     _isLoading = false;
  //     notifyListeners();
  //     return false;
  //   }
  // }

  Future<void> searchUser(String phoneNumber) async {
    _isSearching = true;
    _searchedUser = null;
    _error = null;
    notifyListeners();

    try {
      _searchedUser = await _authService.searchUserByPhone(phoneNumber);
    } catch (e) {
      _error = e.toString();
    }

    _isSearching = false;
    notifyListeners();
  }

  Future<bool> assignToFriend(String phoneNumber) async {
     _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.assignToFriend(phoneNumber);
       _isLoading = false;
       notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
       _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateAvatar(String avatarUrl) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.updateAvatar(avatarUrl);
      await fetchProfile();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> uploadAndSetAvatar(XFile imageFile) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Step 1: Upload the image and get the URL
      final imageUrl = await _fileService.uploadImage(imageFile);

      if (imageUrl == null) {
        throw Exception('Failed to get image URL after upload.');
      }

      // Step 2: Update the user's profile with the new URL
      await _authService.updateAvatar(imageUrl);

      // Step 3: Refresh the profile data to show the new avatar
      await fetchProfile();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> logout() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.logout();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
