import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:tactix_academy_manager/Controller/Api/gemini_ai.dart';

class TactixAiProvider extends ChangeNotifier {
  late final GenerativeModel _model;
  late ChatSession _chat;

  List<ChatMessage> _messages = [];
  bool _isLoading = false;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  final ChatUser currentUser = ChatUser(id: '0', firstName: 'User');
  final ChatUser geminiUser = ChatUser(
    id: '1',
    firstName: 'TactixAI',
    profileImage:
        'https://res.cloudinary.com/dplpu9uc5/image/upload/v1736923321/tactix-bot_h6j5as.jpg',
  );

  TactixAiProvider() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: GEMINI_API_KEY,
    );
    _chat = _model.startChat();
  }

  void sendMessage(ChatMessage chatMessage) async {
    debugPrint("--- Sending Message to Gemini: ${chatMessage.text} ---");
    _messages = [chatMessage, ..._messages];
    _isLoading = true;
    notifyListeners();

    String fullResponse = "";
    ChatMessage? geminiMessage;

    try {
      final content = Content.text(chatMessage.text);
      final responseStream = _chat.sendMessageStream(content);

      await for (final response in responseStream) {
        final chunk = response.text ?? "";
        debugPrint("--- Received Chunk: $chunk ---");
        fullResponse += chunk;

        if (geminiMessage == null) {
          geminiMessage = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: fullResponse,
          );
          _messages = [geminiMessage!, ..._messages];
        } else {
          geminiMessage = ChatMessage(
            user: geminiUser,
            createdAt: geminiMessage!.createdAt,
            text: fullResponse,
          );
          _messages[0] = geminiMessage!;
        }
        notifyListeners();
      }
      debugPrint("--- Gemini Result Finished ---");
    } catch (e) {
      debugPrint("--- Gemini Error Encountered: $e ---");
      _messages = [
        ChatMessage(
          user: geminiUser,
          createdAt: DateTime.now(),
          text: 'Sorry, I encountered an error: $e',
        ),
        ..._messages
      ];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _messages.clear();
    _chat = _model.startChat(); // Restart chat session
    notifyListeners();
  }
}
