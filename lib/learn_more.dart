import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LearnMorePage extends StatelessWidget {
  const LearnMorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Learn More",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Hero Image Section
            Container(
              margin: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Image.asset(
                        'image/about.jpg',
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.4),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Text(
                          "COMSATS Sahiwal Campus",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(1, 1),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Content Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildEnhancedCard(
                    title: "About COMSATS Sahiwal",
                    content: "COMSATS University Islamabad, Sahiwal Campus, established in 2006, is strategically located halfway between Lahore and Multan on COMSATS Road off G.T. Road, Sahiwal. Spanning 36 acres, the campus offers state-of-the-art facilities and a vibrant academic environment. With 214 faculty members, including 66 PhD holders, it offers 23 programs and has enrolled 3,675 students to date.",
                    icon: Icons.school,
                    gradientColors: [Colors.blue.shade50, Colors.blue.shade100],
                  ),

                  _buildEnhancedCard(
                    title: "About Study Mates",
                    content: "Study Mates is your academic companion, designed to assist COMSATS students in managing their studies effectively. From class schedules to resources, everything you need is just a tap away.",
                    icon: Icons.menu_book,
                    gradientColors: [Colors.green.shade50, Colors.green.shade100],
                  ),

                  _buildContactCard(),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedCard({
    required String title,
    required String content,
    required IconData icon,
    required List<Color> gradientColors,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: Colors.blueAccent,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black87,
              height: 1.6,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.contact_phone,
                  color: Colors.blueAccent,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Contact Information",
                style: GoogleFonts.poppins(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _contactRow(Icons.email_outlined, "Info@cuisahiwal.edu.pk"),
          const SizedBox(height: 16),
          _contactRow(Icons.phone_outlined, "+92-40-4305001-4305002"),
          const SizedBox(height: 16),
          _contactRow(Icons.phone_android_outlined, "+92-333-690-8100"),
          const SizedBox(height: 16),
          _contactRow(Icons.location_on_outlined, "COMSATS Road, Off G.T. Road, Sahiwal, Pakistan"),
        ],
      ),
    );
  }

  Widget _contactRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.blueAccent, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ),
      ],
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