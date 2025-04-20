import 'package:flutter/material.dart';

class DiscussionScreen extends StatefulWidget {
  const DiscussionScreen({super.key});

  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  final Map<int, bool> _expandedFaqs = {};
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  // Dummy categories
  final List<String> _categories = [
    'All',
    'General',
    'Computer Science',
    'Software Engineering',
    'Electrical Engineering',
    'Mathematics',
    'Study Groups',
    'Q&A'
  ];

  // Dummy discussion threads
  final List<Map<String, dynamic>> _discussionThreads = [
    {
      'id': 1,
      'title': 'How to prepare for Data Structures final?',
      'category': 'Computer Science',
      'author': 'Ahmed Raza',
      'avatar': 'A',
      'timestamp': '2 hours ago',
      'upvotes': 15,
      'replies': 8,
      'isUpvoted': false,
      'content': 'I need advice on the most important topics to focus on for the DS final exam next week. Any suggestions?',
    },
    {
      'id': 2,
      'title': 'Best resources for learning Algorithms',
      'category': 'Computer Science',
      'author': 'Sara Khan',
      'avatar': 'S',
      'timestamp': '5 hours ago',
      'upvotes': 23,
      'replies': 12,
      'isUpvoted': true,
      'content': 'Sharing my curated list of books, videos and practice problems for Algorithms course.',
    },
    {
      'id': 3,
      'title': 'Forming study group for OOP',
      'category': 'Study Groups',
      'author': 'Bilal Ahmed',
      'avatar': 'B',
      'timestamp': '1 day ago',
      'upvotes': 7,
      'replies': 3,
      'isUpvoted': false,
      'content': 'Looking for 3-4 students to form a study group for Object Oriented Programming. We\'ll meet twice a week.',
    },
    {
      'id': 4,
      'title': 'Campus WiFi issues',
      'category': 'General',
      'author': 'Fatima Malik',
      'avatar': 'F',
      'timestamp': '1 day ago',
      'upvotes': 42,
      'replies': 15,
      'isUpvoted': false,
      'content': 'Is anyone else experiencing frequent disconnections from the campus WiFi?',
    },
    {
      'id': 5,
      'title': 'Calculus II midterm tips',
      'category': 'Mathematics',
      'author': 'Usman Ali',
      'avatar': 'U',
      'timestamp': '2 days ago',
      'upvotes': 18,
      'replies': 6,
      'isUpvoted': false,
      'content': 'What chapters should I focus on most for the upcoming Calculus II midterm?',
    },
    {
      'id': 6,
      'title': 'Internship opportunities for SE students',
      'category': 'Software Engineering',
      'author': 'Zainab Hussain',
      'avatar': 'Z',
      'timestamp': '3 days ago',
      'upvotes': 31,
      'replies': 14,
      'isUpvoted': false,
      'content': 'Compiling a list of companies offering internships for Software Engineering students this summer.',
    },
  ];

  // FAQ Data
  final List<Map<String, String>> _faqs = [
    {
      "question": "How do I create a new discussion thread?",
      "answer": "Tap the '+' button in the bottom right corner to start a new discussion."
    },
    {
      "question": "Can I edit or delete my posts?",
      "answer": "Yes, you can edit or delete your own posts by tapping the menu icon on your post."
    },
    {
      "question": "How do I report inappropriate content?",
      "answer": "Tap the flag icon on any post to report it to moderators."
    },
    {
      "question": "Are there rules for discussions?",
      "answer": "Yes, please keep discussions respectful and academic-focused. See our Community Guidelines."
    },
    {
      "question": "How do notifications work?",
      "answer": "You'll get notifications when someone replies to your posts or upvotes your content."
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Filter threads by selected category
    final filteredThreads = _selectedCategory == 'All'
        ? _discussionThreads
        : _discussionThreads.where((thread) => thread['category'] == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blueAccent),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Discussion Forum",
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
            icon: const Icon(Icons.notifications_outlined, color: Colors.blueAccent, size: 26),
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

            // Search and Categories
            _buildFilterSection(),

            // Discussion Threads
            _buildThreadsList(filteredThreads),

            // FAQ Section
            _buildFaqSection(),

            // Footer
            _buildFooter(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle new thread creation
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 180,
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
              child: Icon(Icons.forum, size: 150, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Academic Discussions",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Ask questions, share knowledge, and collaborate with peers",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
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
              hintText: "Search discussions...",
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

          // Categories
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Categories:",
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
              children: _categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: _selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category : 'All';
                      });
                    },
                    selectedColor: Colors.blueAccent,
                    labelStyle: TextStyle(
                      color: _selectedCategory == category ? Colors.white : Colors.black,
                    ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: _selectedCategory == category
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

  Widget _buildThreadsList(List<Map<String, dynamic>> threads) {
    if (threads.isEmpty) {
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
            Icon(Icons.forum_outlined, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 15),
            Text(
              "No discussions found in the $_selectedCategory category",
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
                  _selectedCategory = 'All';
                });
              },
              child: const Text("Show all discussions"),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Column(
        children: [
          ...threads.map((thread) {
            return _buildThreadCard(thread);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildThreadCard(Map<String, dynamic> thread) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to thread detail
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thread header
              Row(
                children: [
                  // Author avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        thread['avatar'],
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Author and timestamp
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          thread['author'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          thread['timestamp'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      thread['category'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Thread title
              Text(
                thread['title'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              // Thread content preview
              Text(
                thread['content'],
                style: TextStyle(
                  color: Colors.grey[700],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 15),
              // Thread footer (upvotes, replies)
              Row(
                children: [
                  // Upvote button
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      setState(() {
                        thread['isUpvoted'] = !thread['isUpvoted'];
                        thread['upvotes'] += thread['isUpvoted'] ? 1 : -1;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: thread['isUpvoted']
                            ? Colors.blueAccent.withOpacity(0.2)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_upward,
                            size: 18,
                            color: thread['isUpvoted']
                                ? Colors.blueAccent
                                : Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            thread['upvotes'].toString(),
                            style: TextStyle(
                              color: thread['isUpvoted']
                                  ? Colors.blueAccent
                                  : Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Replies
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.comment_outlined,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${thread['replies']} ${thread['replies'] == 1 ? 'reply' : 'replies'}",
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Share button
                  IconButton(
                    icon: const Icon(Icons.share_outlined, size: 20),
                    color: Colors.grey,
                    onPressed: () {
                      // Handle share
                    },
                  ),
                ],
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