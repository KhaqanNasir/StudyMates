import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../model/past_paper_model.dart';
import '../view_model/past_paper_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

// FAQ Data
final List<Map<String, String>> _faqs = [
{
"question": "How do I download a past paper?",
"answer": "Tap on the download icon next to any paper. The file will be saved to your device's downloads folder."
},
{
"question": "Can I view papers without downloading?",
"answer": "Yes! Tap on any paper to view it directly in our built-in PDF viewer."
},
{
"question": "Why can't I see papers for my department?",
"answer": "Make sure you've selected the correct department and subject from the dropdown menus."
},
{
"question": "How recent are these past papers?",
"answer": "We maintain papers from the last 5-8 years, depending on the subject."
},
{
"question": "Can I contribute past papers?",
"answer": "Yes! Contact your department coordinator to submit papers for inclusion."
},
];

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
// Define _expandedFaqs to track FAQ expansion state
final Map<int, bool> _expandedFaqs = {for (var i = 0; i < _faqs.length; i++) i: false};

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
  // Hero Section
  _buildHeroSection(),
// Features Section
_buildFeaturesSection(),

// Main Paper Section
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

// FAQ Section
_buildFaqSection(),

// Footer
_buildFooter(context),
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
final isOwner = paper.uploadedBy == FirebaseAuth.instance.currentUser?.uid;
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
Icon(Icons.description, size: 60, color: Colors.blueAccent),
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
"By ${paper.teacher} - ${paper.examType ?? 'N/A'}",
style: GoogleFonts.poppins(
fontSize: 13,
color: Colors.grey[600],
),
),
const SizedBox(height: 4),
Text(
paper.description,
style: GoogleFonts.poppins(
fontSize: 12,
color: Colors.grey[800],
),
maxLines: 2,
overflow: TextOverflow.ellipsis,
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
builder: (_) => PaperDetailScreen(paper: paper),
),
);
},
),
if (isOwner)
IconButton(
icon: const Icon(Icons.edit, color: Colors.blueAccent),
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (_) => ChangeNotifierProvider.value(
value: viewModel,
child: EditPaperScreen(paper: paper),
),
),
);
},
),
if (isOwner)
IconButton(
icon: const Icon(Icons.delete, color: Colors.red),
onPressed: () async {
final confirm = await showDialog<bool>(
context: context,
builder: (context) => AlertDialog(
title: Text('Delete Paper', style: GoogleFonts.poppins()),
content: Text(
'Are you sure you want to delete this paper?',
style: GoogleFonts.poppins(),
),
actions: [
TextButton(
onPressed: () => Navigator.pop(context, false),
child: Text('Cancel', style: GoogleFonts.poppins()),
),
TextButton(
onPressed: () => Navigator.pop(context, true),
child: Text('Delete', style: GoogleFonts.poppins(color: Colors.red)),
),
],
),
);
if (confirm == true) {
final success = await viewModel.deletePaper(paper.id);
if (success && _selectedDepartment != null && _selectedSubject != null) {
await viewModel.fetchPapers(_selectedDepartment!, _selectedSubject!);
}
}
},
),
],
),
),
);
},
);
}

Widget _buildFaqSection() {
return Padding(
padding: const EdgeInsets.symmetric(horizontal: 20),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
"Frequently Asked Questions",
style: GoogleFonts.poppins(
fontSize: 22,
fontWeight: FontWeight.bold,
color: Colors.blueAccent,
),
),
const SizedBox(height: 20),
..._faqs.asMap().entries.map((entry) {
final index = entry.key;
final faq = entry.value;
return Card(
elevation: 1,
margin: const EdgeInsets.only(bottom: 12),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(10),
),
child: ExpansionTile(
title: Text(
faq["question"]!,
style: GoogleFonts.poppins(
fontSize: 15,
fontWeight: FontWeight.w500,
color: _expandedFaqs[index]! ? Colors.blueAccent : Colors.black87,
),
),
leading: Icon(
Icons.help_outline,
color: _expandedFaqs[index]! ? Colors.blueAccent : Colors.grey,
),
children: [
Padding(
padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
child: Text(
faq["answer"]!,
style: GoogleFonts.poppins(
fontSize: 14,
color: Colors.grey[700],
height: 1.5,
),
),
),
],
initiallyExpanded: _expandedFaqs[index]!,
onExpansionChanged: (expanded) {
setState(() {
_expandedFaqs[index] = expanded;
});
},
),
);
}).toList(),
],
),
);
}

