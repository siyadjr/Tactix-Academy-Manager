import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/home_screen_provider.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/team_database.dart';

class BroadCast extends StatefulWidget {
  const BroadCast({super.key});

  @override
  State<BroadCast> createState() => _BroadCastState();
}

class _BroadCastState extends State<BroadCast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final TextEditingController _messageController = TextEditingController();

  String? _teamId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _fetchTeamId();
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  Future<void> _fetchTeamId() async {
    try {
      String fetchedTeamId = await TeamDatabase().getTeamId();
      setState(() {
        _teamId = fetchedTeamId;
        _isLoading = false;
      });
      log('Team ID fetched successfully: $_teamId');
    } catch (e) {
      log('Error fetching team ID: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _messageController.dispose();
    super.dispose();
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, y').format(dateTime);
    }
  }

  void _sendMessage() async {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      log('Sending message: $message');
      setState(() {
        _messageController.clear();
      });
      await TeamDatabase().sendMessageBroadcast(message);
    } else {
      log('Message is empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Broadcast',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.blueGrey.shade900],
          ),
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : FadeTransition(
                opacity: _animation,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _teamId == null
                            ? const Center(
                                child: Text(
                                  'Error: No team ID found!',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            : _buildMessageStream(),
                      ),
                      const SizedBox(height: 16),
                      buildMessageInput(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildMessageStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Teams')
          .doc(_teamId)
          .collection('Broadcast')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error fetching messages',
              style: TextStyle(color: Colors.red.shade300, fontSize: 16),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No messages yet!',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        final messages = snapshot.data!.docs;

        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index].data() as Map<String, dynamic>;
            final messageText = message['message'] ?? 'No message content';
            final timestamp = message['timestamp'] != null
                ? (message['timestamp'] as Timestamp)
                : null;

            return Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                GestureDetector(
                  onLongPress: () {},
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.only(bottom: 12.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade700, Colors.blue.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          messageText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          timestamp != null ? _formatTimestamp(timestamp) : '',
                          style: TextStyle(
                            color: Colors.blue.shade100,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Consumer<TeamProvider>(builder: (context, teamProvider, child) {
                  return CircleAvatar(
                    backgroundImage: teamProvider.managerPhotoUrl.isNotEmpty
                        ? NetworkImage(teamProvider.managerPhotoUrl)
                        : const AssetImage('Assets/default_team.logo.png')
                            as ImageProvider,
                  );
                })
              ]),
            );
          },
        );
      },
    );
  }

  Widget buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: FadeInRight(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12.0),
        FadeInUp(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade400,
                  Colors.blue.shade600,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send_rounded,
                color: Colors.white,
              ),
              onPressed: _sendMessage,
            ),
          ),
        ),
      ],
    );
  }
}
