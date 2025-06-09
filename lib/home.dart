import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<int, bool> _expandedFaqs = {};
  int _currentIndex = 0;
  final FirestoreService _firestoreService = FirestoreService();
  String _userName = "Loading..."; // Initial state while fetching
  late PageController _pageController;
  late Timer _timer;
  int _currentSlideIndex = 0; // Track current slide index

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
      "route": "/past-papers",
      "gradient": [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)], // Blue gradient
      "iconColor": const Color(0xFF1565C0),
      "shadowColor": const Color(0xFF2196F3)
    },
    {
      "icon": Icons.note,
      "title": "Study Materials",
      "desc": "Download lecture notes & slides anytime.",
      "route": "/study-materials",
      "gradient": [const Color(0xFFE8F5E8), const Color(0xFFC8E6C9)], // Green gradient
      "iconColor": const Color(0xFF2E7D32),
      "shadowColor": const Color(0xFF4CAF50)
    },
    {
      "icon": Icons.group,
      "title": "Study Groups",
      "desc": "Join and collaborate with classmates.",
      "route": "/study-groups",
      "gradient": [const Color(0xFFFFF3E0), const Color(0xFFFFE0B2)], // Orange gradient
      "iconColor": const Color(0xFFE65100),
      "shadowColor": const Color(0xFFFF9800)
    },
    {
      "icon": Icons.schedule,
      "title": "Planner",
      "desc": "Track assignments and exam dates.",
      "route": "/discussion",
      "gradient": [const Color(0xFFF3E5F5), const Color(0xFFE1BEE7)], // Purple gradient
      "iconColor": const Color(0xFF6A1B9A),
      "shadowColor": const Color(0xFF9C27B0)
    },
  ];

  final List<String> _universityImages = [
    'image/about.jpg',
    'image/about1.jpg',
    'image/about2.jpg',
    'image/about1.webp',
    'image/download.webp',
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _pageController = PageController(initialPage: 0);
    _startSlideshow();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<void> _fetchUserName() async {
    try {
      final userData = await _firestoreService.getCurrentUserData();
      if (userData != null && mounted) {
        setState(() {
          _userName = userData['fullName'] ?? "Guest";
        });
      } else {
        setState(() {
          _userName = "Guest";
        });
      }
    } catch (e) {
      print('Error fetching user name: $e');
      if (mounted) {
        setState(() {
          _userName = "Guest";
        });
      }
    }
  }

  void _startSlideshow() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted && _pageController.hasClients) {
        _currentSlideIndex = (_currentSlideIndex + 1) % _universityImages.length;
        _pageController.animateToPage(
          _currentSlideIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),
      drawer: _buildDrawer(context),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildWelcomeSection(context, _userName),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          Navigator.pushNamed(context, _features[index]['route']);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Past Papers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Materials',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Planner',
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      elevation: 3,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        "Study Mates",
        style: GoogleFonts.poppins(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ),
      ],
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Enhanced Header with user info
          Container(
            height: 250,
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Close button
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white, size: 18),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Profile section
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 32,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // User name
                    Text(
                      _userName,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Subtitle
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'COMSATS Student',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Menu items
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    // Features section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Features',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Feature items
                    ..._features.map((feature) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.transparent,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: feature['gradient'],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: feature['shadowColor'].withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              feature['icon'],
                              color: feature['iconColor'],
                              size: 22,
                            ),
                          ),
                          title: Text(
                            feature['title'],
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),

                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey[400],
                            size: 16,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, feature['route']);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    }).toList(),



                    const SizedBox(height: 15),

                    // Other section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Other',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Settings item
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.settings,
                            color: Colors.grey[700],
                            size: 22,
                          ),
                        ),
                        title: Text(
                          'Settings',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey[400],
                          size: 16,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/settings');
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    // Learn More item
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.blue[600],
                            size: 22,
                          ),
                        ),
                        title: Text(
                          'Learn More',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey[400],
                          size: 16,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/learn-more');
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Footer section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                top: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Column(
              children: [
                // Logout button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                    },
                    icon: const Icon(Icons.logout, size: 18),
                    label: Text(
                      'Sign Out',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[50],
                      foregroundColor: Colors.red[600],
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.red[200]!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // App version or info
                Text(
                  'Study Mates v1.0',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, String userName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: const BoxDecoration(
        color: Colors.blueAccent,
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
                    'Welcome,',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "Access past papers, study materials & join your relevant classmate groups.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1.5,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
        ],
      ),
    );
  }

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
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: f['gradient'],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: f['shadowColor'].withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Stack(
                children: [
// Background decorative icon
                  Positioned(
                    top: -10,
                    right: -10,
                    child: Icon(
                      f["icon"] as IconData,
                      size: 80,
                      color: Colors.blueGrey.withOpacity(0.15),
                    ),
                  ),
// Main content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
// Icon container
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: f['shadowColor'].withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            f["icon"] as IconData,
                            size: 26,
                            color: f['iconColor'],
                          ),
                        ),
                        const SizedBox(height: 12),
// Title
                        Text(
                          f["title"],
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: f['iconColor'],
                          ),
                        ),
                        const SizedBox(height: 4),
// Description
                        Expanded(
                          child: Text(
                            f["desc"],
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey[600],
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
// Subtle accent line
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            f['iconColor'].withOpacity(0.6),
                            f['iconColor'].withOpacity(0.2),
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
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

  Widget _buildComsatsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentSlideIndex = index;
                });
              },
              itemCount: _universityImages.length,
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage(_universityImages[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_universityImages.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentSlideIndex == index ? Colors.blueAccent : Colors.grey,
                ),
              );
            }),
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