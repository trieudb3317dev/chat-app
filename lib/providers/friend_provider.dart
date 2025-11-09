import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class FriendProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  List<Map<String, dynamic>> _friends = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get friends => _friends;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchFriends() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _friends = await _authService.getFriends();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
