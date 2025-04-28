import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class StudyGroupsScreen extends StatefulWidget {
  const StudyGroupsScreen({super.key});

  @override
  State<StudyGroupsScreen> createState() => _StudyGroupsScreenState();
}

class _StudyGroupsScreenState extends State<StudyGroupsScreen> {
  String? _selectedDepartment;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  Map<String, dynamic>? _selectedGroup;
  bool _showChat = false;

  final Map<int, bool> _expandedFaqs = {};



// FAQ Data
final List<Map<String, String>> _faqs = [
  {
    "question": "How do I join a study group?",
    "answer": "Tap the 'Join Group' button on any group card to become a member."
  },
  {
    "question": "Can I create my own study group?",
    "answer": "Yes! Tap the '+' button in the bottom right corner to create a new group."
  },
  {
    "question": "What happens after I join a group?",
    "answer": "You'll get access to the group chat, shared materials, and meeting schedule."
  },
  {
    "question": "Are there rules for study groups?",
    "answer": "Yes, all groups must follow our academic integrity and respect guidelines."
  },
  {
    "question": "How do group meetings work?",
    "answer": "Each group sets its own meeting schedule, which can be in-person or virtual."
  },
];

  // Departments
  final List<String> _departments = [
    'All Departments',
    'Computer Science',
    'Software Engineering',
    'Electrical Engineering',
    'Computer Engineering',
    'Cyber Security',
    'Data Science',
    'Mathematics',
    'Physics',
    'Business Administration'
  ];

