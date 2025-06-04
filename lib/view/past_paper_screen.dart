import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../model/past_paper_model.dart';
import '../view_model/past_paper_view_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:io' show File if (dart.library.html) 'dart:html';

class StyledButton extends StatelessWidget {
final String text;
final VoidCallback onPressed;
final bool isLoading;

const StyledButton({
super.key,
required this.text,
required this.onPressed,
this.isLoading = false,
});

@override
Widget build(BuildContext context) {
return Container(
decoration: BoxDecoration(
gradient: const LinearGradient(
colors: [Colors.blueAccent, Colors.lightBlue],
begin: Alignment.topLeft,
end: Alignment.bottomRight,
),
borderRadius: BorderRadius.circular(12),
boxShadow: [
BoxShadow(
color: Colors.blueAccent.withOpacity(0.3),
blurRadius: 8,
offset: const Offset(0, 4),
),
],
),
child: ElevatedButton(
onPressed: isLoading ? null : onPressed,
style: ElevatedButton.styleFrom(
backgroundColor: Colors.transparent,
shadowColor: Colors.transparent,
padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(12),
),
),
child: isLoading
? const SpinKitThreeBounce(color: Colors.white, size: 20)
    : Text(
text,
style: GoogleFonts.poppins(
fontSize: 16,
fontWeight: FontWeight.w600,
color: Colors.white,
),
),
),
);
}
}

class PastPapersScreen extends StatelessWidget {
const PastPapersScreen({super.key});

@override
Widget build(BuildContext context) {
return ChangeNotifierProvider(
create: (_) => PastPaperViewModel(),
child: const _PastPapersScreenContent(),
);
}
}

class _PastPapersScreenContent extends StatefulWidget {
const _PastPapersScreenContent();

@override
_PastPapersScreenContentState createState() => _PastPapersScreenContentState();
}

class _PastPapersScreenContentState extends State<_PastPapersScreenContent> {
String? _selectedDepartment;
String? _selectedSubject;
List<String> _subjects = [];

@override
Widget build(BuildContext context) {
final viewModel = Provider.of<PastPaperViewModel>(context);

return Scaffold(
backgroundColor: const Color(0xFFF5F7FA),
appBar: AppBar(
leading: IconButton(
icon: const Icon(Icons.arrow_back, color: Colors.white),
onPressed: () => Navigator.pop(context),
),
backgroundColor: Colors.blueAccent,
elevation: 0,
title: Text(
"Past Papers",
style: GoogleFonts.poppins(
fontSize: 20,
fontWeight: FontWeight.w600,
color: Colors.white,
),
),
),
body: SingleChildScrollView(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
_buildSelectionSection(context, viewModel),
Padding(
padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
child: StyledButton(
text: 'Add New Paper',
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (_) => ChangeNotifierProvider.value(
value: viewModel,
child: UploadPaperScreen(
selectedDepartment: _selectedDepartment,
selectedSubject: _selectedSubject,
),
),
),
);
},
),
),
if (_selectedDepartment != null && _selectedSubject != null)
Padding(
padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
child: Text(
"Access past papers for $_selectedSubject below:",
style: GoogleFonts.poppins(
fontSize: 16,
color: Colors.blueAccent,
fontWeight: FontWeight.w500,
),
),
),
_buildPapersList(context, viewModel),
],
),
),
);
}

Widget _buildSelectionSection(BuildContext context, PastPaperViewModel viewModel) {
return Padding(
padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
"🎯 Filter Papers",
style: GoogleFonts.poppins(
fontSize: 20,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 16),
_buildDropdown(
hint: "Select Department",
value: _selectedDepartment,
items: viewModel.departments,
onChanged: (val) async {
setState(() {
_selectedDepartment = val;
_selectedSubject = null;
_subjects = [];
});
if (val != null) {
_subjects = await viewModel.getSubjects(val);
setState(() {});
}
},
),
const SizedBox(height: 16),
if (_selectedDepartment != null)
_buildDropdown(
hint: "Select Subject",
value: _selectedSubject,
items: _subjects,
onChanged: (val) {
setState(() {
_selectedSubject = val;
});
if (val != null && _selectedDepartment != null) {
viewModel.fetchPapers(_selectedDepartment!, val);
}
},
),
],
),
);
}

