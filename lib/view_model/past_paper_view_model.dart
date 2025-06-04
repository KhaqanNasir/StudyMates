import 'package:flutter/material.dart';
import 'dart:io' show File, Platform, SocketException;
import 'dart:html' as html if (dart.library.html) 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import '../model/past_paper_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class PastPaperViewModel extends ChangeNotifier {
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseStorage _storage;
final FirebaseAuth _auth = FirebaseAuth.instance;

List<PastPaper> _papers = [];
bool _isLoading = false;
String? _error;
double _uploadProgress = 0.0;

List<PastPaper> get papers => _papers;
bool get isLoading => _isLoading;
String? get error => _error;
double get uploadProgress => _uploadProgress;

PastPaperViewModel() : _storage = FirebaseStorage.instance {
if (kIsWeb) {
try {
_storage.ref();
} catch (e) {
_error = 'Firebase Storage initialization failed: $e';
showErrorToast('Storage initialization failed');
notifyListeners();
}
}
}

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
    .orderBy('createdAt', descending: true)
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
return false;
}
// Ping Google's DNS to verify internet access
final response = await http
    .get(Uri.parse('https://8.8.8.8'))
    .timeout(const Duration(seconds: 5));
return response.statusCode == 200;
} catch (e) {
return false;
}
}

Future<bool> uploadPaper({
required String department,
required String subject,
required String teacher,
required String year,
required String examType,
required PlatformFile oneFile,
}) async {
const maxRetries = 2;
int attempt = 0;

while (attempt <= maxRetries) {
try {
// Check internet connectivity
if (!(await checkInternet())) {
showErrorToast('No internet connection, please check your network');
return false;
}

if (_auth.currentUser == null) {
showErrorToast('Please log in to upload papers');
return false;
}

_isLoading = true;
_uploadProgress = 0.0;
notifyListeners();

if (!oneFile.name.toLowerCase().endsWith('.pdf')) {
showErrorToast('Only PDF files are allowed');
return false;
}

final paperId = const Uuid().v4();
final storageRef = _storage
    .ref()
    .child('documents/${paperId}_${oneFile.name}');
UploadTask uploadTask = storageRef.putData(oneFile.bytes!);

// Set timeout for upload
uploadTask.timeout(const Duration(seconds: 30));

// Track progress
uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
_uploadProgress = (snapshot.bytesTransferred / snapshot.totalBytes);
notifyListeners();
});

debugPrint('Starting upload for ${oneFile.name}, attempt ${attempt + 1}');
final snapshot = await uploadTask;
if (snapshot.state != TaskState.success) {
showErrorToast('Upload failed, please try again');
return false;
}

debugPrint('Upload completed, getting download URL');
final pdfUrl = await storageRef.getDownloadURL();

debugPrint('Storing metadata in Firestore');
await _firestore.collection('past_papers').doc(paperId).set({
'department': department,
'subject': subject,
'teacher': teacher,
'year': year,
'examType': examType,
'pdfUrl': pdfUrl,
'uploadedBy': _auth.currentUser!.uid,
'createdAt': FieldValue.serverTimestamp(),
});

showSuccessToast('Paper uploaded successfully');
return true;
} catch (e) {
debugPrint('Upload failed: $e');
String errorMessage = 'Failed to upload paper, please try again';
if (e is SocketException) {
errorMessage = 'Connection lost, please check your internet';
} else if (e is FirebaseException) {
errorMessage = 'Firebase error: ${e.message}';
}
showErrorToast(errorMessage);
_error = 'Upload error: $e';
notifyListeners();

attempt++;
if (attempt > maxRetries) {
return false;
}
// Wait before retrying
await Future.delayed(const Duration(seconds: 2));
} finally {
_isLoading = false;
_uploadProgress = 0.0;
notifyListeners();
}
}
return false;
}

Future<void> downloadPaper(String pdfUrl, String fileName) async {
try {
final response = await http.get(Uri.parse(pdfUrl));
if (response.statusCode != 200) {
throw ('Failed to download status: ${response.statusCode}');
}
if (kIsWeb) {
final blob = html.Blob([response.bodyBytes], 'application/pdf');
final url = html.Url.createObjectUrlFromBlob(blob);
final anchor = html.AnchorElement(href: url)
..setAttribute('download', fileName)
..click();
html.Url.revokeObjectUrl(url);
showSuccessToast('PDF downloaded successfully');
} else {
final dir = await getTemporaryDirectory();
final filePath = '${dir.path}/$fileName';
final file = File(filePath);
await file.writeAsBytes(response.bodyBytes);
showSuccessToast('Downloaded to: $filePath');
}
} catch (e) {
showErrorToast('Failed to download paper');
notifyListeners();
}
}
}