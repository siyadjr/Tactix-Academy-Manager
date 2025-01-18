import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:flutter_animator/widgets/fading_entrances/fade_in_right.dart';
import 'package:intl/intl.dart';
import 'package:tactix_academy_manager/View/BroadCast/functions/broadcast_normal_functions.dart.dart';

class BroadcastMessageList extends StatelessWidget {
  final snapshot;
  const BroadcastMessageList({
    super.key,
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    final groupedMessages = _groupMessagesByDate(snapshot.data!.docs);
    final sortedDates = groupedMessages.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // Sort dates in descending order

    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final messages = groupedMessages[date]!;

        // Sort messages within each date group in ascending order
        messages.sort((a, b) {
          final aTimestamp =
              (a.data() as Map<String, dynamic>)['timestamp'] as Timestamp;
          final bTimestamp =
              (b.data() as Map<String, dynamic>)['timestamp'] as Timestamp;
          return aTimestamp.compareTo(bTimestamp);
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced Date Header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    getDateHeader(date),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),

            ...messages.map((doc) {
              final message = doc.data() as Map<String, dynamic>;
              final timestamp = message['timestamp'] as Timestamp?;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: FadeIn(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(4),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['message'] ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check,
                                    size: 12,
                                    color: Colors.blue.withOpacity(0.7),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    timestamp != null
                                        ? formatTimestamp(timestamp)
                                        : '',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Map<DateTime, List<QueryDocumentSnapshot>> _groupMessagesByDate(
      List<QueryDocumentSnapshot> docs) {
    final Map<DateTime, List<QueryDocumentSnapshot>> groupedMessages = {};
    for (var doc in docs) {
      final message = doc.data() as Map<String, dynamic>;
      final timestamp = message['timestamp'] as Timestamp?;
      if (timestamp != null) {
        final date = DateTime(timestamp.toDate().year, timestamp.toDate().month,
            timestamp.toDate().day);
        if (groupedMessages.containsKey(date)) {
          groupedMessages[date]!.add(doc);
        } else {
          groupedMessages[date] = [doc];
        }
      }
    }
    return groupedMessages;
  }
}