Widget _buildDropdown({
required String hint,
required String? value,
required List<String> items,
required Function(String?) onChanged,
}) {
return Container(
padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
decoration: BoxDecoration(
color: Colors.white,
border: Border.all(color: Colors.grey[300]!, width: 1.5),
borderRadius: BorderRadius.circular(12),
boxShadow: [
BoxShadow(
color: Colors.grey.withOpacity(0.1),
blurRadius: 6,
offset: const Offset(0, 2),
),
],
),
child: DropdownButtonFormField<String>(
isExpanded: true,
hint: Text(hint, style: GoogleFonts.poppins(color: Colors.grey[600])),
value: value,
icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.blueAccent),
decoration: InputDecoration(
border: InputBorder.none,
contentPadding: const EdgeInsets.symmetric(vertical: 12),
),
onChanged: onChanged,
items: items.map((item) {
return DropdownMenuItem<String>(
value: item,
child: Text(item, style: GoogleFonts.poppins()),
);
}).toList(),
),
);
}

Widget _buildPapersList(BuildContext context, PastPaperViewModel viewModel) {
if (_selectedDepartment == null || _selectedSubject == null) {
return Container(
padding: const EdgeInsets.all(20),
margin: const EdgeInsets.symmetric(horizontal: 20),
decoration: BoxDecoration(
color: Colors.grey[100],
borderRadius: BorderRadius.circular(12),
boxShadow: [
BoxShadow(
color: Colors.grey.withOpacity(0.2),
blurRadius: 6,
offset: const Offset(0, 2),
),
],
),
child: Column(
children: [
Icon(Icons.school_outlined, size: 60, color: Colors.grey[300]),
const SizedBox(height: 16),
Text(
"Please select a department and subject to view available past papers.",
textAlign: TextAlign.center,
style: GoogleFonts.poppins(
fontSize: 15,
color: Colors.grey,
),
),
],
),
);
}

if (viewModel.isLoading) {
return const Center(
child: SpinKitFadingCircle(color: Colors.blueAccent, size: 50),
);
}

if (viewModel.error != null) {
return Padding(
padding: const EdgeInsets.all(20),
child: Text(
viewModel.error!,
style: GoogleFonts.poppins(color: Colors.red, fontSize: 16),
),
);
}

if (viewModel.papers.isEmpty) {
return Padding(
padding: const EdgeInsets.all(20),
child: Text(
"No papers available for this selection.",
style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey),
),
);
}

return ListView.builder(
physics: const NeverScrollableScrollPhysics(),
shrinkWrap: true,
padding: const EdgeInsets.symmetric(horizontal: 20),
itemCount: viewModel.papers.length,
itemBuilder: (context, index) {
final paper = viewModel.papers[index];
return Card(
elevation: 4,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(14),
),
margin: const EdgeInsets.only(bottom: 16),
child: Padding(
padding: const EdgeInsets.all(14),
child: Row(
children: [
ClipRRect(
borderRadius: BorderRadius.circular(10),
child: Image.network(
'https://cdn-icons-png.flaticon.com/512/337/337946.png',
width: 60,
height: 60,
fit: BoxFit.cover,
errorBuilder: (context, error, stackTrace) => Container(
width: 60,
height: 60,
color: Colors.grey[200],
child: const Icon(Icons.picture_as_pdf, color: Colors.red),
),
),
),
const SizedBox(width: 16),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
"${paper.subject} (${paper.year})",
style: GoogleFonts.poppins(
fontSize: 16,
fontWeight: FontWeight.w600,
),
),
const SizedBox(height: 4),
Text(
"By ${paper.teacher} - ${paper.examType}",
style: GoogleFonts.poppins(
fontSize: 13,
color: Colors.grey[600],
),
),
],
),
),
IconButton(
icon: const Icon(Icons.visibility, color: Colors.blueAccent),
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (_) => PDFViewerScreen(
pdfUrl: paper.pdfUrl,
title: "${paper.subject} (${paper.year})",
),
),
);
},
),
IconButton(
icon: const Icon(Icons.download, color: Colors.blueAccent),
onPressed: () {
viewModel.downloadPaper(
paper.pdfUrl,
"${paper.subject}_${paper.year}.pdf",
);
},
),
],
),
),
);
},
);
}
}

class UploadPaperScreen extends StatefulWidget {
final String? selectedDepartment;
final String? selectedSubject;

const UploadPaperScreen({
super.key,
this.selectedDepartment,
this.selectedSubject,
});

@override
_UploadPaperScreenState createState() => _UploadPaperScreenState();
}

