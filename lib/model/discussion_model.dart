import 'package:cloud_firestore/cloud_firestore.dart';

class DiscussionThread {
  final String id;
  final String title;
  final String category;
  final String author;
  final String authorId;
  final String avatar;
  final DateTime timestamp;
  final int upvotes;
  final int replies;
  final List<String> upvotedBy;
  final String content;
  final String? attachment;

  DiscussionThread({
    required this.id,
    required this.title,
    required this.category,
    required this.author,
    required this.authorId,
    required this.avatar,
    required this.timestamp,
    required this.upvotes,
    required this.replies,
    required this.upvotedBy,
    required this.content,
    this.attachment,
  });

  factory DiscussionThread.fromFirestore(DocumentSnapshot doc, String currentUserId) {
    final data = doc.data() as Map<String, dynamic>;
    return DiscussionThread(
      id: doc.id,
      title: data['title'] ?? '',
      category: data['category'] ?? 'General',
      author: data['author'] ?? 'Anonymous',
      authorId: data['authorId'] ?? '',
      avatar: data['avatar'] ?? 'A',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      upvotes: data['upvotes'] ?? 0,
      replies: data['replies'] ?? 0,
      upvotedBy: List<String>.from(data['upvotedBy'] ?? []),
      content: data['content'] ?? '',
      attachment: data['attachment'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'category': category,
      'author': author,
      'authorId': authorId,
      'avatar': avatar,
      'timestamp': Timestamp.fromDate(timestamp),
      'upvotes': upvotes,
      'replies': replies,
      'upvotedBy': upvotedBy,
      'content': content,
      'attachment': attachment,
    };
  }
}

class ThreadComment {
  final String id;
  final String author;
  final String authorId;
  final String avatar;
  final DateTime timestamp;
  final String content;
  final String? attachment;

  ThreadComment({
    required this.id,
    required this.author,
    required this.authorId,
    required this.avatar,
    required this.timestamp,
    required this.content,
    this.attachment,
  });

  factory ThreadComment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ThreadComment(
      id: doc.id,
      author: data['author'] ?? 'Anonymous',
      authorId: data['authorId'] ?? '',
      avatar: data['avatar'] ?? 'A',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      content: data['content'] ?? '',
      attachment: data['attachment'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'author': author,
      'authorId': authorId,
      'avatar': avatar,
      'timestamp': Timestamp.fromDate(timestamp),
      'content': content,
      'attachment': attachment,
    };
  }
}