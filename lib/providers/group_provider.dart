import 'package:chat_app/services/group_service.dart';
import 'package:flutter/material.dart';

class GroupProvider with ChangeNotifier {
  final GroupService _groupService = GroupService();

  List<Map<String, dynamic>> _groups = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMore = true;

  List<Map<String, dynamic>> get groups => _groups;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;

  Future<void> fetchGroups({bool isRefresh = false}) async {
    if ((_isLoading && !isRefresh) || (!isRefresh && !_hasMore)) return;

    _isLoading = true;
    if (isRefresh) {
      _currentPage = 1;
      _groups.clear();
      _hasMore = true;
    }
    _error = null;
    notifyListeners();

    try {
      final response = await _groupService.getGroups(page: _currentPage);
      final newGroups = List<Map<String, dynamic>>.from(response['data'] ?? []);

      _groups.addAll(newGroups);

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

  Future<bool> createGroup(String name, List<int> userIds) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _groupService.createGroup(name, userIds);
      // After creating, refresh the group list to see the new group
      await fetchGroups(isRefresh: true);
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
