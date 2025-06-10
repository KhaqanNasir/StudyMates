import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../view_model/discussion_view_model.dart';
import '../model/discussion_model.dart';
import '../services/firestore_service.dart';

class DiscussionScreen extends StatelessWidget {
  const DiscussionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DiscussionViewModel(),
      child: Consumer<DiscussionViewModel>(
        builder: (context, viewModel, child) {
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
                  onPressed: () => viewModel.fetchThreadsStream(),
                ),
              ],
            ),
            body: StreamBuilder<List<DiscussionThread>>(
              stream: viewModel.threadsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                return RefreshIndicator(
                  onRefresh: () => Future(() => viewModel.fetchThreadsStream()),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        _buildHeroSection(),
                        _buildDiscussionFeatures(),
                        _buildFilterSection(viewModel),
                        if (viewModel.showAddForm) _buildAddQuestionForm(viewModel, context),
                        _buildThreadsList(viewModel),
                        _buildFaqSection(viewModel),
                        _buildFooter(context),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: viewModel.toggleAddForm,
              backgroundColor: Colors.blueAccent,
              child: Icon(
                viewModel.showAddForm ? Icons.close : Icons.add,
                color: Colors.white,
              ),
            ),
          );
        },
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

  Widget _buildFilterSection(DiscussionViewModel viewModel) {
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
            controller: viewModel.searchController,
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
            onChanged: (value) {
              viewModel.setSelectedCategory(viewModel.selectedCategory); // Force refresh
            },
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: viewModel.departments.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = viewModel.departments[index];
                return ChoiceChip(
                  label: Text(category),
                  selected: viewModel.selectedCategory == category,
                  onSelected: (selected) {
                    if (selected) {
                      viewModel.setSelectedCategory(category);
                    }
                  },
                  selectedColor: Colors.blueAccent,
                  backgroundColor: Colors.grey[100],
                  labelStyle: GoogleFonts.poppins(
                    color: viewModel.selectedCategory == category ? Colors.white : Colors.black,
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

  Widget _buildAddQuestionForm(DiscussionViewModel viewModel, BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ask a Question",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: viewModel.titleController,
            decoration: InputDecoration(
              labelText: "Title",
              labelStyle: GoogleFonts.poppins(color: Colors.grey[700]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.blueAccent),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            ),
            maxLines: 1,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: viewModel.selectedDepartment,
            decoration: InputDecoration(
              labelText: "Department",
              labelStyle: GoogleFonts.poppins(color: Colors.grey[700]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.blueAccent),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            ),
            items: viewModel.departments
                .where((dept) => dept != 'All')
                .map((dept) => DropdownMenuItem(
              value: dept,
              child: Text(dept, style: GoogleFonts.poppins()),
            ))
                .toList(),
            onChanged: viewModel.setSelectedDepartment,
            dropdownColor: Colors.white,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: viewModel.contentController,
            decoration: InputDecoration(
              labelText: "Details",
              labelStyle: GoogleFonts.poppins(color: Colors.grey[700]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.blueAccent),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.attach_file, color: Colors.blueAccent, size: 24),
                onPressed: () {
                  viewModel.setAttachedFile("lecture_notes.pdf");
                },
              ),
              if (viewModel.attachedFile != null)
                Expanded(
                  child: Text(
                    viewModel.attachedFile!,
                    style: GoogleFonts.poppins(color: Colors.blueAccent, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  viewModel.titleController.clear();
                  viewModel.contentController.clear();
                  viewModel.setAttachedFile(null);
                  viewModel.toggleAddForm();
                },
                child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 16)),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ).copyWith(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.blue[700];
                    }
                    return Colors.blueAccent;
                  }),
                ),
                onPressed: () => viewModel.addThread(context),
                child: Text(
                  "Post Question",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThreadsList(DiscussionViewModel viewModel) {
    if (viewModel.threads.isEmpty) {
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
            if (viewModel.selectedCategory != 'All')
              TextButton(
                onPressed: () => viewModel.setSelectedCategory('All'),
                child: Text("View all categories", style: GoogleFonts.poppins()),
              ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: viewModel.threads.length,
      itemBuilder: (context, index) {
        final thread = viewModel.threads[index];
        final isExpanded = viewModel.expandedThreads[thread.id] ?? false;

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
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent.withOpacity(0.2),
                  child: Text(
                    thread.avatar,
                    style: GoogleFonts.poppins(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  thread.author,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  _formatTimeAgo(thread.timestamp),
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    thread.category,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      thread.title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      thread.content,
                      style: GoogleFonts.poppins(color: Colors.grey[700]),
                    ),
                    if (thread.attachment != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.attach_file, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            thread.attachment!,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        thread.upvotedBy.contains(FirebaseAuth.instance.currentUser!.uid)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: thread.upvotedBy.contains(FirebaseAuth.instance.currentUser!.uid)
                            ? Colors.red
                            : Colors.grey,
                      ),
                      onPressed: () => viewModel.toggleUpvote(thread.id),
                    ),
                    Text(
                      thread.upvotes.toString(),
                      style: GoogleFonts.poppins(
                        color: thread.upvotedBy.contains(FirebaseAuth.instance.currentUser!.uid)
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.comment_outlined, color: Colors.grey),
                      onPressed: () => viewModel.toggleThreadExpansion(thread.id),
                    ),
                    Text(
                      thread.replies.toString(),
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.share_outlined, color: Colors.grey),
                      onPressed: () {
                        // Implement share functionality
                      },
                    ),
                  ],
                ),
              ),
              if (isExpanded)
                StreamBuilder<List<ThreadComment>>(
                  stream: FirestoreService().getCommentsStream(thread.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    final comments = snapshot.data ?? [];
                    return _buildCommentsSection(thread, viewModel, context, comments);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCommentsSection(
      DiscussionThread thread, DiscussionViewModel viewModel, BuildContext context, List<ThreadComment> comments) {
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
          if (comments.isNotEmpty)
            Column(
              children: comments.map((comment) {
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
                              comment.avatar,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            comment.author,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatTimeAgo(comment.timestamp),
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
                              comment.content,
                              style: GoogleFonts.poppins(fontSize: 13),
                            ),
                            if (comment.attachment != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  children: [
                                    const Icon(Icons.attach_file, size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      comment.attachment!,
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
            ),
          const Divider(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: viewModel.commentController,
                  decoration: InputDecoration(
                    hintText: "Write a comment...",
                    hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
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
                icon: const Icon(Icons.attach_file, color: Colors.blueAccent, size: 20),
                onPressed: () {
                  viewModel.setAttachedCommentFile("response_notes.pdf");
                },
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.blueAccent, size: 20),
                onPressed: () => viewModel.addComment(thread.id, context),
              ),
            ],
          ),
          if (viewModel.attachedCommentFile != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  const Icon(Icons.attach_file, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    viewModel.attachedCommentFile!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => viewModel.setAttachedCommentFile(null),
                    child: const Icon(Icons.close, size: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFaqSection(DiscussionViewModel viewModel) {
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
          ...viewModel.faqs.asMap().entries.map((entry) {
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
                    color: viewModel.expandedFaqs[index] ?? false ? Colors.blueAccent : Colors.black87,
                  ),
                ),
                leading: Icon(
                  Icons.help_outline,
                  color: viewModel.expandedFaqs[index] ?? false ? Colors.blueAccent : Colors.grey,
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
                initiallyExpanded: viewModel.expandedFaqs[index] ?? false,
                onExpansionChanged: (expanded) => viewModel.toggleFaqExpansion(index),
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