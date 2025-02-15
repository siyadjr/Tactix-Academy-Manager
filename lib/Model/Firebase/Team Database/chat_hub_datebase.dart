import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tactix_academy_manager/Model/Firebase/Team%20Database/team_database.dart';

class ChatHubDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createChatRoom(String chaterID) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("User not logged in");

      final userId = user.uid;
      final teamId = await TeamDatabase().getTeamId();

      List<String> sortedIds = [userId, chaterID]..sort();
      final docId = sortedIds.join("_");

      final chatRoomRef = _firestore.collection('Chats').doc(docId);
      final chatRoomSnapshot = await chatRoomRef.get();

      if (!chatRoomSnapshot.exists) {
        await chatRoomRef.set({
          'users': [userId, chaterID],
          'teamId': teamId,
          'createdAt': FieldValue.serverTimestamp(),
          'lastMessage': null,
          'isTyping': false
        });
      }
    } catch (e) {
      print("Error creating chat room: $e");
    }
  }

  Future<void> sendMessage(
      String message, String senderId, String chaterId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("User not logged in");

      List<String> sortedIds = [senderId, chaterId]..sort();
      final docId = sortedIds.join("_");

      final chatRef =
          _firestore.collection('Chats').doc(docId).collection("Messages");

      await chatRef.add({
        "message": message,
        "sender": senderId,
        "timeStamp": FieldValue.serverTimestamp(),
      });

      await _firestore.collection('Chats').doc(docId).update({
        'lastMessage': message,
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  Stream<List<Map<String, dynamic>>> getMessages(String chaterId) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return const Stream.empty();

    List<String> sortedIds = [userId, chaterId]..sort();
    final docId = sortedIds.join("_");

    return _firestore
        .collection('Chats')
        .doc(docId)
        .collection('Messages')
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<String> getLastMessage(String chaterId) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return const Stream.empty();

    List<String> sortedIds = [userId, chaterId]..sort();
    final docId = sortedIds.join("_");

    // Stream the latest message from the 'Messages' subcollection.
    return _firestore
        .collection('Chats')
        .doc(docId)
        .collection('Messages')
        .orderBy('timeStamp', descending: true)
        .limit(1) // Get only the latest message
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return ''; // Return an empty string if no messages
      }
      // Extract the last message from the snapshot
      return snapshot.docs.first['message'] ?? '';
    });
  }
}
