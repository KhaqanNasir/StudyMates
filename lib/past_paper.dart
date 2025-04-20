import 'package:flutter/material.dart';

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
    "Computer Science": {
      "Data Structures": List.generate(8, (i) => _createPaper("Data Structures", 2023 - i)),
      "Object Oriented Programming": List.generate(7, (i) => _createPaper("OOP", 2023 - i)),
      "Algorithms": List.generate(6, (i) => _createPaper("Algorithms", 2023 - i)),
      "Database Systems": List.generate(5, (i) => _createPaper("Database", 2023 - i)),
      "Computer Networks": List.generate(6, (i) => _createPaper("Networks", 2023 - i)),
      "Operating Systems": List.generate(5, (i) => _createPaper("OS", 2023 - i)),
      "Artificial Intelligence": List.generate(5, (i) => _createPaper("AI", 2023 - i)),
    },
    "Software Engineering": {
      "Software Design": List.generate(6, (i) => _createPaper("Software Design", 2023 - i)),
      "Software Engineering": List.generate(7, (i) => _createPaper("SE Principles", 2023 - i)),
      "Requirements Engineering": List.generate(5, (i) => _createPaper("Requirements", 2023 - i)),
      "Software Testing": List.generate(5, (i) => _createPaper("Testing", 2023 - i)),
      "Software Architecture": List.generate(6, (i) => _createPaper("Architecture", 2023 - i)),
    },
    "Electrical Engineering": {
      "Circuit Theory": List.generate(6, (i) => _createPaper("Circuits", 2023 - i)),
      "Digital Logic Design": List.generate(7, (i) => _createPaper("DLD", 2023 - i)),
      "Signals & Systems": List.generate(5, (i) => _createPaper("Signals", 2023 - i)),
      "Power Systems": List.generate(5, (i) => _createPaper("Power", 2023 - i)),
    },
    "Mathematics": {
      "Calculus": List.generate(8, (i) => _createPaper("Calculus", 2023 - i)),
      "Linear Algebra": List.generate(7, (i) => _createPaper("Linear Alg", 2023 - i)),
      "Differential Equations": List.generate(6, (i) => _createPaper("Diff EQ", 2023 - i)),
      "Probability": List.generate(5, (i) => _createPaper("Probability", 2023 - i)),
    },
    "Physics": {
      "Classical Mechanics": List.generate(6, (i) => _createPaper("Mechanics", 2023 - i)),
      "Electromagnetism": List.generate(5, (i) => _createPaper("EM Theory", 2023 - i)),
      "Quantum Physics": List.generate(5, (i) => _createPaper("Quantum", 2023 - i)),
    },
    "Business Administration": {
      "Principles of Management": List.generate(6, (i) => _createPaper("Management", 2023 - i)),
      "Financial Accounting": List.generate(5, (i) => _createPaper("Accounting", 2023 - i)),
      "Marketing": List.generate(5, (i) => _createPaper("Marketing", 2023 - i)),
    },
    "Computer Engineering": {
      "Computer Architecture": List.generate(6, (i) => _createPaper("Comp Arch", 2023 - i)),
      "Embedded Systems": List.generate(5, (i) => _createPaper("Embedded", 2023 - i)),
      "VLSI Design": List.generate(5, (i) => _createPaper("VLSI", 2023 - i)),
    },
    "Cyber Security": {
      "Network Security": List.generate(6, (i) => _createPaper("Net Security", 2023 - i)),
      "Cryptography": List.generate(5, (i) => _createPaper("Crypto", 2023 - i)),
      "Ethical Hacking": List.generate(5, (i) => _createPaper("Hacking", 2023 - i)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blueAccent),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Past Papers Archive",
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.blueAccent),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Feature Introduction Section
            _buildFeaturesSection(),

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

            // FAQ Section
            _buildFaqSection(),

            // Footer
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Past Papers Collection",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 10),
          _buildFeatureItem(
              Icons.library_books,
              "Comprehensive Archive",
              "Access past papers from multiple years to help you prepare for exams."
          ),
          _buildFeatureItem(
              Icons.search,
              "Easy Navigation",
              "Filter by department and subject to quickly find what you need."
          ),
          _buildFeatureItem(
              Icons.download,
              "Instant Access",
              "Download papers with one click or view them directly in the app."
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueAccent, size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Department Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              hint: const Text("Select Department"),
              value: _selectedDepartment,
              items: _pastPapersData.keys.map((String department) {
                return DropdownMenuItem<String>(
                  value: department,
                  child: Text(department),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDepartment = newValue;
                  _selectedSubject = null;
                });
              },
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
            ),
          ),
          const SizedBox(height: 15),
          // Subject Dropdown (only shown when department is selected)
          if (_selectedDepartment != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text("Select Subject"),
                value: _selectedSubject,
                items: _pastPapersData[_selectedDepartment]!.keys
                    .map((String subject) {
                  return DropdownMenuItem<String>(
                    value: subject,
                    child: Text(subject),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSubject = newValue;
                  });
                },
                underline: const SizedBox(),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPapersList() {
    if (_selectedDepartment == null || _selectedSubject == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(Icons.school, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              "Please select a department and subject to view past papers",
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

    final papers = _pastPapersData[_selectedDepartment]![_selectedSubject]!;

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: papers.length,
      itemBuilder: (context, index) {
        final paper = papers[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              // Handle paper tap (e.g., open PDF viewer)
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Paper Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
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
                  const SizedBox(width: 12),
                  // Paper Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$_selectedSubject (${paper["year"]})",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "By ${paper["teacher"]}",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Action Buttons
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

  Widget _buildFaqSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Forum FAQs",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 15),
          ..._faqs.asMap().entries.map((entry) {
            final index = entry.key;
            final faq = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
              child: ExpansionTile(
                initiallyExpanded: _expandedFaqs[index] ?? false,
                onExpansionChanged: (expanded) {
                  setState(() {
                    _expandedFaqs[index] = expanded;
                  });
                },
                leading: Icon(
                  Icons.help_outline,
                  color: _expandedFaqs[index] ?? false
                      ? Colors.blueAccent
                      : Colors.grey,
                ),
                title: Text(
                  faq["question"]!,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: _expandedFaqs[index] ?? false
                        ? Colors.blueAccent
                        : Colors.grey[800],
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    child: Text(
                      faq["answer"]!,
                      style: TextStyle(
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
                tilePadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }


  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      margin: const EdgeInsets.only(top: 30),
      color: Colors.blueAccent.withOpacity(0.1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Study Mates",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.blueAccent,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "© 2025 COMSATS University Islamabad, Sahiwal Campus",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}