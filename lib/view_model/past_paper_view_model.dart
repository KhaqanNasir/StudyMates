import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import '../model/past_paper_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show SocketException;

class PastPaperViewModel extends ChangeNotifier {
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

List<PastPaper> _papers = [];
bool _isLoading = false;
String? _error;

List<PastPaper> get papers => _papers;
bool get isLoading => _isLoading;
String? get error => _error;

PastPaperViewModel();

final List<String> departments = [
'Bio Science',
'Computer Science',
'Mechanical Engineering',
'Management Science',
'Mathematics',
'Electrical Engineering',
'Civil Engineering',
];

void showSuccessToast(String message) {
Fluttertoast.showToast(
msg: message,
toastLength: Toast.LENGTH_LONG,
gravity: ToastGravity.BOTTOM,
backgroundColor: Colors.green,
textColor: Colors.white,
fontSize: 16.0,
);
}

void showErrorToast(String message) {
Fluttertoast.showToast(
msg: message,
toastLength: Toast.LENGTH_LONG,
gravity: ToastGravity.BOTTOM,
backgroundColor: Colors.red,
textColor: Colors.white,
fontSize: 16.0,
);
}

Future<List<String>> getSubjects(String department) async {
try {
_isLoading = true;
notifyListeners();
final snapshot = await _firestore
    .collection('past_papers')
    .where('department', isEqualTo: department)
    .get();
final subjects = snapshot.docs
    .map((doc) => doc.data()['subject'] as String)
    .toSet()
    .toList();
return subjects;
} catch (e) {
_error = 'Failed to fetch subjects: $e';
showErrorToast('Failed to fetch subjects');
notifyListeners();
return [];
} finally {
_isLoading = false;
notifyListeners();
}
}

Future<void> fetchPapers(String department, String subject) async {
  try {
    _isLoading = true;
    notifyListeners();

    final snapshot = await _firestore
        .collection('past_papers')
        .where('department', isEqualTo: department)
        .where('subject', isEqualTo: subject)
        .get();

    _papers = snapshot.docs
        .map((doc) => PastPaper.fromMap(doc.data(), doc.id))
        .toList();
    _error = null;
    showSuccessToast('Papers fetched successfully');
  } catch (e) {
    _error = 'Failed to fetch papers: $e';
    showErrorToast('Failed to fetch papers');
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

Future<bool> checkInternet() async {
try {
final connectivityResult = await Connectivity().checkConnectivity();
if (connectivityResult == ConnectivityResult.none) {
debugPrint('No network connectivity detected');
return false;
}
final response = await http
    .get(Uri.parse('https://api.ipify.org'))
    .timeout(const Duration(seconds: 5), onTimeout: () {
debugPrint('HTTP request timed out');
return http.Response('Timeout', 408);
});
return response.statusCode >= 200 && response.statusCode < 300;
} catch (e) {
debugPrint('Internet check failed: $e');
return true; // Assume internet is available if check fails
}
}

Future<bool> uploadPaper({
required String department,
required String subject,
required String teacher,
required String year,
required String examType,
required String description,
}) async {
const maxRetries = 2;
int attempt = 0;

while (attempt <= maxRetries) {
try {
debugPrint('Checking internet connectivity...');
final hasInternet = await checkInternet();
debugPrint('Internet check result: $hasInternet');
if (!hasInternet) {
showErrorToast('No internet connection detected. Please ensure you have a stable network.');
return false;
}

debugPrint('Current user: ${_auth.currentUser?.uid}');
if (_auth.currentUser == null) {
showErrorToast('Please log in to upload papers');
return false;
}

_isLoading = true;
notifyListeners();

final paperId = const Uuid().v4();
debugPrint('Uploading paper with ID: $paperId');

await _firestore.collection('past_papers').doc(paperId).set({
'department': department,
'subject': subject,
'teacher': teacher,
'year': year,
'examType': examType,
'description': description,
'uploadedBy': _auth.currentUser!.uid,
'createdAt': FieldValue.serverTimestamp(),
});

showSuccessToast('Paper uploaded successfully');
debugPrint('Paper uploaded successfully: $paperId');
return true;
} catch (e) {
debugPrint('Upload failed on attempt ${attempt + 1}: $e');
String errorMessage;
if (!kIsWeb && e is SocketException) {
errorMessage = 'Network error: Unable to connect to the server.';
} else if (e is FirebaseException) {
switch (e.code) {
case 'permission-denied':
errorMessage = 'Permission denied: You lack access to upload files.';
break;
case 'unauthenticated':
errorMessage = 'Authentication required: Please log in again.';
break;
default:
errorMessage = 'Firebase error: ${e.message}';
}
} else {
errorMessage = 'Upload failed: ${e.toString()}';
}
showErrorToast(errorMessage);
_error = 'Upload error: $e';
notifyListeners();

attempt++;
if (attempt > maxRetries) {
return false;
}
await Future.delayed(const Duration(seconds: 2));
} finally {
_isLoading = false;
notifyListeners();
}
}
return false;
}

Future<bool> updatePaper({
required String paperId,
required String department,
required String subject,
required String teacher,
required String year,
required String examType,
required String description,
}) async {
try {
if (_auth.currentUser == null) {
showErrorToast('Please log in to update papers');
return false;
}

_isLoading = true;
notifyListeners();

final doc = await _firestore.collection('past_papers').doc(paperId).get();
if (!doc.exists || doc.data()!['uploadedBy'] != _auth.currentUser!.uid) {
showErrorToast('You are not authorized to update this paper');
return false;
}

await _firestore.collection('past_papers').doc(paperId).update({
'department': department,
'subject': subject,
'teacher': teacher,
'year': year,
'examType': examType,
'description': description,
'updatedAt': FieldValue.serverTimestamp(),
});

showSuccessToast('Paper updated successfully');
return true;
} catch (e) {
debugPrint('Update failed: $e');
String errorMessage;
if (!kIsWeb && e is SocketException) {
errorMessage = 'Network error: Unable to connect to the server.';
} else if (e is FirebaseException) {
switch (e.code) {
case 'permission-denied':
errorMessage = 'Permission denied: You lack access to update files.';
break;
case 'unauthenticated':
errorMessage = 'Authentication required: Please log in again.';
break;
default:
errorMessage = 'Firebase error: ${e.message}';
}
} else {
errorMessage = 'Update failed: ${e.toString()}';
}
showErrorToast(errorMessage);
_error = 'Update error: $e';
notifyListeners();
return false;
} finally {
_isLoading = false;
notifyListeners();
}
}

Future<bool> deletePaper(String paperId) async {
try {
if (_auth.currentUser == null) {
showErrorToast('Please log in to delete papers');
return false;
}

_isLoading = true;
notifyListeners();

final doc = await _firestore.collection('past_papers').doc(paperId).get();
if (!doc.exists || doc.data()!['uploadedBy'] != _auth.currentUser!.uid) {
showErrorToast('You are not authorized to delete this paper');
return false;
}

await _firestore.collection('past_papers').doc(paperId).delete();

showSuccessToast('Paper deleted successfully');
return true;
} catch (e) {
debugPrint('Delete failed: $e');
String errorMessage;
if (!kIsWeb && e is SocketException) {
errorMessage = 'Network error: Unable to connect to the server.';
} else if (e is FirebaseException) {
switch (e.code) {
case 'permission-denied':
errorMessage = 'Permission denied: You lack access to delete files.';
break;
case 'unauthenticated':
errorMessage = 'Authentication required: Please log in again.';
break;
default:
errorMessage = 'Firebase error: ${e.message}';
}
} else {
errorMessage = 'Delete failed: ${e.toString()}';
}
showErrorToast(errorMessage);
_error = 'Delete error: $e';
notifyListeners();
return false;
} finally {
_isLoading = false;
notifyListeners();
}
}
}
