import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:intl/intl.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/team_database.dart';
import 'package:tactix_academy_manager/View/BroadCast/Widgets/broad_cast_no_announcment.dart';
import 'package:tactix_academy_manager/View/BroadCast/Widgets/broadcast_error_state.dart';
import 'package:tactix_academy_manager/View/BroadCast/Widgets/broadcast_message_list.dart';
import 'package:tactix_academy_manager/View/BroadCast/functions/format_time.dart';

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
    initializeAnimation();
    fetchTeamId();
  }

  void initializeAnimation() {
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

  Future<void> fetchTeamId() async {
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Team Broadcast',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            Text(
              'Announcements & Updates',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ],
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
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.blue[400],
                ),
              )
            : FadeTransition(
                opacity: _animation,
                child: Column(
                  children: [
                    Expanded(
                      child: _teamId == null
                          ? const BroadcastErrorState()
                          : buildMessageStream(),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        border: Border(
                          top: BorderSide(
                            color: Colors.blue.withOpacity(0.2),
                          ),
                        ),
                      ),
                      child: SafeArea(
                        child: Row(
                          children: [
                            Expanded(
                              child: FadeInRight(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: Colors.blue.withOpacity(0.3),
                                    ),
                                  ),
                                  child: TextField(
                                    controller: _messageController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText:
                                          'Announce something to your team...',
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400]),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.all(16),
                                      prefixIcon: Icon(
                                        Icons.campaign,
                                        color: Colors.blue[400],
                                      ),
                                    ),
                                    maxLines: null,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            FadeInUp(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue[400]!,
                                      Colors.blue[600]!
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(25),
                                    onTap: _sendMessage,
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      child: const Icon(
                                        Icons.send_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget buildMessageStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Teams')
          .doc(_teamId)
          .collection('Broadcast')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: Colors.blue[400]),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Unable to load messages',
                  style: TextStyle(color: Colors.red[300], fontSize: 16),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const BroadcastNoAnnouncement();
        }

        return BroadcastMessageList(
          snapshot: snapshot,
        );
      },
    );
  }
}