  // Study groups - one for each subject in each department
  final List<Map<String, dynamic>> _studyGroups = [
    // Computer Science
    {
      'id': 1,
      'name': 'Data Structures Masters',
      'department': 'Computer Science',
      'subject': 'Data Structures',
      'description': 'Master data structures concepts and implementations',
      'members': 24,
      'active': '5 online',
      'isJoined': false,
      'messages': [],
      'participants': ['Ali Hassan', 'Fatima Khan', 'Usman Malik', 'Ayesha Tariq']
    },
    {
      'id': 2,
      'name': 'Algorithm Study Circle',
      'department': 'Computer Science',
      'subject': 'Algorithms',
      'description': 'Exploring advanced algorithms and problem-solving techniques',
      'members': 18,
      'active': '3 online',
      'isJoined': false,
      'messages': [],
      'participants': ['Saad Ahmed', 'Zainab Ali', 'Omar Farooq', 'Maryam Nawaz']
    },
    {
      'id': 3,
      'name': 'Database Systems Hub',
      'department': 'Computer Science',
      'subject': 'Database Systems',
      'description': 'Learn SQL, database design and implementation',
      'members': 15,
      'active': '2 online',
      'isJoined': false,
      'messages': [],
      'participants': ['Bilal Khan', 'Sara Malik', 'Hassan Ali', 'Aisha Ahmed']
    },
    // Software Engineering
    {
      'id': 4,
      'name': 'OOP Study Partners',
      'department': 'Software Engineering',
      'subject': 'Object Oriented Programming',
      'description': 'Master OOP concepts and design patterns',
      'members': 22,
      'active': '4 online',
      'isJoined': false,
      'messages': [],
      'participants': ['Imran Khan', 'Nadia Hussain', 'Faisal Qureshi', 'Hina Pervaiz']
    },
    {
      'id': 5,
      'name': 'Software Design Group',
      'department': 'Software Engineering',
      'subject': 'Software Design',
      'description': 'Explore software architecture and design principles',
      'members': 19,
      'active': '3 online',
      'isJoined': false,
      'messages': [],
      'participants': ['Kamran Ahmed', 'Sana Javed', 'Tariq Jameel', 'Amna Baig']
    },
    // Electrical Engineering
    {
      'id': 6,
      'name': 'Circuit Analysis Team',
      'department': 'Electrical Engineering',
      'subject': 'Circuit Analysis',
      'description': 'Analyze complex electrical circuits and systems',
      'members': 17,
      'active': '2 online',
      'isJoined': false,
      'messages': [],
      'participants': ['Hamza Ali', 'Khadija Riaz', 'Adeel Khan', 'Rabia Malik']
    },
    {
      'id': 7,
      'name': 'Digital Logic Design',
      'department': 'Electrical Engineering',
      'subject': 'Digital Logic',
      'description': 'Master combinational and sequential logic design',
      'members': 14,
      'active': '2 online',
      'isJoined': false,
      'messages': [],
      'participants': ['Fahad Ahmed', 'Samina Khalid', 'Naveed Akram', 'Saima Shahid']
    },
    // Computer Engineering
    {
      'id': 8,
      'name': 'Computer Architecture Group',
      'department': 'Computer Engineering',
      'subject': 'Computer Architecture',
      'description': 'Understanding processor design and memory systems',
      'members': 16,
      'active': '3 online',
      'isJoined': false,
      'messages': [],
      'participants': ['Yasir Hussain', 'Madiha Khan', 'Umar Farooq', 'Sadia Ali']
    },
    {
      'id': 9,
      'name': 'Embedded Systems Club',
      'department': 'Computer Engineering',
      'subject': 'Embedded Systems',
      'description': 'Design and program embedded controllers and IoT devices',
      'members': 18,
      'active': '4 online',
      'isJoined': false,
      'messages': [],
      'participants': ['Asad Khan', 'Nadia Malik', 'Bilal Ahmed', 'Farah Siddiqui']
    },
    // Cyber Security
    {
      'id': 10,
      'name': 'Network Security Group',
      'department': 'Cyber Security',
      'subject': 'Network Security',
      'description': 'Learn network defense techniques and security protocols',
      'members': 21,
      'active': '5 online',
      'isJoined': false,
      'messages': [],
      'participants': ['Shoaib Akhtar', 'Ayesha Malik', 'Faizan Ahmed', 'Sana Mir']
    },
    {
      'id': 11,
      'name': 'Ethical Hacking Team',
      'department': 'Cyber Security',
      'subject': 'Ethical Hacking',
      'description': 'Explore penetration testing and vulnerability assessment',
      'members': 23,
      'active': '6 online',
      'isJoined': false,
      'messages': [],
      'participants': ['Ahmed Ali', 'Saira Khan', 'Kamran Akmal', 'Hira Mani']
    },
    // Data Science
    {
      'id': 12,
      'name': 'Machine Learning Circle',
      'department': 'Data Science',
      'subject': 'Machine Learning',
      'description': 'Master ML algorithms and deep learning techniques',
      'members': 25,
      'active': '4 online',
      'isJoined': false,
      'messages': [],
      'participants': ['Zubair Khan', 'Aisha Siddiqi', 'Imran Hashmi', 'Farah Khan']
    },
    {
      'id': 13,
      'name': 'Data Mining Group',
      'department': 'Data Science',
      'subject': 'Data Mining',
      'description': 'Techniques for extracting patterns from large datasets',
      'members': 17,
      'active': '3 online',
      'isJoined': false,
      'messages': [],
      'participants': ['Fawad Khan', 'Sadia Ahmed', 'Kashif Ali', 'Nadia Jamil']
    },
    // Mathematics
    {
      'id': 14,
      'name': 'Calculus Study Team',
      'department': 'Mathematics',
      'subject': 'Calculus',
      'description': 'Master differential and integral calculus',
      'members': 20,
      'active': '3 online',
      'isJoined': false,
      'messages': [],
      'participants': ['Hassan Malik', 'Amina Khan', 'Farhan Ahmed', 'Saima Ali']
    },
    {
      'id': 15,
      'name': 'Linear Algebra Group',
      'department': 'Mathematics',
      'subject': 'Linear Algebra',
      'description': 'Study vector spaces, matrices and linear transformations',
      'members': 16,
      'active': '2 online',
      'isJoined': false,
      'messages': [],
      'participants': ['Adnan Khan', 'Sana Ahmed', 'Kamran Ali', 'Faiza Malik']
    },
    // Physics
    {
      'id': 16,
      'name': 'Mechanics Study Circle',
      'department': 'Physics',
      'subject': 'Mechanics',
      'description': 'Understanding classical mechanics and kinematics',
      'members': 14,
      'active': '2 online',
      'isJoined': false,
      'messages': [],
      'participants': ['Ali Abbas', 'Sadia Malik', 'Usman Ali', 'Hina Khan']
    },
    {
      'id': 17,
      'name': 'Quantum Physics Group',
      'department': 'Physics',
      'subject': 'Quantum Physics',
      'description': 'Explore quantum mechanics and wave functions',
      'members': 18,
      'active': '3 online',
      'isJoined': false,
      'messages': [],
      'participants': ['Rizwan Ahmed', 'Nadia Ali', 'Faisal Khan', 'Amna Haider']
    },
    // Business Administration
    {
      'id': 18,
      'name': 'Marketing Strategies',
      'department': 'Business Administration',
      'subject': 'Marketing',
      'description': 'Exploring effective marketing strategies and campaigns',
      'members': 22,
      'active': '4 online',
      'isJoined': false,
      'messages': [],
      'participants': ['Saad Malik', 'Zara Ahmed', 'Omar Ali', 'Maria Khan']
    },
    {
      'id': 19,
      'name': 'Finance Study Hub',
      'department': 'Business Administration',
      'subject': 'Finance',
      'description': 'Learn financial management and investment strategies',
      'members': 19,
      'active': '3 online',
      'isJoined': false,
      'messages': [],
      'participants': ['Asif Ali', 'Sana Tariq', 'Nasir Khan', 'Ayesha Fahad']
    },
  ];

