import 'package:flutter/material.dart';
import '../services/message_service.dart';

class ConversationProvider with ChangeNotifier {
  final MessageService _messageService = MessageService();

  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  String? _error;
  bool _hasMore = true;
  int _currentPage = 1;

  List<Map<String, dynamic>> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;

  Future<void> fetchMessages(int userId) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    if (_currentPage == 1) {
      _messages.clear();
    }
    notifyListeners();

    try {
      final response = await _messageService.getMessages(userId, page: _currentPage);
      final newMessages = List<Map<String, dynamic>>.from(response['data'] ?? []);
      
      _messages.addAll(newMessages);
      _hasMore = response['pagination']?['hasNextPage'] ?? false;
      if (_hasMore) {
        _currentPage++;
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendMessage(int userId, String text) async {
    // No need to set loading state for sending, for a better UX
    try {
      await _messageService.sendMessage(userId, text);
      // After sending, refresh the messages to see the new one
      // A more optimized approach would be to use WebSockets or add the message locally
      _currentPage = 1; // Reset to page 1 to get the latest messages
      await fetchMessages(userId);
    } catch (e) {
      // Optionally, show an error to the user
      _error = e.toString();
      notifyListeners();
    }
  }
}
