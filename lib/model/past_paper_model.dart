import 'package:cloud_firestore/cloud_firestore.dart';

class PastPaper {
  final String id;
  final String department;
  final String subject;
  final String teacher;
  final String year;
  final String examType;
  final String pdfUrl;
  final String uploadedBy;
  final Timestamp createdAt;

  PastPaper({
    required this.id,
    required this.department,
    required this.subject,
    required this.teacher,
    required this.year,
    required this.examType,
    required this.pdfUrl,
    required this.uploadedBy,
    required this.createdAt,
  });

  factory PastPaper.fromMap(Map<String, dynamic> data, String id) {
    return PastPaper(
      id: id,
      department: data['department'] ?? '',
      subject: data['subject'] ?? '',
      teacher: data['teacher'] ?? '',
      year: data['year'] ?? '',
      examType: data['examType'] ?? '',
      pdfUrl: data['pdfUrl'] ?? '',
      uploadedBy: data['uploadedBy'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'department': department,
      'subject': subject,
      'teacher': teacher,
      'year': year,
      'examType': examType,
      'pdfUrl': pdfUrl,
      'uploadedBy': uploadedBy,
      'createdAt': createdAt,
    };
  }
}