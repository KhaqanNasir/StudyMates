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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: Text(
          "Learn More",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'image/about.jpg',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            _buildCard(
              title: "About COMSATS Sahiwal",
              content:
              "COMSATS University Islamabad, Sahiwal Campus, established in 2006, is strategically located halfway between Lahore and Multan on COMSATS Road off G.T. Road, Sahiwal. Spanning 36 acres, the campus offers state-of-the-art facilities and a vibrant academic environment. With 214 faculty members, including 66 PhD holders, it offers 23 programs and has enrolled 3,675 students to date.",
            ),
            _buildCard(
              title: "About Study Mates",
              content:
              "Study Mates is your academic companion, designed to assist COMSATS students in managing their studies effectively. From class schedules to resources, everything you need is just a tap away.",
            ),
            _buildContactCard(),
            const SizedBox(height: 20),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required String content}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Contact Information",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 10),
          _contactRow(Icons.email, "Info@cuisahiwal.edu.pk"),
          const SizedBox(height: 10),
          _contactRow(Icons.phone, "+92-40-4305001-4305002"),
          const SizedBox(height: 10),
          _contactRow(Icons.phone_android, "+92-333-690-8100"),
          const SizedBox(height: 10),
          _contactRow(Icons.location_on,
              "COMSATS Road, Off G.T. Road, Sahiwal, Pakistan"),
        ],
      ),
    );
  }

  Widget _contactRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blueAccent, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }


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