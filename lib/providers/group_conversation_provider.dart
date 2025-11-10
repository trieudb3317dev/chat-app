import 'package:chat_app/services/group_message_service.dart';
import 'package:flutter/material.dart';

class GroupConversationProvider with ChangeNotifier {
  final GroupMessageService _messageService = GroupMessageService();

  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  String? _error;
  bool _hasMore = true;
  int _currentPage = 1;

  List<Map<String, dynamic>> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;

  Future<void> fetchMessages(int groupId, {bool isRefresh = false}) async {
    if ((_isLoading && !isRefresh) || (!isRefresh && !_hasMore)) return;

    _isLoading = true;
    if (isRefresh) {
      _currentPage = 1;
      _messages.clear();
      _hasMore = true;
    }
    _error = null;
    notifyListeners();

    try {
      final response = await _messageService.getGroupMessages(groupId, page: _currentPage);
      final newMessages = List<Map<String, dynamic>>.from(response['data'] ?? []);

      _messages.addAll(newMessages);

      final pagination = response['pagination'] as Map<String, dynamic>? ?? {};
      _hasMore = pagination['hasNextPage'] ?? false;

      if (_hasMore) {
        _currentPage++;
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendMessage(int groupId, String text) async {
    try {
      await _messageService.sendGroupMessage(groupId, text);
      await fetchMessages(groupId, isRefresh: true);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
