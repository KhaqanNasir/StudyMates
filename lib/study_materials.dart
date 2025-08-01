import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudyMaterialsScreen extends StatefulWidget {
  const StudyMaterialsScreen({super.key});

  @override
  State<StudyMaterialsScreen> createState() => _StudyMaterialsScreenState();
}

class _StudyMaterialsScreenState extends State<StudyMaterialsScreen> {
  String? _selectedDepartment;
  String? _selectedSubject;
  final Map<int, bool> _expandedFaqs = {};
  String _selectedMaterialType = 'All';

  // Complete Dummy Data (10 departments, 10 subjects each, 5-8 materials each)
  final Map<String, Map<String, List<Map<String, dynamic>>>> _studyMaterialsData = {
    "Computer Science": {
      "Data Structures": _generateMaterials("Data Structures", 8),
      "Algorithms": _generateMaterials("Algorithms", 7),
      "Database Systems": _generateMaterials("Database Systems", 6),
      "Computer Networks": _generateMaterials("Computer Networks", 5),
      "Operating Systems": _generateMaterials("Operating Systems", 6),
      "Compiler Construction": _generateMaterials("Compiler Construction", 5),
      "Artificial Intelligence": _generateMaterials("AI", 7),
      "Machine Learning": _generateMaterials("Machine Learning", 6),
      "Computer Graphics": _generateMaterials("Computer Graphics", 5),
      "Software Engineering": _generateMaterials("Software Engineering", 6),
    },
    "Software Engineering": {
      "Software Design": _generateMaterials("Software Design", 7),
      "Software Architecture": _generateMaterials("Software Architecture", 6),
      "Software Testing": _generateMaterials("Software Testing", 5),
      "Software Project Management": _generateMaterials("Project Management", 6),
      "Requirements Engineering": _generateMaterials("Requirements Eng", 5),
      "Human Computer Interaction": _generateMaterials("HCI", 6),
      "Cloud Computing": _generateMaterials("Cloud Computing", 7),
      "DevOps": _generateMaterials("DevOps", 5),
      "Agile Methodologies": _generateMaterials("Agile", 6),
      "Software Quality Assurance": _generateMaterials("SQA", 5),
    },
    "Electrical Engineering": {
      "Circuit Theory": _generateMaterials("Circuit Theory", 6),
      "Digital Logic Design": _generateMaterials("DLD", 7),
      "Signals & Systems": _generateMaterials("Signals", 5),
      "Power Systems": _generateMaterials("Power Systems", 6),
      "Control Systems": _generateMaterials("Control Systems", 5),
      "Electromagnetic Theory": _generateMaterials("EM Theory", 6),
      "Microelectronics": _generateMaterials("Microelectronics", 5),
      "Communication Systems": _generateMaterials("Comm Systems", 7),
      "Renewable Energy": _generateMaterials("Renewable Energy", 6),
      "Embedded Systems": _generateMaterials("Embedded Systems", 5),
    },
    "Computer Engineering": {
      "Computer Architecture": _generateMaterials("Comp Arch", 7),
      "Microprocessors": _generateMaterials("Microprocessors", 6),
      "VLSI Design": _generateMaterials("VLSI", 5),
      "Digital Signal Processing": _generateMaterials("DSP", 6),
      "Computer Organization": _generateMaterials("Comp Org", 5),
      "FPGA Design": _generateMaterials("FPGA", 6),
      "IoT Systems": _generateMaterials("IoT", 7),
      "Robotics": _generateMaterials("Robotics", 5),
      "Real-Time Systems": _generateMaterials("Real-Time", 6),
      "Hardware Security": _generateMaterials("HW Security", 5),
    },
    "Cyber Security": {
      "Network Security": _generateMaterials("Net Security", 7),
      "Cryptography": _generateMaterials("Cryptography", 6),
      "Ethical Hacking": _generateMaterials("Ethical Hacking", 5),
      "Digital Forensics": _generateMaterials("Forensics", 6),
      "Security Protocols": _generateMaterials("Security Protocols", 5),
      "Malware Analysis": _generateMaterials("Malware", 7),
      "Cloud Security": _generateMaterials("Cloud Security", 6),
      "IoT Security": _generateMaterials("IoT Security", 5),
      "Blockchain Security": _generateMaterials("Blockchain Sec", 6),
      "Incident Response": _generateMaterials("Incident Response", 5),
    },
    "Data Science": {
      "Data Mining": _generateMaterials("Data Mining", 7),
      "Big Data Analytics": _generateMaterials("Big Data", 6),
      "Data Visualization": _generateMaterials("Data Viz", 5),
      "Statistical Modeling": _generateMaterials("Stats Models", 6),
      "Machine Learning": _generateMaterials("ML", 7),
      "Deep Learning": _generateMaterials("Deep Learning", 6),
      "Natural Language Processing": _generateMaterials("NLP", 5),
      "Time Series Analysis": _generateMaterials("Time Series", 6),
      "Data Warehousing": _generateMaterials("Data Warehouse", 5),
      "Business Intelligence": _generateMaterials("BI", 7),
    },
    "Mathematics": {
      "Calculus": _generateMaterials("Calculus", 8),
      "Linear Algebra": _generateMaterials("Linear Alg", 7),
      "Differential Equations": _generateMaterials("Diff EQ", 6),
      "Probability & Statistics": _generateMaterials("Probability", 7),
      "Discrete Mathematics": _generateMaterials("Discrete Math", 6),
      "Numerical Analysis": _generateMaterials("Numerical", 5),
      "Complex Analysis": _generateMaterials("Complex", 6),
      "Optimization": _generateMaterials("Optimization", 5),
      "Graph Theory": _generateMaterials("Graph Theory", 7),
      "Number Theory": _generateMaterials("Number Theory", 6),
    },
    "Physics": {
      "Classical Mechanics": _generateMaterials("Mechanics", 7),
      "Electromagnetism": _generateMaterials("EM Theory", 6),
      "Quantum Physics": _generateMaterials("Quantum", 5),
      "Thermodynamics": _generateMaterials("Thermo", 6),
      "Statistical Physics": _generateMaterials("Stat Physics", 5),
      "Solid State Physics": _generateMaterials("Solid State", 7),
      "Nuclear Physics": _generateMaterials("Nuclear", 6),
      "Particle Physics": _generateMaterials("Particle", 5),
      "Astrophysics": _generateMaterials("Astrophysics", 6),
      "Optics": _generateMaterials("Optics", 7),
    },
    "Business Administration": {
      "Principles of Management": _generateMaterials("Management", 7),
      "Financial Accounting": _generateMaterials("Accounting", 6),
      "Marketing Management": _generateMaterials("Marketing", 5),
      "Organizational Behavior": _generateMaterials("Org Behavior", 6),
      "Business Statistics": _generateMaterials("Business Stats", 5),
      "Financial Management": _generateMaterials("Finance", 7),
      "Human Resource Management": _generateMaterials("HRM", 6),
      "Operations Management": _generateMaterials("Operations", 5),
      "Business Ethics": _generateMaterials("Ethics", 6),
      "Strategic Management": _generateMaterials("Strategy", 7),
    },
    "Artificial Intelligence": {
      "Machine Learning": _generateMaterials("ML", 8),
      "Deep Learning": _generateMaterials("Deep Learning", 7),
      "Natural Language Processing": _generateMaterials("NLP", 6),
      "Computer Vision": _generateMaterials("CV", 7),
      "Reinforcement Learning": _generateMaterials("RL", 6),
      "AI Ethics": _generateMaterials("AI Ethics", 5),
      "Neural Networks": _generateMaterials("Neural Nets", 7),
      "Cognitive Computing": _generateMaterials("Cognitive", 6),
      "AI for Robotics": _generateMaterials("AI Robotics", 5),
      "Generative AI": _generateMaterials("Generative AI", 7),
    },
  };