Widget _buildFeaturesSection() {
return Container(
padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
margin: const EdgeInsets.only(top: 24, bottom: 16),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(24),
boxShadow: [
BoxShadow(
color: Colors.blueAccent.withOpacity(0.08),
blurRadius: 20,
offset: const Offset(0, 8),
),
],
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
const Icon(Icons.description_outlined, color: Colors.blueAccent, size: 28),
const SizedBox(width: 10),
Text(
"Past Papers Collection",
style: GoogleFonts.poppins(
fontSize: 22,
fontWeight: FontWeight.w600,
color: Colors.blueAccent,
),
),
],
),
const SizedBox(height: 24),
_buildFeatureItem(
Icons.folder_copy_rounded,
"Comprehensive Archive",
"Explore a wide range of past papers categorized by year and subject.",
),
_buildFeatureItem(
Icons.tune_rounded,
"Smart Filtering",
"Easily filter papers by department, semester, or subject in just a few taps.",
),
_buildFeatureItem(
Icons.cloud_download_rounded,
"Quick Access",
"Instant view or download available for offline usage anytime.",
),
],
),
);
}

Widget _buildFeatureItem(IconData icon, String title, String description) {
return Container(
margin: const EdgeInsets.only(bottom: 20),
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: Colors.blueAccent.withOpacity(0.03),
borderRadius: BorderRadius.circular(16),
),
child: Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Container(
padding: const EdgeInsets.all(10),
decoration: BoxDecoration(
color: Colors.blueAccent.withOpacity(0.12),
shape: BoxShape.circle,
),
child: Icon(icon, size: 22, color: Colors.blueAccent),
),
const SizedBox(width: 16),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
title,
style: GoogleFonts.poppins(
fontSize: 16,
fontWeight: FontWeight.w600,
),
),
const SizedBox(height: 6),
Text(
description,
style: GoogleFonts.poppins(
fontSize: 14,
color: Colors.black.withOpacity(0.65),
height: 1.4,
),
),
],
),
),
],
),
);
}

  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.08),
      ),
      child: Column(
        children: [
          // Main footer content
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: [
                // App logo/title
                Column(
                  children: [
                    Icon(
                      Icons.school,
                      size: 40,
                      color: Colors.blueAccent,
                    ),
                    Text(
                      "Study Mates",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueAccent,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),

                // Copyright text
                Text(
                  "© 2025 COMSATS University Islamabad, Sahiwal Campus",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Developer credit section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.12),
              border: Border(
                top: BorderSide(
                  color: Colors.blueAccent.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Developed by ",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  "Muhammad Khaqan Nasir",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.favorite,
                  color: Colors.red.shade400,
                  size: 14,
                ),
              ],
            ),
          ),
        ],
      ),
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
String? _description;
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
validator: (value) => value == null ? 'Please select a department' : null,
),
const SizedBox(height: 16),
_buildTextFormField(
label: "Subject",
onChanged: (val) {
_selectedSubject = val;
_uploadFailed = false;
},
validator: (value) => value!.isEmpty ? 'Please enter a subject' : null,
),
const SizedBox(height: 16),
_buildTextFormField(
label: "Teacher Name",
onChanged: (val) {
_teacher = val;
_uploadFailed = false;
},
validator: (value) => value!.isEmpty ? 'Please enter teacher name' : null,
),
const SizedBox(height: 16),
_buildTextFormField(
label: "Year",
keyboardType: TextInputType.number,
onChanged: (val) {
_year = val;
_uploadFailed = false;
},
validator: (value) => value!.isEmpty ? 'Please enter year' : null,
),
const SizedBox(height: 16),
_buildTextFormField(
label: "Exam Type (e.g., Midterm, Final)",
onChanged: (val) {
_examType = val;
_uploadFailed = false;
},
validator: (value) => value!.isEmpty ? 'Please enter exam type' : null,
),
const SizedBox(height: 16),
_buildTextFormField(
label: "Description",
onChanged: (val) {
_description = val;
_uploadFailed = false;
},
validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
maxLines: 5,
),
const SizedBox(height: 16),
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
if (_formKey.currentState!.validate()) {
final success = await viewModel.uploadPaper(
department: _selectedDepartment!,
subject: _selectedSubject!,
teacher: _teacher!,
year: _year!,
examType: _examType!,
description: _description!,
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
viewModel.showErrorToast('Please fill all fields');
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
int maxLines = 1,
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
maxLines: maxLines,
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

class EditPaperScreen extends StatefulWidget {
final PastPaper paper;

const EditPaperScreen({super.key, required this.paper});

@override
_EditPaperScreenState createState() => _EditPaperScreenState();
}

class _EditPaperScreenState extends State<EditPaperScreen> {
final _formKey = GlobalKey<FormState>();
String? _selectedDepartment;
String? _selectedSubject;
String? _teacher;
String? _year;
String? _examType;
String? _description;

@override
void initState() {
super.initState();
_selectedDepartment = widget.paper.department;
_selectedSubject = widget.paper.subject;
_teacher = widget.paper.teacher;
_year = widget.paper.year;
_examType = widget.paper.examType;
_description = widget.paper.description;
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
"Edit Past Paper",
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
});
},
validator: (value) => value == null ? 'Please select a department' : null,
),
const SizedBox(height: 16),
_buildTextFormField(
label: "Subject",
initialValue: _selectedSubject,
onChanged: (val) {
_selectedSubject = val;
},
validator: (value) => value!.isEmpty ? 'Please enter a subject' : null,
),
const SizedBox(height: 16),
_buildTextFormField(
label: "Teacher Name",
initialValue: _teacher,
onChanged: (val) {
_teacher = val;
},
validator: (value) => value!.isEmpty ? 'Please enter teacher name' : null,
),
const SizedBox(height: 16),
_buildTextFormField(
label: "Year",
initialValue: _year,
keyboardType: TextInputType.number,
onChanged: (val) {
_year = val;
},
validator: (value) => value!.isEmpty ? 'Please enter year' : null,
),
const SizedBox(height: 16),
_buildTextFormField(
label: "Exam Type (e.g., Midterm, Final)",
initialValue: _examType,
onChanged: (val) {
_examType = val;
},
validator: (value) => value!.isEmpty ? 'Please enter exam type' : null,
),
const SizedBox(height: 16),
_buildTextFormField(
label: "Description",
initialValue: _description,
onChanged: (val) {
_description = val;
},
validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
maxLines: 5,
),
const SizedBox(height: 16),
StyledButton(
text: 'Update Paper',
isLoading: viewModel.isLoading,
onPressed: () async {
if (_formKey.currentState!.validate()) {
final success = await viewModel.updatePaper(
paperId: widget.paper.id,
department: _selectedDepartment!,
subject: _selectedSubject!,
teacher: _teacher!,
year: _year!,
examType: _examType!,
description: _description!,
);
if (success) {
Navigator.pop(context);
}
} else {
viewModel.showErrorToast('Please fill all fields');
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
String? initialValue,
required Function(String) onChanged,
TextInputType? keyboardType,
String? Function(String?)? validator,
int maxLines = 1,
}) {
return TextFormField(
initialValue: initialValue,
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
maxLines: maxLines,
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

class PaperDetailScreen extends StatelessWidget {
final PastPaper paper;

const PaperDetailScreen({super.key, required this.paper});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text(
"${paper.subject} (${paper.year})",
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
body: Padding(
padding: const EdgeInsets.all(20),
child: SingleChildScrollView(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
"Department: ${paper.department}",
style: GoogleFonts.poppins(
fontSize: 16,
fontWeight: FontWeight.w600,
),
),
const SizedBox(height: 8),
Text(
"Subject: ${paper.subject}",
style: GoogleFonts.poppins(fontSize: 14),
),
const SizedBox(height: 8),
Text(
"Teacher: ${paper.teacher}",
style: GoogleFonts.poppins(fontSize: 14),
),
const SizedBox(height: 8),
Text(
"Year: ${paper.year}",
style: GoogleFonts.poppins(fontSize: 14),
),
const SizedBox(height: 8),
Text(
"Exam Type: ${paper.examType ?? 'N/A'}",
style: GoogleFonts.poppins(fontSize: 14),
),
const SizedBox(height: 16),
Text(
"Description:",
style: GoogleFonts.poppins(
fontSize: 16,
fontWeight: FontWeight.w600,
),
),
const SizedBox(height: 8),
Text(
paper.description,
style: GoogleFonts.poppins(fontSize: 14),
),
],
),
),
),
);
}
}


Widget _buildHeroSection() {
  return Container(
    height: 240,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.blueAccent,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.blueAccent.withOpacity(0.25),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Stack(
      children: [
        Positioned(
          right: -30,
          bottom: -20,
          child: Opacity(
            opacity: 0.08,
            child: Icon(Icons.library_books, size: 220, color: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Access Past Papers",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Find solved papers, previous exams & department-wise archives.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.history_edu, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "100+ papers available",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}