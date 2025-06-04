import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PastPapersScreen extends StatefulWidget {
  const PastPapersScreen({super.key});

  @override
  State<PastPapersScreen> createState() => _PastPapersScreenState();
}

class _PastPapersScreenState extends State<PastPapersScreen> {
  String? _selectedDepartment;
  String? _selectedSubject;
  final Map<int, bool> _expandedFaqs = {};

  // Expanded Dummy Data (8 departments, 6-8 subjects each, 5-8 papers each)
  final Map<String, Map<String, List<Map<String, String>>>> _pastPapersData = {
    "Bio Science": {
      "Data Structures": List.generate(8, (i) => _createPaper("Data Structures", 2023 - i)),
      "Object Oriented Programming": List.generate(7, (i) => _createPaper("OOP", 2023 - i)),
      "Algorithms": List.generate(6, (i) => _createPaper("Algorithms", 2023 - i)),
      "Database Systems": List.generate(5, (i) => _createPaper("Database", 2023 - i)),
      "Computer Networks": List.generate(6, (i) => _createPaper("Networks", 2023 - i)),
      "Operating Systems": List.generate(5, (i) => _createPaper("OS", 2023 - i)),
      "Artificial Intelligence": List.generate(5, (i) => _createPaper("AI", 2023 - i)),
    },
    "Computer Science": {
      "Software Design": List.generate(6, (i) => _createPaper("Software Design", 2023 - i)),
      "Software Engineering": List.generate(7, (i) => _createPaper("SE Principles", 2023 - i)),
      "Requirements Engineering": List.generate(5, (i) => _createPaper("Requirements", 2023 - i)),
      "Software Testing": List.generate(5, (i) => _createPaper("Testing", 2023 - i)),
      "Software Architecture": List.generate(6, (i) => _createPaper("Architecture", 2023 - i)),
    },
    "Mechanical Engineering": {
      "Circuit Theory": List.generate(6, (i) => _createPaper("Circuits", 2023 - i)),
      "Digital Logic Design": List.generate(7, (i) => _createPaper("DLD", 2023 - i)),
      "Signals & Systems": List.generate(5, (i) => _createPaper("Signals", 2023 - i)),
      "Power Systems": List.generate(5, (i) => _createPaper("Power", 2023 - i)),
    },
    "Management Science": {
      "Calculus": List.generate(8, (i) => _createPaper("Calculus", 2023 - i)),
      "Linear Algebra": List.generate(7, (i) => _createPaper("Linear Alg", 2023 - i)),
      "Differential Equations": List.generate(6, (i) => _createPaper("Diff EQ", 2023 - i)),
      "Probability": List.generate(5, (i) => _createPaper("Probability", 2023 - i)),
    },
    "Mathematics": {
      "Classical Mechanics": List.generate(6, (i) => _createPaper("Mechanics", 2023 - i)),
      "Electromagnetism": List.generate(5, (i) => _createPaper("EM Theory", 2023 - i)),
      "Quantum Physics": List.generate(5, (i) => _createPaper("Quantum", 2023 - i)),
    },
    "Electrical Engineering": {
      "Principles of Management": List.generate(6, (i) => _createPaper("Management", 2023 - i)),
      "Financial Accounting": List.generate(5, (i) => _createPaper("Accounting", 2023 - i)),
      "Marketing": List.generate(5, (i) => _createPaper("Marketing", 2023 - i)),
    },
    "Civil Engineering": {
      "Computer Architecture": List.generate(6, (i) => _createPaper("Comp Arch", 2023 - i)),
      "Embedded Systems": List.generate(5, (i) => _createPaper("Embedded", 2023 - i)),
      "VLSI Design": List.generate(5, (i) => _createPaper("VLSI", 2023 - i)),
    },
  };

  // Helper to create paper entries
  static Map<String, String> _createPaper(String subject, int year) {
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
    final subjectImages = {
      "Data Structures": "https://miro.medium.com/v2/resize:fit:1400/1*J7lWGZ2oKpAKUJOYXdS-ow.png",
      "OOP": "https://media.geeksforgeeks.org/wp-content/cdn-uploads/20190626123927/object-oriented-programming-concepts.jpg",
      // Add more subject-image mappings as needed
    };

    return {
      "teacher": teachers[year % teachers.length],
      "year": year.toString(),
      "image": subjectImages[subject] ?? "https://cdn-icons-png.flaticon.com/512/337/337946.png"
    };
  }



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



            // Department & Subject Selection
            _buildSelectionSection(),

            // Past Papers Access Guidance
            if (_selectedDepartment != null && _selectedSubject != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "Access past papers for $_selectedSubject below:",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),



            // Papers List
            _buildPapersList(),


          ],
        ),
      ),
    );
  }



  Widget _buildSelectionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "🎯 Filter Papers",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 16),

          // Department Dropdown
          _buildDropdown(
            hint: "Select Department",
            value: _selectedDepartment,
            items: _pastPapersData.keys.toList(),
            onChanged: (val) {
              setState(() {
                _selectedDepartment = val;
                _selectedSubject = null;
              });
            },
          ),

          const SizedBox(height: 16),

          // Subject Dropdown (only shown when department is selected)
          if (_selectedDepartment != null)
            _buildDropdown(
              hint: "Select Subject",
              value: _selectedSubject,
              items: _pastPapersData[_selectedDepartment]!.keys.toList(),
              onChanged: (val) {
                setState(() {
                  _selectedSubject = val;
                });
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        hint: Text(hint, style: const TextStyle(fontFamily: 'Poppins')),
        value: value,
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.blueAccent),
        underline: const SizedBox(),
        onChanged: onChanged,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: const TextStyle(fontFamily: 'Poppins')),
          );
        }).toList(),
      ),
    );
  }


  Widget _buildPapersList() {
    if (_selectedDepartment == null || _selectedSubject == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(Icons.school_outlined, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              "Please select a department and subject to view available past papers.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      );
    }

    final papers = _pastPapersData[_selectedDepartment]![_selectedSubject]!;

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: papers.length,
      itemBuilder: (context, index) {
        final paper = papers[index];
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              // Open preview
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      paper["image"]!,
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
                          "$_selectedSubject (${paper["year"]})",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "By ${paper["teacher"]}",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.visibility, color: Colors.blueAccent),
                    onPressed: () {
                      // Handle preview
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.download, color: Colors.blueAccent),
                    onPressed: () {
                      // Handle download
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }



}