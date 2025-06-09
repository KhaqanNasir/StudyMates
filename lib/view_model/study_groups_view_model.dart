import 'package:flutter/material.dart';
import '../model/study_group_model.dart';
import '../services/firestore_service.dart';

class StudyGroupsViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService;
  List<StudyGroup> _studyGroups = [];
  StudyGroup? _selectedGroup;
  String? _selectedDepartment;
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;

  StudyGroupsViewModel(this._firestoreService);

  List<StudyGroup> get studyGroups => _studyGroups;
  StudyGroup? get selectedGroup => _selectedGroup;
  String? get selectedDepartment => _selectedDepartment;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  FirestoreService get firestoreService => _firestoreService;

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _filterStudyGroups();
    notifyListeners();
  }

  void setSelectedDepartment(String? department) {
    _selectedDepartment = department;
    fetchStudyGroups();
  }

  Future<void> fetchStudyGroups() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();
      _errorMessage = null;

      final groups = await _firestoreService.getStudyGroups(_selectedDepartment);
      final uniqueGroups = <String, StudyGroup>{};
      for (var group in groups) {
        uniqueGroups[group.id] = group;
      }
      _studyGroups = uniqueGroups.values.toList();
      _filterStudyGroups();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _filterStudyGroups() {
    if (_searchQuery.isNotEmpty) {
      _studyGroups = _studyGroups.where((group) =>
      group.name.toLowerCase().contains(_searchQuery) ||
          group.subject.toLowerCase().contains(_searchQuery) ||
          group.department.toLowerCase().contains(_searchQuery)).toList();
    }
    notifyListeners();
  }

  Future<void> joinGroup(String groupId) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();
      _errorMessage = null;

      final currentUserName = await _getCurrentUserName();
      await _firestoreService.joinGroup(groupId);
      await fetchStudyGroups();
      final updatedGroup = _studyGroups.firstWhere((g) => g.id == groupId);
      if (!updatedGroup.participants.contains(currentUserName)) {
        updatedGroup.participants.add(currentUserName);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> leaveGroup(String groupId) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();
      _errorMessage = null;

      final currentUserName = await _getCurrentUserName();
      await _firestoreService.leaveGroup(groupId);
      await fetchStudyGroups();
      final updatedGroup = _studyGroups.firstWhere((g) => g.id == groupId, orElse: () => _selectedGroup!);
      updatedGroup.participants.remove(currentUserName);
      if (_selectedGroup?.id == groupId) {
        _selectedGroup = null;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> _getCurrentUserName() async {
    final userData = await _firestoreService.getCurrentUserData();
    return userData?['fullName'] ?? 'Unknown';
  }

  void selectGroup(StudyGroup group) {
    _selectedGroup = group;
    notifyListeners();
  }

  void clearSelectedGroup() {
    _selectedGroup = null;
    notifyListeners();
  }

  Future<void> sendMessage(String content, String senderName) async {
    if (_selectedGroup == null) {
      _errorMessage = 'No group selected';
      notifyListeners();
      return;
    }

    if (_isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();
      _errorMessage = null;

      await _firestoreService.sendMessage(_selectedGroup!.id, content, senderName);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateMessage(String messageId, String newContent) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();
      _errorMessage = null;

      await _firestoreService.updateMessage(messageId, newContent);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteMessage(String messageId) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();
      _errorMessage = null;

      await _firestoreService.deleteMessage(messageId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}