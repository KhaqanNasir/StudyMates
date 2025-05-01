import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  final Map<int, bool> _expandedFaqs = {};

  final List<Map<String, String>> _faqs = [
    {
      "question": "How do I access past papers?",
      "answer": "Go to the Past Papers section and select your course."
    },
    {
      "question": "Can I upload my own notes?",
      "answer": "Yes! Go to Study Materials and click the upload button."
    },
    {
      "question": "Is this app only for COMSATS?",
      "answer": "Currently optimized for COMSATS Sahiwal students."
    },
    {
      "question": "How do I join a study group?",
      "answer": "Navigate to Study Groups and browse available groups."
    },
  ];

  final List<Map<String, dynamic>> _features = [
    {
      "icon": Icons.library_books,
      "title": "Past Papers",
      "desc": "Previous years' papers to help you prepare.",
      "route": "/past-papers"
    },
    {
      "icon": Icons.note,
      "title": "Study Materials",
      "desc": "Download lecture notes & slides anytime.",
      "route": "/study-materials"
    },
    {
      "icon": Icons.group,
      "title": "Study Groups",
      "desc": "Join and collaborate with classmates.",
      "route": "/study-groups"
    },
    {
      "icon": Icons.schedule,
      "title": "Planner",
      "desc": "Track assignments and exam dates.",
      "route": "/discussion"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),
      drawer: _buildDrawer(context),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildWelcomeSection(context),
            const SizedBox(height: 30),
            _buildKeyFeaturesTitle(),
            const SizedBox(height: 15),
            _buildFeaturesSection(),
            const SizedBox(height: 40),
            _buildComsatsSection(context),
            const SizedBox(height: 40),
            _buildFaqSection(),
            const SizedBox(height: 40),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  // ===== AppBar =====
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      elevation: 3,
      iconTheme: const IconThemeData(color: Colors.white), // ✅ Hamburger icon white
      title: Text(
        "Study Mates",
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 22,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_active, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  // ===== Drawer with Close Button =====
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blueAccent),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.school, size: 30, color: Colors.blueAccent),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    'Study Mates',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // ❌ Close button
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ),
          ..._features.map((feature) {
            return ListTile(
              leading: Icon(feature['icon'], color: Colors.blueAccent),
              title: Text(
                feature['title'],
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, feature['route']);
              },
            );
          }).toList(),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.blueAccent),
            title: Text(
              'Learn More',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/learn-more');
            },
          ),
        ],
      ),
    );
  }

  // ===== Welcome Section =====
  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: const BoxDecoration(
        color: Colors.blueAccent,
        // gradient: LinearGradient(
        //   colors: [Color(0xFF0062FF), Color(0xFF00A7FF)],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(Icons.school, size: 30, color: Colors.blueAccent),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome,",
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
                  ),
                  Text(
                    "COMSATS Student!",
                    style: GoogleFonts.poppins(
                        fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "Access past papers, study materials & join your relevant classmate groups.",
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white, height: 1.5),
          ),
        ],
      ),
    );
  }

  // ===== Key Features Title =====
  Widget _buildKeyFeaturesTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Key Features",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }

  // ===== Features Grid =====
  Widget _buildFeaturesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 15,
        runSpacing: 15,
        children: _features.map((f) {
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, f['route']),
            child: Container(
              width: MediaQuery.of(context).size.width / 2 - 30,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(f["icon"] as IconData, size: 40, color: Colors.blueAccent),
                  const SizedBox(height: 10),
                  Text(
                    f["title"],
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    f["desc"],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ===== About Section =====
  Widget _buildComsatsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset('image/about.jpg', height: 200, fit: BoxFit.cover),
          ),
          const SizedBox(height: 20),
          Text(
            "About COMSATS University",
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "COMSATS University Islamabad, Sahiwal Campus is known for its excellence in education and innovation. It offers top programs in engineering, CS, and business.",
            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 1.6,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/learn-more'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Learn More",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== FAQ Section =====
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
                    color: _expandedFaqs[index] ?? false ? Colors.blueAccent : Colors.black87,
                  ),
                ),
                leading: Icon(
                  Icons.help_outline,
                  color: _expandedFaqs[index] ?? false ? Colors.blueAccent : Colors.grey,
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
                  )
                ],
                initiallyExpanded: _expandedFaqs[index] ?? false,
                onExpansionChanged: (expanded) {
                  setState(() {
                    _expandedFaqs[index] = expanded;
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  // ===== Footer =====
  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      color: Colors.blueAccent.withOpacity(0.05),
      child: Column(
        children: [
          Text(
            "Study Mates",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "© 2025 COMSATS University Islamabad, Sahiwal Campus",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}