import 'package:flutter/material.dart';

class StudyGroupsScreen extends StatefulWidget {
  const StudyGroupsScreen({super.key});

  @override
  State<StudyGroupsScreen> createState() => _StudyGroupsScreenState();
}

class _StudyGroupsScreenState extends State<StudyGroupsScreen> {
  String? _selectedDepartment;
  final Map<int, bool> _expandedFaqs = {};
  final TextEditingController _searchController = TextEditingController();

  // Dummy departments
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

  // Dummy study groups
  final List<Map<String, dynamic>> _studyGroups = [
    {
      'id': 1,
      'name': 'Data Structures Masters',
      'department': 'Computer Science',
      'subject': 'Data Structures',
      'members': 24,
      'active': '5 online',
      'image': 'https://img.freepik.com/free-vector/hand-drawn-data-structures-illustration_23-2149324218.jpg',
      'isJoined': false,
    },
    {
      'id': 2,
      'name': 'Algorithm Study Circle',
      'department': 'Computer Science',
      'subject': 'Algorithms',
      'members': 18,
      'active': '3 online',
      'image': 'https://miro.medium.com/v2/resize:fit:1400/1*J7lWGZ2oKpAKUJOYXdS-ow.png',
      'isJoined': true,
    },
    {
      'id': 3,
      'name': 'OOP Study Partners',
      'department': 'Software Engineering',
      'subject': 'Object Oriented Programming',
      'members': 12,
      'active': '2 online',
      'image': 'https://media.geeksforgeeks.org/wp-content/cdn-uploads/20190626123927/object-oriented-programming-concepts.jpg',
      'isJoined': false,
    },
    {
      'id': 4,
      'name': 'Database Study Group',
      'department': 'Computer Science',
      'subject': 'Database Systems',
      'members': 15,
      'active': '4 online',
      'image': 'https://www.boardinfinity.com/blog/content/images/2023/03/How-to-Learn-Data-Structures-and-Algorithms.png',
      'isJoined': false,
    },
    {
      'id': 5,
      'name': 'Calculus Study Team',
      'department': 'Mathematics',
      'subject': 'Calculus II',
      'members': 20,
      'active': '6 online',
      'image': 'https://www.simplilearn.com/ice9/free_resources_article_thumb/Data-Structures-and-Algorithms-Thumbnail.jpg',
      'isJoined': true,
    },
    {
      'id': 6,
      'name': 'Network Security Group',
      'department': 'Cyber Security',
      'subject': 'Network Security',
      'members': 14,
      'active': '3 online',
      'image': 'https://www.interview.io/wp-content/uploads/2022/12/software-design-interview-questions.png',
      'isJoined': false,
    },
  ];

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

  @override
  Widget build(BuildContext context) {
    // Filter groups by selected department
    final filteredGroups = _selectedDepartment == null || _selectedDepartment == 'All Departments'
        ? _studyGroups
        : _studyGroups.where((group) => group['department'] == _selectedDepartment).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blueAccent),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Study Groups",
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.blueAccent, size: 26),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            _buildHeroSection(),

            // Search and Filter
            _buildFilterSection(),

            // Featured Groups
            _buildFeaturedGroups(),

            // All Groups
            _buildGroupsList(filteredGroups),

            // FAQ Section
            _buildFaqSection(),

            // Footer
            _buildFooter(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle new group creation
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blueAccent.shade400,
            Colors.blueAccent.shade200,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 20,
            bottom: 20,
            child: Opacity(
              opacity: 0.1,
              child: Icon(Icons.group, size: 150, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Collaborative Learning",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Join subject-specific groups to study with peers",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.people_alt_outlined, color: Colors.white, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        "${_studyGroups.length} active groups",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
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
                fontSize: 15,
                fontWeight: FontWeight.w500,
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
                    label: Text(department),
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

  Widget _buildFeaturedGroups() {
    final featuredGroups = _studyGroups.where((group) => group['members'] > 15).toList();

    if (featuredGroups.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Featured Groups",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: featuredGroups.length,
              itemBuilder: (context, index) {
                final group = featuredGroups[index];
                return _buildFeaturedGroupCard(group);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedGroupCard(Map<String, dynamic> group) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 15),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            // Navigate to group detail
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Group Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  group['image'],
                  height: 90,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 90,
                    color: Colors.grey[200],
                    child: const Icon(Icons.group, color: Colors.grey),
                  ),
                ),
              ),
              // Group Info
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      group['subject'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.people_outline, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          "${group['members']} members",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
          // Navigate to group detail
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Group Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  group['image'],
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
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${group['department']} • ${group['subject']}",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
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
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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