  // Filtered groups based on search and department
  List<Map<String, dynamic>> get filteredGroups {
    if (_searchController.text.isEmpty) {
      return _selectedDepartment == null || _selectedDepartment == 'All Departments'
          ? _studyGroups
          : _studyGroups.where((group) => group['department'] == _selectedDepartment).toList();
    } else {
      final query = _searchController.text.toLowerCase();
      return _studyGroups
          .where((group) =>
      ((_selectedDepartment == null || _selectedDepartment == 'All Departments' ||
          group['department'] == _selectedDepartment)) &&
          (group['name'].toLowerCase().contains(query) ||
              group['subject'].toLowerCase().contains(query) ||
              group['department'].toLowerCase().contains(query)))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (_showChat) {
              setState(() {
                _showChat = false;
                _selectedGroup = null;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: Text(
          _showChat ? _selectedGroup!['name'] : "Study Groups",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: _showChat
            ? [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              _showGroupInfo(_selectedGroup!);
            },
          ),
        ]
            : null,
      ),
      body: _showChat
          ? _buildChatInterface()
          : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Hero Section
_buildHeroSection(),

            _buildGroupFeatures(),

            // Search and Filter
            _buildFilterSection(),


            // All Groups
            _buildGroupsList(filteredGroups),

            // // FAQ Section
_buildFaqSection(),
//
// // Footer
_buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 25, 20, 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search study groups...",
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
              hintStyle: GoogleFonts.poppins(fontSize: 14),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(height: 15),

          // Department Filter
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Filter by department:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _departments.map((department) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      department,
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    selected: _selectedDepartment == department,
                    onSelected: (selected) {
                      setState(() {
                        _selectedDepartment = selected ? department : null;
                      });
                    },
                    selectedColor: Colors.blueAccent,
                    labelStyle: TextStyle(
                      color: _selectedDepartment == department ? Colors.white : Colors.black,
                    ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: _selectedDepartment == department
                            ? Colors.blueAccent
                            : Colors.grey[300]!,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildGroupsList(List<Map<String, dynamic>> groups) {
    if (groups.isEmpty) {
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
            Icon(Icons.group, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 15),
            Text(
              _selectedDepartment == null || _selectedDepartment == 'All Departments'
                  ? "No study groups available"
                  : "No groups found in the $_selectedDepartment department",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Poppins',
              ),
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
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              "All Study Groups",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return _buildGroupCard(group);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(Map<String, dynamic> group) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _viewGroupDetails(group);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Group Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'image/logo.png',
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey[200],
                    child: const Icon(Icons.group, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              // Group Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      group['description'],
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${group['department']} • ${group['subject']}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.people_outline, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          "${group['members']} members",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(width: 15),
                        const Icon(Icons.circle, size: 8, color: Colors.green),
                        const SizedBox(width: 4),
                        Text(
                          group['active'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Join Button
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      group['isJoined'] = !group['isJoined'];

                      // If joining, generate some sample messages
                      if (group['isJoined'] && (group['messages'] == null || group['messages'].isEmpty)) {
                        _generateSampleMessages(group);
                      }

                      // Open chat if joining
                      if (group['isJoined']) {
                        _openGroupChat(group);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: group['isJoined'] ? Colors.grey[200] : Colors.blueAccent,
                    foregroundColor: group['isJoined'] ? Colors.grey[800] : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: Text(
                    group['isJoined'] ? "Joined" : "Join",
                    style: const TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _viewGroupDetails(Map<String, dynamic> group) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          color: Colors.white,
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        Row(
        children: [
        ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          'image/logo.png',
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: 60,
            height: 60,
            color: Colors.grey[200],
            child: const Icon(Icons.group, color: Colors.grey),
          ),
        ),
      ),
      const SizedBox(width: 15),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              group['name'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              "${group['department']} • ${group['subject']}",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
      ],
    ),
    const SizedBox(height: 15),
    Text(
    "Description",
    style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.blueAccent,
    fontFamily: 'Poppins',
    ),
    ),
    const SizedBox(height: 5),
    Text(
    group['description'],
    style: TextStyle(
    fontSize: 14,
    color: Colors.grey[800],
    fontFamily: 'Poppins',
    ),
    ),
    const SizedBox(height: 15),
    Row(
    children: [
    Expanded(
    child: Column(
    children: [
    Text(
    "${group['members']}",
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.grey[800],
    fontFamily: 'Poppins',
    ),
    ),
    Text(
    "Members",
    style: TextStyle(
    fontSize: 14,
    color: Colors.grey[600],
    fontFamily: 'Poppins',
    ),
    ),
    ],
    ),
    ),
    Expanded(
    child: Column(
    children: [
    Text(
    group['active'].split(' ')[0],
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.green,
    fontFamily: 'Poppins',
    ),
    ),
    Text(
    "Online",
    style: TextStyle(
    fontSize: 14,
    color: Colors.grey[600],
    fontFamily: 'Poppins',
    ),
    ),
    ],
    ),
    ),
    ],
    ),
    const SizedBox(height: 30),
    Center(
    child: SizedBox(
    width: 200,
    child: ElevatedButton(
    onPressed: () {
    Navigator.pop(context);
    setState(() {
    if (!group['isJoined']) {
    group['isJoined'] = true;
    _generateSampleMessages(group);
    }
    _openGroupChat(group);
    });
    },
      style: ElevatedButton.styleFrom(
        backgroundColor: group['isJoined'] ? Colors.grey[200] : Colors.blueAccent,
        foregroundColor: group['isJoined'] ? Colors.grey[800] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(
        group['isJoined'] ? "Open Chat" : "Join Group",
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
      ),
    ),
    ),
    ),
              const SizedBox(height: 20),
            ],
        ),
      ),
    );
  }

  void _openGroupChat(Map<String, dynamic> group) {
    setState(() {
      _selectedGroup = group;
      _showChat = true;
    });
  }

  void _generateSampleMessages(Map<String, dynamic> group) {
    final List<String> participants = List<String>.from(group['participants']);

    // Add sample messages
    group['messages'] = [
      {
        'sender': participants[0],
        'message': 'Hello everyone! Welcome to the ${group['name']} group!',
        'time': DateTime.now().subtract(const Duration(days: 2, hours: 3)),
        'isRead': true,
      },
      {
        'sender': participants[1],
        'message': 'Thanks for creating this group. I\'m excited to learn together!',
        'time': DateTime.now().subtract(const Duration(days: 2, hours: 2, minutes: 45)),
        'isRead': true,
      },
      {
        'sender': participants[2],
        'message': 'Hi all! Looking forward to our study sessions.',
        'time': DateTime.now().subtract(const Duration(days: 2, hours: 2, minutes: 30)),
        'isRead': true,
      },
      {
        'sender': participants[0],
        'message': 'Let\'s schedule our first online meeting. How about Friday at 5 PM?',
        'time': DateTime.now().subtract(const Duration(days: 1, hours: 7)),
        'isRead': true,
      },
      {
        'sender': participants[3],
        'message': 'Friday works for me!',
        'time': DateTime.now().subtract(const Duration(days: 1, hours: 6, minutes: 30)),
        'isRead': true,
      },
      {
        'sender': participants[1],
        'message': 'Could we make it 6 PM instead? I have a class until 5:30.',
        'time': DateTime.now().subtract(const Duration(days: 1, hours: 6)),
        'isRead': true,
      },
      {
        'sender': participants[0],
        'message': 'Sure, 6 PM it is then!',
        'time': DateTime.now().subtract(const Duration(days: 1, hours: 5, minutes: 45)),
        'isRead': true,
      },
      {
        'sender': participants[2],
        'message': 'I\'ll prepare some notes on the recent topics we covered in class.',
        'time': DateTime.now().subtract(const Duration(hours: 12)),
        'isRead': true,
      },
      {
        'sender': participants[3],
        'message': 'Great! I\'ll bring my questions about the last assignment.',
        'time': DateTime.now().subtract(const Duration(hours: 6)),
        'isRead': true,
      },
    ];
  }

  Widget _buildChatInterface() {
    final messages = _selectedGroup!['messages'] ?? [];
    final currentUser = "You"; // Assuming the current user's name

    return Column(
      children: [
        // Messages
        Expanded(
          child: messages.isEmpty
              ? _buildEmptyChatState()
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            reverse: false,
            itemBuilder: (context, index) {
              final message = messages[index];
              final bool isSentByMe = message['sender'] == currentUser;

              return _buildMessageBubble(message, isSentByMe);
            },
          ),
        ),

        // Message Input
        _buildMessageInput(),
      ],
    );
  }

  // // ===== FAQ Section =====
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

// // ===== Footer =====
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





  Widget _buildGroupFeatures() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      margin: const EdgeInsets.only(top: 24, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.groups_rounded, color: Colors.indigo, size: 28),
              const SizedBox(width: 10),
              Text(
                "Why Join Study Groups?",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.indigo[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Column(
            children: [
              _buildGroupFeatureItem(
                Icons.forum_rounded,
                "Collaborative Discussions",
                "Engage in topic-wise group chats to clear doubts and learn with peers.",
                Colors.blueAccent,
              ),
              _buildGroupFeatureItem(
                Icons.attach_file_rounded,
                "File Sharing",
                "Easily share notes, assignments, and important material within the group.",
                Colors.deepPurpleAccent,
              ),
              _buildGroupFeatureItem(
                Icons.emoji_events_rounded,
                "Peer Learning",
                "Learn from high-performing students and share your own insights.",
                Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGroupFeatureItem(IconData icon, String title, String description, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
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
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
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
child: Icon(Icons.group, size: 220, color: Colors.white),
),
),
Padding(
padding: const EdgeInsets.all(25),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text(
"Join Study Groups",
style: GoogleFonts.poppins(
fontSize: 28,
fontWeight: FontWeight.w600,
color: Colors.white,
height: 1.3,
),
),
const SizedBox(height: 10),
Text(
"Collaborate with peers, share resources, and discuss subjects.",
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
const Icon(Icons.group_add, color: Colors.white, size: 20),
const SizedBox(width: 8),
Text(
"200+ active groups available",
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


  Widget _buildEmptyChatState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 20),
          Text(
            "No messages yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Be the first to start the conversation!",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, bool isSentByMe) {
    final time = message['time'] as DateTime;
    final formattedTime = "${time.hour}:${time.minute.toString().padLeft(2, '0')}";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isSentByMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: _getAvatarColor(message['sender']),
              child: Text(
                message['sender'][0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],

          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSentByMe ? Colors.blueAccent : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isSentByMe)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        message['sender'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: _getAvatarColor(message['sender']),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  Text(
                    message['message'],
                    style: TextStyle(
                      fontSize: 14,
                      color: isSentByMe ? Colors.white : Colors.black87,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      formattedTime,
                      style: TextStyle(
                        fontSize: 10,
                        color: isSentByMe ? Colors.white.withOpacity(0.7) : Colors.grey[500],
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (isSentByMe) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blueAccent,
              child: Text(
                "Y",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getAvatarColor(String name) {
    final colors = [
      Colors.redAccent,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pinkAccent,
    ];

    // Create a consistent color for each name
    final index = name.codeUnits.fold(0, (prev, current) => prev + current) % colors.length;
    return colors[index];
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file, color: Colors.grey),
            onPressed: () {
              _showAttachmentOptions();
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontFamily: 'Poppins',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              _sendMessage();
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final message = {
      'sender': 'You',
      'message': _messageController.text.trim(),
      'time': DateTime.now(),
      'isRead': false,
    };

    setState(() {
      if (_selectedGroup!['messages'] == null) {
        _selectedGroup!['messages'] = [];
      }
      _selectedGroup!['messages'].add(message);
      _messageController.clear();
    });
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Share attachment",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(Icons.photo, "Gallery", Colors.purple),
                _buildAttachmentOption(Icons.camera_alt, "Camera", Colors.pink),
                _buildAttachmentOption(Icons.insert_drive_file, "Document", Colors.blue),
                _buildAttachmentOption(Icons.location_on, "Location", Colors.green),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentOption(IconData icon, String label, Color color) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        // Implement the attachment functionality
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label attachment selected'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 25,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  void _showGroupInfo(Map<String, dynamic> group) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group Header
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'image/logo.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[200],
                      child: const Icon(Icons.group, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        "${group['department']} • ${group['subject']}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Description
            const Text(
              "Description",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              group['description'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 20),

            // Stats
            Row(
              children: [
                _buildStatCard("Members", "${group['members']}", Icons.people),
                const SizedBox(width: 10),
                _buildStatCard("Online", group['active'].split(' ')[0], Icons.circle, Colors.green),
              ],
            ),
            const SizedBox(height: 20),

            // Participants
            const Text(
              "Participants",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 10),

            // Participants List
            Expanded(
              child: ListView.builder(
                itemCount: group['participants'].length + 1, // +1 for the current user
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildParticipantTile("You", true);
                  } else {
                    return _buildParticipantTile(group['participants'][index - 1], false);
                  }
                },
              ),
            ),

            // Leave Group Button
            Center(
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    group['isJoined'] = false;
                    _showChat = false;
                    _selectedGroup = null;
                  });
                },
                icon: const Icon(Icons.exit_to_app, color: Colors.red),
                label: const Text(
                  "Leave Group",
                  style: TextStyle(
                    color: Colors.red,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, [Color? iconColor]) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? Colors.blueAccent,
              size: 24,
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantTile(String name, bool isCurrentUser) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isCurrentUser ? Colors.blueAccent : _getAvatarColor(name),
        child: Text(
          name[0].toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
      ),
      subtitle: Text(
        isCurrentUser ? "You" : "Member",
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
          fontFamily: 'Poppins',
        ),
      ),
      trailing: isCurrentUser
          ? const Chip(
        backgroundColor: Colors.blue,
        label: Text(
          "Admin",
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontFamily: 'Poppins',
          ),
        ),
      )
          : null,
    );
  }
}