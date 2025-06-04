// // Hero Section
// _buildHeroSection(),
//
// // Feature Introduction Section
// _buildFeaturesSection(),
//
//
//
// // FAQ Section
// _buildFaqSection(),
//
// // Footer
// _buildFooter(context),
//
//
//
//
// Widget _buildHeroSection() {
// return Container(
// height: 240,
// width: double.infinity,
// decoration: BoxDecoration(
// color: Colors.blueAccent,
// borderRadius: const BorderRadius.only(
// bottomLeft: Radius.circular(30),
// bottomRight: Radius.circular(30),
// ),
// boxShadow: [
// BoxShadow(
// color: Colors.blueAccent.withOpacity(0.25),
// blurRadius: 20,
// offset: const Offset(0, 8),
// ),
// ],
// ),
// child: Stack(
// children: [
// Positioned(
// right: -30,
// bottom: -20,
// child: Opacity(
// opacity: 0.08,
// child: Icon(Icons.library_books, size: 220, color: Colors.white),
// ),
// ),
// Padding(
// padding: const EdgeInsets.all(25),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Text(
// "Access Past Papers",
// style: GoogleFonts.poppins(
// fontSize: 28,
// fontWeight: FontWeight.w600,
// color: Colors.white,
// height: 1.3,
// ),
// ),
// const SizedBox(height: 10),
// Text(
// "Find solved papers, previous exams & department-wise archives.",
// style: GoogleFonts.poppins(
// fontSize: 16,
// color: Colors.white.withOpacity(0.9),
// ),
// ),
// const SizedBox(height: 16),
// Container(
// padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
// decoration: BoxDecoration(
// color: Colors.white.withOpacity(0.18),
// borderRadius: BorderRadius.circular(25),
// border: Border.all(color: Colors.white.withOpacity(0.3)),
// ),
// child: Row(
// mainAxisSize: MainAxisSize.min,
// children: [
// const Icon(Icons.history_edu, color: Colors.white, size: 20),
// const SizedBox(width: 8),
// Text(
// "100+ papers available",
// style: GoogleFonts.poppins(
// fontSize: 14,
// color: Colors.white,
// fontWeight: FontWeight.w500,
// ),
// ),
// ],
// ),
// ),
// ],
// ),
// ),
// ],
// ),
// );
// }
//
// Widget _buildFeaturesSection() {
// return Container(
// padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
// margin: const EdgeInsets.only(top: 24, bottom: 16),
// decoration: BoxDecoration(
// color: Colors.white,
// borderRadius: BorderRadius.circular(24),
// boxShadow: [
// BoxShadow(
// color: Colors.blueAccent.withOpacity(0.08),
// blurRadius: 20,
// offset: const Offset(0, 8),
// ),
// ],
// ),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Row(
// children: [
// const Icon(Icons.description_outlined, color: Colors.blueAccent, size: 28),
// const SizedBox(width: 10),
// Text(
// "Past Papers Collection",
// style: GoogleFonts.poppins(
// fontSize: 22,
// fontWeight: FontWeight.w600,
// color: Colors.blueAccent,
// ),
// ),
// ],
// ),
// const SizedBox(height: 24),
// _buildFeatureItem(
// Icons.folder_copy_rounded,
// "Comprehensive Archive",
// "Explore a wide range of past papers categorized by year and subject.",
// ),
// _buildFeatureItem(
// Icons.tune_rounded,
// "Smart Filtering",
// "Easily filter papers by department, semester, or subject in just a few taps.",
// ),
// _buildFeatureItem(
// Icons.cloud_download_rounded,
// "Quick Access",
// "Instant view or download available for offline usage anytime.",
// ),
// ],
// ),
// );
// }
//
// Widget _buildFeatureItem(IconData icon, String title, String description) {
// return Container(
// margin: const EdgeInsets.only(bottom: 20),
// padding: const EdgeInsets.all(16),
// decoration: BoxDecoration(
// color: Colors.blueAccent.withOpacity(0.03),
// borderRadius: BorderRadius.circular(16),
// ),
// child: Row(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Container(
// padding: const EdgeInsets.all(10),
// decoration: BoxDecoration(
// color: Colors.blueAccent.withOpacity(0.12),
// shape: BoxShape.circle,
// ),
// child: Icon(icon, size: 22, color: Colors.blueAccent),
// ),
// const SizedBox(width: 16),
// Expanded(
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text(
// title,
// style: GoogleFonts.poppins(
// fontSize: 16,
// fontWeight: FontWeight.w600,
// ),
// ),
// const SizedBox(height: 6),
// Text(
// description,
// style: GoogleFonts.poppins(
// fontSize: 14,
// color: Colors.black.withOpacity(0.65),
// height: 1.4,
// ),
// ),
// ],
// ),
// ),
// ],
// ),
// );
// }
//
//
//
//
//
//
//
//
//
//
//
//
// // ===== FAQ Section =====
// Widget _buildFaqSection() {
// return Padding(
// padding: const EdgeInsets.symmetric(horizontal: 20),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text(
// "Frequently Asked Questions",
// style: GoogleFonts.poppins(
// fontSize: 22,
// fontWeight: FontWeight.bold,
// color: Colors.blueAccent,
// ),
// ),
// const SizedBox(height: 20),
// ..._faqs.asMap().entries.map((entry) {
// final index = entry.key;
// final faq = entry.value;
// return Card(
// elevation: 1,
// margin: const EdgeInsets.only(bottom: 12),
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(10),
// ),
// child: ExpansionTile(
// title: Text(
// faq["question"]!,
// style: GoogleFonts.poppins(
// fontSize: 15,
// fontWeight: FontWeight.w500,
// color: _expandedFaqs[index] ?? false ? Colors.blueAccent : Colors.black87,
// ),
// ),
// leading: Icon(
// Icons.help_outline,
// color: _expandedFaqs[index] ?? false ? Colors.blueAccent : Colors.grey,
// ),
// children: [
// Padding(
// padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
// child: Text(
// faq["answer"]!,
// style: GoogleFonts.poppins(
// fontSize: 14,
// color: Colors.grey[700],
// height: 1.5,
// ),
// ),
// )
// ],
// initiallyExpanded: _expandedFaqs[index] ?? false,
// onExpansionChanged: (expanded) {
// setState(() {
// _expandedFaqs[index] = expanded;
// });
// },
// ),
// );
// }),
// ],
// ),
// );
// }
//
// // ===== Footer =====
// Widget _buildFooter(BuildContext context) {
// return Container(
// width: double.infinity,
// padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
// color: Colors.blueAccent.withOpacity(0.05),
// child: Column(
// children: [
// Text(
// "Study Mates",
// style: GoogleFonts.poppins(
// fontSize: 20,
// fontWeight: FontWeight.w600,
// color: Colors.blueAccent,
// ),
// ),
// const SizedBox(height: 8),
// Text(
// "© 2025 COMSATS University Islamabad, Sahiwal Campus",
// textAlign: TextAlign.center,
// style: GoogleFonts.poppins(
// fontSize: 12,
// color: Colors.grey[600],
// ),
// ),
// ],
// ),
// );
// }
//
//
//
//
//











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