class _UploadPaperScreenState extends State<UploadPaperScreen> {
final _formKey = GlobalKey<FormState>();
String? _selectedDepartment;
String? _selectedSubject;
String? _teacher;
String? _year;
String? _examType;
PlatformFile? _selectedFile;
bool _uploadFailed = false;

@override
void initState() {
super.initState();
_selectedDepartment = widget.selectedDepartment;
_selectedSubject = widget.selectedSubject;
}

@override
Widget build(BuildContext context) {
final viewModel = Provider.of<PastPaperViewModel>(context);

return Scaffold(
appBar: AppBar(
leading: IconButton(
icon: const Icon(Icons.close, color: Colors.white),
onPressed: () => Navigator.pop(context),
),
backgroundColor: Colors.blueAccent,
elevation: 0,
title: Text(
"Upload Past Paper",
style: GoogleFonts.poppins(
fontSize: 20,
fontWeight: FontWeight.w600,
color: Colors.white,
),
),
),
body: Padding(
padding: const EdgeInsets.all(20),
child: Form(
key: _formKey,
child: SingleChildScrollView(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
_buildDropdown(
hint: "Select Department",
value: _selectedDepartment,
items: viewModel.departments,
onChanged: (val) {
setState(() {
_selectedDepartment = val;
_selectedSubject = null;
_uploadFailed = false;
});
},
validator: (value) =>
value == null ? 'Please select a department' : null,
),
const SizedBox(height: 16),
_buildTextFormField(
label: "Subject",
onChanged: (val) {
_selectedSubject = val;
_uploadFailed = false;
},
validator: (value) =>
value!.isEmpty ? 'Please enter a subject' : null,
),
const SizedBox(height: 16),
_buildTextFormField(
label: "Teacher Name",
onChanged: (val) {
_teacher = val;
_uploadFailed = false;
},
validator: (value) =>
value!.isEmpty ? 'Please enter teacher name' : null,
),
const SizedBox(height: 16),
_buildTextFormField(
label: "Year",
keyboardType: TextInputType.number,
onChanged: (val) {
_year = val;
_uploadFailed = false;
},
validator: (value) =>
value!.isEmpty ? 'Please enter year' : null,
),
const SizedBox(height: 16),
_buildTextFormField(
label: "Exam Type (e.g., Midterm, Final)",
onChanged: (val) {
_examType = val;
_uploadFailed = false;
},
validator: (value) =>
value!.isEmpty ? 'Please enter exam type' : null,
),
const SizedBox(height: 16),
StyledButton(
text: _selectedFile == null
? 'Select PDF File'
    : _selectedFile!.name,
onPressed: () async {
final result = await FilePicker.platform.pickFiles(
type: FileType.custom,
allowedExtensions: ['pdf'],
withData: true,
);
if (result != null) {
setState(() {
_selectedFile = result.files.first;
_uploadFailed = false;
});
viewModel.showSuccessToast('PDF file selected: ${result.files.first.name}');
} else {
viewModel.showErrorToast('No file selected');
}
},
),
if (_selectedFile != null)
Padding(
padding: const EdgeInsets.only(top: 8),
child: Text(
'Selected: ${_selectedFile!.name}',
style: GoogleFonts.poppins(color: Colors.green, fontSize: 14),
),
),
const SizedBox(height: 16),
if (viewModel.isLoading)
Column(
children: [
LinearProgressIndicator(
value: viewModel.uploadProgress,
backgroundColor: Colors.grey[200],
color: Colors.blueAccent,
),
const SizedBox(height: 8),
Text(
'Uploading: ${(viewModel.uploadProgress * 100).toStringAsFixed(0)}%',
style: GoogleFonts.poppins(fontSize: 14),
),
],
),
if (_uploadFailed)
Padding(
padding: const EdgeInsets.only(top: 16),
child: Row(
children: [
Expanded(
child: Text(
'Upload failed, please check your internet and try again.',
style: GoogleFonts.poppins(color: Colors.red, fontSize: 14),
),
),
IconButton(
icon: const Icon(Icons.refresh, color: Colors.blueAccent),
onPressed: () {
setState(() {
_uploadFailed = false;
});
},
),
],
),
),
const SizedBox(height: 16),
StyledButton(
text: 'Upload Paper',
isLoading: viewModel.isLoading,
onPressed: () async {
if (_formKey.currentState!.validate() && _selectedFile != null) {
final success = await viewModel.uploadPaper(
department: _selectedDepartment!,
subject: _selectedSubject!,
teacher: _teacher!,
year: _year!,
examType: _examType!,
oneFile: _selectedFile!,
);
if (success && _selectedDepartment != null && _selectedSubject != null) {
await viewModel.fetchPapers(_selectedDepartment!, _selectedSubject!);
Navigator.pop(context);
} else {
setState(() {
_uploadFailed = true;
});
}
} else {
viewModel.showErrorToast('Please fill all fields and select a PDF');
}
},
),
],
),
),
),
),
);
}

