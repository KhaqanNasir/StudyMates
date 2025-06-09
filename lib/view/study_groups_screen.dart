import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../model/study_group_model.dart';
import '../services/firestore_service.dart';
import '../view_model/study_groups_view_model.dart';

class StudyGroupsScreen extends StatelessWidget {
  const StudyGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StudyGroupsViewModel(FirestoreService()),
      child: const _StudyGroupsScreenContent(),
    );
  }
}

class _StudyGroupsScreenContent extends StatefulWidget {
  const _StudyGroupsScreenContent();

  @override
  State<_StudyGroupsScreenContent> createState() => _StudyGroupsScreenContentState();
}

class _StudyGroupsScreenContentState extends State<_StudyGroupsScreenContent> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  late final StudyGroupsViewModel _viewModel;
  final Map<int, bool> _expandedFaqs = {};

  final List<String> _departments = [
    'Computer Science',
    'Civil Engineering',
  ];

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeViewModel();
    });
  }

  void _initializeViewModel() {
    _viewModel = Provider.of<StudyGroupsViewModel>(context, listen: false);
    _viewModel.fetchStudyGroups();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _viewModel.setSearchQuery(_searchController.text);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StudyGroupsViewModel>(
      builder: (context, viewModel, child) {
        print("Building with selectedGroup: ${viewModel.selectedGroup?.name}");
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                if (viewModel.selectedGroup != null) {
                  viewModel.clearSelectedGroup();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            backgroundColor: Colors.blueAccent,
            elevation: 0,
            title: Text(
              viewModel.selectedGroup?.name ?? "Study Groups",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            actions: viewModel.selectedGroup != null
                ? [
              IconButton(
                icon: const Icon(Icons.info_outline, color: Colors.white),
                onPressed: () {
                  _showGroupInfo(context, viewModel.selectedGroup!);
                },
              ),
            ]
                : null,
          ),
          body: SafeArea(
            child: viewModel.selectedGroup != null
                ? _buildChatInterface(context, viewModel)
                : _buildMainInterface(context, viewModel),
          ),
        );
      },
    );
  }

  Widget _buildMainInterface(BuildContext context, StudyGroupsViewModel viewModel) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroSection(),
          _buildGroupFeatures(),
          _buildFilterSection(viewModel),
          if (viewModel.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (viewModel.errorMessage != null)
            Center(child: Text(viewModel.errorMessage!))
          else
            _buildGroupsList(viewModel.studyGroups, viewModel),
          _buildFaqSection(),
          _buildFooter(context),
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
                        "3 active groups available",
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

  Widget _buildFilterSection(StudyGroupsViewModel viewModel) {
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
          ),
          const SizedBox(height: 15),
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
                    selected: viewModel.selectedDepartment == department,
                    onSelected: (selected) {
                      viewModel.setSelectedDepartment(selected ? department : null);
                    },
                    selectedColor: Colors.blueAccent,
                    labelStyle: TextStyle(
                      color: viewModel.selectedDepartment == department ? Colors.white : Colors.black,
                    ),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: viewModel.selectedDepartment == department
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

  Widget _buildGroupsList(List<StudyGroup> groups, StudyGroupsViewModel viewModel) {
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
              viewModel.selectedDepartment == null || viewModel.selectedDepartment == 'All Departments'
                  ? "No study groups available"
                  : "No groups found in the ${viewModel.selectedDepartment} department",
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
              return _buildGroupCard(context, group, viewModel);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(BuildContext context, StudyGroup group, StudyGroupsViewModel viewModel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _viewGroupDetails(context, group);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'image/logo.png',
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print("Image asset error: $error");
                    return Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey[200],
                      child: const Icon(Icons.group, color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      group.description,
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
                      "${group.department} • ${group.subject}",
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
                          "${group.memberCount} members",
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
                          "${group.activeMembers} online",
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
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () async {
                    if (group.isJoined) {
                      await viewModel.leaveGroup(group.id);
                    } else {
                      await viewModel.joinGroup(group.id);
                      viewModel.selectGroup(group);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: group.isJoined ? Colors.grey[200] : Colors.blueAccent,
                    foregroundColor: group.isJoined ? Colors.grey[800] : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: Text(
                    group.isJoined ? "Joined" : "Join",
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

  void _viewGroupDetails(BuildContext context, StudyGroup group) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
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
                          errorBuilder: (context, error, stackTrace) {
                            print("Image asset error: $error");
                            return Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[200],
                              child: const Icon(Icons.group, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              "${group.department} • ${group.subject}",
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
                    group.description,
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
                              "${group.memberCount}",
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
                              "${group.activeMembers}",
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
                  const SizedBox(height: 20),
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
                  SizedBox(
                    height: 150, // Constrain participant list height
                    child: ListView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
                      itemCount: group.participants.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return _buildParticipantTile("You", true);
                        } else {
                          return _buildParticipantTile(group.participants[index - 1], false);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: Consumer<StudyGroupsViewModel>(
                        builder: (context, viewModel, _) => ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            if (!group.isJoined) {
                              viewModel.joinGroup(group.id);
                            }
                            viewModel.selectGroup(group);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: group.isJoined ? Colors.grey[200] : Colors.blueAccent,
                            foregroundColor: group.isJoined ? Colors.grey[800] : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            group.isJoined ? "Open Chat" : "Join Group",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatInterface(BuildContext context, StudyGroupsViewModel viewModel) {
    if (viewModel.selectedGroup == null) {
      print("Selected group is null, returning error screen");
      return const Center(child: Text("Error: No group selected"));
    }

    final firestoreService = FirestoreService();
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<List<Message>>(
            stream: firestoreService.getMessages(viewModel.selectedGroup!.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                print("StreamBuilder error: ${snapshot.error}");
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final messages = snapshot.data ?? [];
              if (messages.isEmpty) {
                return _buildEmptyChatState();
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                reverse: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isSentByMe = message.senderId == firestoreService.currentUserId;
                  return _buildMessageBubble(context, message, isSentByMe, viewModel);
                },
              );
            },
          ),
        ),
        _buildMessageInput(context, viewModel),
      ],
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

  Widget _buildMessageBubble(BuildContext context, Message message, bool isSentByMe, StudyGroupsViewModel viewModel) {
    final time = message.timestamp.toDate();
    final formattedTime = "${time.hour}:${time.minute.toString().padLeft(2, '0')}";

    return GestureDetector(
      onLongPress: isSentByMe
          ? () => _showMessageOptions(context, message, viewModel)
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isSentByMe) ...[
              CircleAvatar(
                radius: 16,
                backgroundColor: _getAvatarColor(message.senderName),
                child: Text(
                  message.senderName[0].toUpperCase(),
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
                  maxWidth: MediaQuery.of(context).size.width * 0.65,
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
                          message.senderName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: _getAvatarColor(message.senderName),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    Text(
                      message.content,
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
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blueAccent,
                child: Text(
                  "Y",
                  style: const TextStyle(
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
      ),
    );
  }

  void _showMessageOptions(BuildContext context, Message message, StudyGroupsViewModel viewModel) {
    final controller = TextEditingController(text: message.content);

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Message'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Edit Message'),
                    content: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: 'Edit your message...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await viewModel.updateMessage(message.id, controller.text);
                          Navigator.pop(context);
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Message', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(context);
                await viewModel.deleteMessage(message.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, StudyGroupsViewModel viewModel) {
    final firestoreService = FirestoreService();
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
              _showAttachmentOptions(context);
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
            onTap: () async {
              if (_messageController.text.trim().isNotEmpty) {
                final userData = await firestoreService.getCurrentUserData();
                await viewModel.sendMessage(
                  _messageController.text.trim(),
                  userData?['fullName'] ?? 'You',
                );
                _messageController.clear();
              }
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

  void _showAttachmentOptions(BuildContext context) {
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

  void _showGroupInfo(BuildContext context, StudyGroup group) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
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
                          errorBuilder: (context, error, stackTrace) {
                            print("Image asset error: $error");
                            return Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[200],
                              child: const Icon(Icons.group, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              "${group.department} • ${group.subject}",
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
                    group.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildStatCard("Members", "${group.memberCount}", Icons.people),
                      const SizedBox(width: 10),
                      _buildStatCard("Online", "${group.activeMembers}", Icons.circle, Colors.green),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
                      itemCount: group.participants.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return _buildParticipantTile("You", true);
                        } else {
                          return _buildParticipantTile(group.participants[index - 1], false);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<StudyGroupsViewModel>().leaveGroup(group.id);
                        context.read<StudyGroupsViewModel>().clearSelectedGroup();
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
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

  Color _getAvatarColor(String name) {
    final colors = [
      Colors.redAccent,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pinkAccent,
    ];
    final index = name.codeUnits.fold(0, (prev, current) => prev + current) % colors.length;
    return colors[index];
  }
}