  // Helper function to generate materials
  static List<Map<String, dynamic>> _generateMaterials(String subject, int count) {
    final teachers = [
      "Dr. Ali Khan",
      "Dr. Sara Ahmed",
      "Dr. Usman Malik",
      "Dr. Fatima Riaz",
      "Dr. Bilal Arshad",
      "Dr. Ayesha Siddiqa",
      "Dr. Omar Farooq",
      "Dr. Zainab Hussain"
    ];

    final types = [
      {"type": "PDF", "icon": Icons.picture_as_pdf, "color": Colors.red},
      {"type": "PPT", "icon": Icons.slideshow, "color": Colors.orange},
      {"type": "DOC", "icon": Icons.article, "color": Colors.blue},
    ];

    return List.generate(count, (index) {
      final type = types[index % types.length];
      return {
        "title": "$subject ${index % 3 == 0 ? 'Lecture Notes' : index % 3 == 1 ? 'Slides' : 'Reference'} ${2023 - index}",
        "type": type["type"],
        "teacher": teachers[index % teachers.length],
        "year": (2023 - index).toString(),
        "icon": type["icon"],
        "color": type["color"],
        "size": "${(2 + index % 4)}.${index % 10} MB"
      };
    });
  }

  // FAQ Data
  final List<Map<String, String>> _faqs = [
    {
      "question": "How do I download study materials?",
      "answer": "Tap the download icon on any material card. Files are saved in your device's Downloads folder."
    },
    {
      "question": "Can I view materials without downloading?",
      "answer": "Yes! Tap any material to preview it in our built-in viewer (supports PDF, PPT, and DOC)."
    },
    {
      "question": "Are these materials officially approved?",
      "answer": "All materials are verified by faculty before being uploaded to ensure accuracy."
    },
    {
      "question": "How often are new materials added?",
      "answer": "We update materials at the end of each semester with the latest lecture content."
    },
    {
      "question": "Can I request specific materials?",
      "answer": "Yes! Contact your department coordinator with material requests."
    },
    {
      "question": "Why can't I find materials for my course?",
      "answer": "Some newer courses may still be collecting materials. Check back later or contact support."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: Text(
          "Study Material",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            _buildHeroSection(),

            // Feature Introduction Section
            _buildStudyMaterialFeatures(),


            // Filter Section
            _buildFilterSection(),

            // Materials List
            _buildMaterialsList(),

            // FAQ Section
            _buildFaqSection(),

            // Footer
            _buildFooter(context),
          ],
        ),
      ),
    );
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
              child: Icon(Icons.school, size: 220, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Explore Study Materials",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Unlock curated notes, guides & past papers by department.",
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
                      const Icon(Icons.menu_book_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "${_countTotalMaterials()}+ resources available",
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


  Widget _buildStudyMaterialFeatures() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      margin: const EdgeInsets.only(top: 24, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.menu_book_rounded, color: Colors.indigo, size: 28),
              const SizedBox(width: 10),
              Text(
                "Why Use Study Materials?",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Column(
            children: [
              _buildStudyMaterialItem(
                Icons.sticky_note_2_rounded,
                "Curated Notes",
                "Get high-quality handwritten and typed notes selected by toppers and professors.",
                Colors.deepPurpleAccent,
              ),
              _buildStudyMaterialItem(
                Icons.lightbulb_outline_rounded,
                "Concept Guides",
                "Understand key concepts easily through simplified visual and text-based summaries.",
                Colors.teal,
              ),
              _buildStudyMaterialItem(
                Icons.insert_drive_file_outlined,
                "Organized PDFs",
                "Access material neatly organized by subject, topic, and difficulty level.",
                Colors.orangeAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudyMaterialItem(IconData icon, String title, String description, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: iconColor),
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
                    color: Colors.black.withOpacity(0.7),
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


  int _countTotalMaterials() {
    int count = 0;
    _studyMaterialsData.forEach((dept, subjects) {
      subjects.forEach((subject, materials) {
        count += materials.length;
      });
    });
    return count;
  }

  Widget _buildFilterSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 25, 20, 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "🎯 Filter Course Content",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),

          // Department Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              hint: const Text(
                "Select Department",
                style: TextStyle(fontFamily: 'Poppins', color: Colors.grey),
              ),
              value: _selectedDepartment ?? _studyMaterialsData.keys.first,
              items: _studyMaterialsData.keys.map((String department) {
                return DropdownMenuItem<String>(
                  value: department,
                  child: Text(
                    department,
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 15),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDepartment = newValue;
                  _selectedSubject = null;
                });
              },
              underline: const SizedBox(),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.blueAccent),
              dropdownColor: Colors.white,
            ),
          ),
          const SizedBox(height: 15),

          // Subject Dropdown
          if (_selectedDepartment != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text(
                  "Select Subject",
                  style: TextStyle(fontFamily: 'Poppins', color: Colors.grey),
                ),
                value: _selectedSubject ?? _studyMaterialsData[_selectedDepartment!]!.keys.first,
                items: _studyMaterialsData[_selectedDepartment!]!.keys.map((String subject) {
                  return DropdownMenuItem<String>(
                    value: subject,
                    child: Text(
                      subject,
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 15),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSubject = newValue;
                  });
                },
                underline: const SizedBox(),
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.blueAccent),
                dropdownColor: Colors.white,
              ),
            ),

          if (_selectedSubject != null) ...[
            const SizedBox(height: 20),
            const Text(
              "📁 Filter by File Type:",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildMaterialTypeChip('All', Icons.all_inclusive),
                  _buildMaterialTypeChip('PDF', Icons.picture_as_pdf),
                  _buildMaterialTypeChip('PPT', Icons.slideshow),
                  _buildMaterialTypeChip('DOC', Icons.article),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }


  Widget _buildMaterialTypeChip(String type, IconData icon) {
    final isSelected = _selectedMaterialType == type;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: isSelected ? Colors.white : Colors.blueAccent),
            const SizedBox(width: 6),
            Text(
              type,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: isSelected ? Colors.white : Colors.blueAccent,
              ),
            ),
          ],
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedMaterialType = selected ? type : 'All';
          });
        },
        selectedColor: Colors.blueAccent,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.blueAccent : Colors.grey[300]!,
          ),
        ),
      ),
    );
  }


  Widget _buildMaterialsList() {
    if (_selectedDepartment == null || _selectedSubject == null) {
      return Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(Icons.library_books, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 15),
            const Text(
              "Select a department and subject to browse study materials",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    var materials = _studyMaterialsData[_selectedDepartment]![_selectedSubject]!;

    // Filter by material type if not 'All'
    if (_selectedMaterialType != 'All') {
      materials = materials.where((material) =>
      material["type"] == _selectedMaterialType).toList();
    }

    if (materials.isEmpty) {
      return Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(Icons.library_books, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 15),
            Text(
              "No $_selectedMaterialType materials found for $_selectedSubject",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedMaterialType = 'All';
                });
              },
              child: const Text("Show all material types"),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_selectedDepartment != null && _selectedSubject != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                "Showing ${materials.length} ${_selectedMaterialType.toLowerCase()} resources for $_selectedSubject",
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
            ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: materials.length,
            itemBuilder: (context, index) {
              final material = materials[index];
              return _buildMaterialCard(material, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialCard(Map<String, dynamic> material, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200 + (index * 50)),
      curve: Curves.easeOut,
      margin: EdgeInsets.only(bottom: 15),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        elevation: 3,
        shadowColor: Colors.grey.withOpacity(0.15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: material["color"].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: material["color"].withOpacity(0.3), width: 1.5),
                  ),
                  child: Icon(
                    material["icon"],
                    color: material["color"],
                    size: 26,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        material["title"],
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: material["color"].withOpacity(0.1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              material["type"],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: material["color"],
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "• ${material["size"]} • ${material["teacher"]}",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // View & Download buttons
                IconButton(
                  icon: const Icon(Icons.visibility_outlined, color: Colors.green),
                  onPressed: () {
                    // You can open preview modal or page
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.download_outlined, color: Colors.blue),
                  onPressed: () {
                    // Trigger file download here
                  },
                ),
              ],
            ),
          ),
        ),
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