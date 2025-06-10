import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/discussion_model.dart';
import '../services/firestore_service.dart';

class DiscussionViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final StreamController<List<DiscussionThread>> _threadsController = StreamController<List<DiscussionThread>>.broadcast();
  Stream<List<DiscussionThread>> get threadsStream => _threadsController.stream;
  List<DiscussionThread> _threads = [];
  List<DiscussionThread> get threads => _threads;
  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;
  String _searchQuery = '';
  bool _showAddForm = false;
  bool get showAddForm => _showAddForm;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  String? _attachedFile;
  String? _attachedCommentFile;
  String? _selectedDepartment = 'Computer Science';
  final Map<String, bool> _expandedThreads = {};
  Map<String, bool> get expandedThreads => _expandedThreads;
  final Map<int, bool> _expandedFaqs = {};

  final List<String> departments = [
    'All',
    'Computer Science',
    'Software Engineering',
    'Electrical Engineering',
    'Civil Engineering',
    'Mechanical Engineering',
    'Business Administration',
    'Mathematics',
    'Food Sciences & Nutrition',
  ];

  final List<Map<String, String>> _faqs = [
    {
      "question": "How do I create a new discussion thread?",
      "answer": "Tap the '+' button to start a new discussion."
    },
    {
      "question": "Can I edit or delete my posts?",
      "answer": "Yes, tap the menu icon on your post to edit or delete."
    },
    {
      "question": "How do I report inappropriate content?",
      "answer": "Tap the flag icon to report to moderators."
    },
    {
      "question": "Are there rules for discussions?",
      "answer": "Keep discussions respectful and academic-focused."
    },
    {
      "question": "How do notifications work?",
      "answer": "You'll get notifications for replies and upvotes."
    },
  ];

  List<Map<String, String>> get faqs => _faqs;
  Map<int, bool> get expandedFaqs => _expandedFaqs;
  TextEditingController get searchController => _searchController;
  TextEditingController get titleController => _titleController;
  TextEditingController get contentController => _contentController;
  TextEditingController get commentController => _commentController;
  String? get attachedFile => _attachedFile;
  String? get attachedCommentFile => _attachedCommentFile;
  String? get selectedDepartment => _selectedDepartment;

  DiscussionViewModel() {
    _searchController.addListener(() {
      _searchQuery = _searchController.text;
      fetchThreadsStream();
    });
    fetchThreadsStream();
  }

  void fetchThreadsStream() {
    _firestoreService.getThreadsStream(_selectedCategory, _searchQuery).listen(
          (snapshot) {
        _threads = snapshot.map((doc) => DiscussionThread.fromFirestore(doc, _auth.currentUser!.uid)).toList();
        _threadsController.add(_threads);
        notifyListeners();
      },
      onError: (error) {
        _threadsController.addError(error);
        notifyListeners();
      },
    );
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    fetchThreadsStream();
    notifyListeners();
  }

  void toggleAddForm() {
    _showAddForm = !_showAddForm;
    notifyListeners();
  }

  void setSelectedDepartment(String? department) {
    _selectedDepartment = department;
    notifyListeners();
  }

  void toggleThreadExpansion(String threadId) {
    _expandedThreads[threadId] = !(_expandedThreads[threadId] ?? false);
    notifyListeners();
  }

  void toggleFaqExpansion(int index) {
    _expandedFaqs[index] = !(_expandedFaqs[index] ?? false);
    notifyListeners();
  }

  Future<void> addThread(BuildContext context) async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    try {
      final userData = await _firestoreService.getCurrentUserData();
      if (userData == null) throw Exception('User data not found');

      final newThread = DiscussionThread(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        category: _selectedCategory == 'All' ? _selectedDepartment ?? 'General' : _selectedCategory,
        author: userData['fullName'] ?? 'You',
        authorId: _auth.currentUser!.uid,
        avatar: userData['fullName']?[0] ?? 'Y',
        timestamp: DateTime.now(),
        upvotes: 0,
        replies: 0,
        upvotedBy: [],
        content: _contentController.text,
        attachment: _attachedFile,
      );

      await _firestoreService.addThread(newThread);
      _titleController.clear();
      _contentController.clear();
      _attachedFile = null;
      _selectedDepartment = 'Computer Science';
      _showAddForm = false;
      fetchThreadsStream();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post question: $e')),
      );
    }
  }

  Future<void> addComment(String threadId, BuildContext context) async {
    if (_commentController.text.trim().isEmpty) return;

    try {
      final userData = await _firestoreService.getCurrentUserData();
      if (userData == null) throw Exception('User data not found');

      final newComment = ThreadComment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        author: userData['fullName'] ?? 'You',
        authorId: _auth.currentUser!.uid,
        avatar: userData['fullName']?[0] ?? 'Y',
        timestamp: DateTime.now(),
        content: _commentController.text,
        attachment: _attachedCommentFile,
      );

      await _firestoreService.addComment(threadId, newComment);
      _commentController.clear();
      _attachedCommentFile = null;
      fetchThreadsStream();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post comment: $e')),
      );
    }
  }

  Future<void> toggleUpvote(String threadId) async {
    try {
      final userId = _auth.currentUser!.uid;
      await _firestoreService.toggleUpvote(threadId, userId);
      fetchThreadsStream();
    } catch (e) {
      print('Error toggling upvote: $e');
    }
  }

  void setAttachedFile(String? file) {
    _attachedFile = file;
    notifyListeners();
  }

  void setAttachedCommentFile(String? file) {
    _attachedCommentFile = file;
    notifyListeners();
  }

  @override
  void dispose() {
    _threadsController.close();
    _searchController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    _commentController.dispose();
    super.dispose();
  }
}