Widget _buildTextFormField({
required String label,
required Function(String) onChanged,
TextInputType? keyboardType,
String? Function(String?)? validator,
}) {
return TextFormField(
decoration: InputDecoration(
labelText: label,
labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
filled: true,
fillColor: Colors.white,
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
),
contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
),
keyboardType: keyboardType,
onChanged: onChanged,
validator: validator,
style: GoogleFonts.poppins(),
);
}

Widget _buildDropdown({
required String hint,
required String? value,
required List<String> items,
required Function(String?) onChanged,
String? Function(String?)? validator,
}) {
return Container(
padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
decoration: BoxDecoration(
color: Colors.white,
border: Border.all(color: Colors.grey[300]!, width: 1.5),
borderRadius: BorderRadius.circular(12),
boxShadow: [
BoxShadow(
color: Colors.grey.withOpacity(0.1),
blurRadius: 6,
offset: const Offset(0, 2),
),
],
),
child: DropdownButtonFormField<String>(
isExpanded: true,
hint: Text(hint, style: GoogleFonts.poppins(color: Colors.grey[600])),
value: value,
icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.blueAccent),
decoration: InputDecoration(
border: InputBorder.none,
contentPadding: const EdgeInsets.symmetric(vertical: 12),
),
onChanged: onChanged,
validator: validator,
items: items.map((item) {
return DropdownMenuItem<String>(
value: item,
child: Text(item, style: GoogleFonts.poppins()),
);
}).toList(),
style: GoogleFonts.poppins(),
),
);
}
}

class PDFViewerScreen extends StatefulWidget {
final String pdfUrl;
final String title;

const PDFViewerScreen({super.key, required this.pdfUrl, this.title = ''});

@override
_PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
Uint8List? pdfData;
bool _isLoading = true;
String? _error;

@override
void initState() {
super.initState();
if (!kIsWeb) {
_loadData();
} else {
WidgetsBinding.instance.addPostFrameCallback((_) async {
await OpenFilex.open(widget.pdfUrl);
Provider.of<PastPaperViewModel>(context, listen: false)
    .showSuccessToast('Opening PDF in a new tab');
Navigator.pop(context);
});
}
}

Future<void> _loadData() async {
try {
final response = await http.get(Uri.parse(widget.pdfUrl));
if (response.statusCode == 200) {
setState(() {
pdfData = response.bodyBytes;
_isLoading = false;
});
Provider.of<PastPaperViewModel>(context, listen: false)
    .showSuccessToast('PDF loaded successfully');
} else {
setState(() {
_error = 'Failed to load PDF: ${response.statusCode}';
_isLoading = false;
});
Provider.of<PastPaperViewModel>(context, listen: false)
    .showErrorToast('Error loading PDF');
}
} catch (e) {
setState(() {
_error = 'Error loading PDF: $e';
_isLoading = false;
});
Provider.of<PastPaperViewModel>(context, listen: false)
    .showErrorToast('Error loading PDF');
}
}

@override
Widget build(BuildContext context) {
if (kIsWeb) {
return const Scaffold(
body: Center(child: SpinKitFadingCircle(color: Colors.blueAccent, size: 50)),
);
}

if (_isLoading) {
return const Scaffold(
body: Center(child: SpinKitFadingCircle(color: Colors.blueAccent, size: 50)),
);
}

if (_error != null) {
return Scaffold(
appBar: AppBar(
title: Text(
widget.title,
style: GoogleFonts.poppins(
fontSize: 20,
fontWeight: FontWeight.w600,
color: Colors.white,
),
),
backgroundColor: Colors.blueAccent,
leading: IconButton(
icon: const Icon(Icons.arrow_back, color: Colors.white),
onPressed: () => Navigator.pop(context),
),
),
body: Center(child: Text(_error!, style: GoogleFonts.poppins(color: Colors.red))),
);
}

return Scaffold(
appBar: AppBar(
title: Text(
widget.title,
style: GoogleFonts.poppins(
fontSize: 20,
fontWeight: FontWeight.w600,
color: Colors.white,
),
),
backgroundColor: Colors.blueAccent,
leading: IconButton(
icon: const Icon(Icons.arrow_back, color: Colors.white),
onPressed: () => Navigator.pop(context),
),
),
body: pdfData != null
? PDFView(
pdfData: pdfData,
enableSwipe: true,
swipeHorizontal: true,
autoSpacing: true,
pageFling: true,
onError: (error) {
Provider.of<PastPaperViewModel>(context, listen: false)
    .showErrorToast('Error loading PDF');
},
onPageError: (page, error) {
Provider.of<PastPaperViewModel>(context, listen: false)
    .showErrorToast('Error on page $page');
},
)
    : Center(child: Text('Failed to load PDF', style: GoogleFonts.poppins())),
);
}
}