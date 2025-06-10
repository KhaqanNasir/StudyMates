import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DiscussionScreen extends StatefulWidget {
  const DiscussionScreen({super.key});

  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  final Map<int, bool> _expandedThreads = {};
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  bool _showAddForm = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  List<Map<String, dynamic>> _threads = [];
  String? _attachedFile;
  String? _attachedCommentFile;
  final ScrollController _scrollController = ScrollController();
  final Map<int, bool> _expandedFaqs = {};
  // Categories
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

  // Sample initial threads
  List<Map<String, dynamic>> _discussionThreads = [
    {
      'id': 1,
      'title': 'How to prepare for Data Structures final?',
      'category': 'Computer Science',
      'author': 'Ahmed Raza',
      'avatar': 'A',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'upvotes': 15,
      'replies': 3,
      'isUpvoted': false,
      'content': 'I need advice on the most important topics to focus on for the DS final exam next week. Any suggestions?',
      'comments': [
        {
          'author': 'Sara Khan',
          'avatar': 'S',
          'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
          'content': 'Focus on trees and graphs - they usually cover about 40% of the exam!',
          'attachment': null,
        },
        {
          'author': 'Bilal Ahmed',
          'avatar': 'B',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 45)),
          'content': 'Don\'t forget to practice recursion problems! 😊',
          'attachment': 'recursion_guide.pdf',
        },
        {
          'author': 'Fatima Malik',
          'avatar': 'F',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 20)),
          'content': 'I have some notes from last year. Check the attached file!',
          'attachment': 'ds_notes.pdf',
        },
      ],
      'attachment': null,
    },
    {
      'id': 2,
      'title': 'Best resources for learning Algorithms',
      'category': 'Computer Science',
      'author': 'Sara Khan',
      'avatar': 'S',
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'upvotes': 23,
      'replies': 2,
      'isUpvoted': true,
      'content': 'Sharing my curated list of books, videos and practice problems for Algorithms course.',
      'comments': [
        {
          'author': 'Usman Ali',
          'avatar': 'U',
          'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
          'content': 'Thanks for sharing! The MIT lectures are especially helpful.',
          'attachment': null,
        },
        {
          'author': 'Zainab Hussain',
          'avatar': 'Z',
          'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
          'content': 'I would add "Algorithm Design Manual" by Skiena to this list.',
          'attachment': null,
        },
      ],
      'attachment': 'algo_resources.pdf',
    },
  ];

  @override
  void initState() {
    super.initState();
    _threads = List.from(_discussionThreads);
  }

  @override
  Widget build(BuildContext context) {
    // Filter threads by selected category and search query
    final filteredThreads = (_selectedCategory == 'All'
        ? _threads
        : _threads.where((thread) => thread['category'] == _selectedCategory).toList())
        .where((thread) => thread['title']
        .toLowerCase()
        .contains(_searchController.text.toLowerCase()))
        .toList();

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
          "University Q&A Forum",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [


          // Discussion Threads
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                child: Column(
                  children: [

                    // Hero Section
                    _buildHeroSection(),

                    // Feature List
                    _buildDiscussionFeatures(),

                    // Search and Categories
                    _buildFilterSection(),

                    // Add New Question Form
                    if (_showAddForm) _buildAddQuestionForm(),

                    // Threads List
                    _buildThreadsList(filteredThreads),

                    // FAQ Section
                    _buildFaqSection(),

                    // Footer
                    _buildFooter(context),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showAddForm = !_showAddForm;
            if (_showAddForm) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              });
            }
          });
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(_showAddForm ? Icons.close : Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            style: GoogleFonts.poppins(),
            decoration: InputDecoration(
              hintText: "Search discussions...",
              hintStyle: GoogleFonts.poppins(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = _categories[index];
                return ChoiceChip(
                  label: Text(category),
                  selected: _selectedCategory == category,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = selected ? category : 'All';
                    });
                  },
                  selectedColor: Colors.blueAccent,
                  backgroundColor: Colors.grey[100],
                  labelStyle: GoogleFonts.poppins(
                    color: _selectedCategory == category ? Colors.white : Colors.black,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddQuestionForm() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ask a Question",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: "Title",
              labelStyle: GoogleFonts.poppins(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
            maxLines: 1,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _contentController,
            decoration: InputDecoration(
              labelText: "Details",
              labelStyle: GoogleFonts.poppins(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.attach_file, color: Colors.blueAccent),
                onPressed: () {
                  // In a real app, this would open a file picker
                  setState(() {
                    _attachedFile = "lecture_notes.pdf";
                  });
                },
              ),
              if (_attachedFile != null)
                Expanded(
                  child: Text(
                    _attachedFile!,
                    style: GoogleFonts.poppins(color: Colors.blueAccent),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  setState(() {
                    _titleController.clear();
                    _contentController.clear();
                    _attachedFile = null;
                  });
                },
                child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.grey)),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (_titleController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a title')),
                    );
                    return;
                  }

                  final newThread = {
                    'id': DateTime.now().millisecondsSinceEpoch,
                    'title': _titleController.text,
                    'category': _selectedCategory == 'All' ? 'General' : _selectedCategory,
                    'author': 'You',
                    'avatar': 'Y',
                    'timestamp': DateTime.now(),
                    'upvotes': 0,
                    'replies': 0,
                    'isUpvoted': false,
                    'content': _contentController.text,
                    'attachment': _attachedFile,
                    'comments': [],
                  };

                  setState(() {
                    _threads.insert(0, newThread);
                    _titleController.clear();
                    _contentController.clear();
                    _attachedFile = null;
                    _showAddForm = false;
                  });
                },
                child: Text(
                  "Post Question",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ],
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
              child: Icon(Icons.forum_rounded, size: 220, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Join the Discussion",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Ask questions, share answers & connect with peers in real time.",
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
                      const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        "Live Q&A with 500+ students",
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

  Widget _buildDiscussionFeatures() {
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
              const Icon(Icons.forum_rounded, color: Colors.blueAccent, size: 28),
              const SizedBox(width: 10),
              Text(
                "Why Join Discussions?",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Column(
            children: [
              _buildDiscussionItem(
                Icons.question_answer_outlined,
                "Instant Doubt Solving",
                "Ask subject-related questions and get instant help from peers.",
                Colors.blueAccent,
              ),
              _buildDiscussionItem(
                Icons.thumb_up_off_alt_rounded,
                "Supportive Community",
                "Upvote helpful answers to promote meaningful discussion.",
                Colors.teal,
              ),
              _buildDiscussionItem(
                Icons.message_outlined,
                "Thoughtful Replies",
                "Engage in discussions with constructive and respectful replies.",
                Colors.orangeAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiscussionItem(IconData icon, String title, String description, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 26),
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
                    color: Colors.grey[700],
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




  Widget _buildThreadsList(List<Map<String, dynamic>> threads) {
    if (threads.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.forum_outlined, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              "No discussions found",
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
            if (_selectedCategory != 'All')
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedCategory = 'All';
                  });
                },
                child: Text("View all categories", style: GoogleFonts.poppins()),
              ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: threads.length,
      itemBuilder: (context, index) {
        final thread = threads[index];
        final isExpanded = _expandedThreads[thread['id']] ?? false;

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thread Header
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent.withOpacity(0.2),
                  child: Text(
                    thread['avatar'],
                    style: GoogleFonts.poppins(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  thread['author'],
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  _formatTimeAgo(thread['timestamp']),
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    thread['category'],
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),

              // Thread Content
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      thread['title'],
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      thread['content'],
                      style: GoogleFonts.poppins(color: Colors.grey[700]),
                    ),
                    if (thread['attachment'] != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.attach_file, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            thread['attachment'],
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Thread Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    // Like Button
                    IconButton(
                      icon: Icon(
                        thread['isUpvoted'] ? Icons.favorite : Icons.favorite_border,
                        color: thread['isUpvoted'] ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          thread['isUpvoted'] = !thread['isUpvoted'];
                          thread['upvotes'] += thread['isUpvoted'] ? 1 : -1;
                        });
                      },
                    ),
                    Text(
                      thread['upvotes'].toString(),
                      style: GoogleFonts.poppins(
                        color: thread['isUpvoted'] ? Colors.red : Colors.grey,
                      ),
                    ),

                    // Comment Button
                    IconButton(
                      icon: const Icon(Icons.comment_outlined, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _expandedThreads[thread['id']] = !isExpanded;
                        });
                      },
                    ),
                    Text(
                      thread['replies'].toString(),
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),

                    const Spacer(),

                    // Share Button
                    IconButton(
                      icon: const Icon(Icons.share_outlined, color: Colors.grey),
                      onPressed: () {
                        // Share functionality
                      },
                    ),
                  ],
                ),
              ),

              // Comments Section
              if (isExpanded) _buildCommentsSection(thread),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommentsSection(Map<String, dynamic> thread) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          // Existing Comments
          if (thread['comments'].isNotEmpty)
            Column(
              children: [
                ...(thread['comments'] as List).map((comment) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.blueAccent.withOpacity(0.2),
                              child: Text(
                                comment['avatar'],
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              comment['author'],
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _formatTimeAgo(comment['timestamp']),
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 32, top: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment['content'],
                                style: GoogleFonts.poppins(fontSize: 13),
                              ),
                              if (comment['attachment'] != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.attach_file, size: 14, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        comment['attachment'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.blueAccent,
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
                }).toList(),
                const Divider(height: 20),
              ],
            ),

          // Add Comment
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: "Write a comment...",
                    hintStyle: GoogleFonts.poppins(fontSize: 13),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  maxLines: 1,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.attach_file, color: Colors.blueAccent),
                onPressed: () {
                  // In a real app, this would open a file picker
                  setState(() {
                    _attachedCommentFile = "response_notes.pdf";
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.blueAccent),
                onPressed: () {
                  if (_commentController.text.trim().isEmpty) return;

                  setState(() {
                    thread['comments'].insert(0, {
                      'author': 'You',
                      'avatar': 'Y',
                      'timestamp': DateTime.now(),
                      'content': _commentController.text,
                      'attachment': _attachedCommentFile,
                    });

                    thread['replies'] += 1;
                    _commentController.clear();
                    _attachedCommentFile = null;
                  });
                },
              ),
            ],
          ),

          if (_attachedCommentFile != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  const Icon(Icons.attach_file, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    _attachedCommentFile!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _attachedCommentFile = null;
                      });
                    },
                    child: const Icon(Icons.close, size: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM d, y').format(dateTime);
    }
  }
}