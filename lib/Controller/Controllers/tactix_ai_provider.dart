import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class TactixAiProvider extends ChangeNotifier {
  final Gemini tactixAi = Gemini.instance;
  List<ChatMessage> _messages = [];
  bool _isLoading = false;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  final ChatUser currentUser = ChatUser(id: '0', firstName: 'User');
  final ChatUser geminiUser = ChatUser(
    id: '1',
    firstName: 'TactixAI',
    profileImage: 'https://res.cloudinary.com/dplpu9uc5/image/upload/v1736923321/tactix-bot_h6j5as.jpg',
  );

  void sendMessage(ChatMessage chatMessage) {
    _messages = [chatMessage, ..._messages];
    _isLoading = true;
    notifyListeners();

    tactixAi.streamGenerateContent(chatMessage.text).listen(
      (event) {
        final response = event.content?.parts?.fold('', (prev, curr) => '$prev ${curr.text}') ?? '';
        ChatMessage message = ChatMessage(
          user: geminiUser,
          createdAt: DateTime.now(),
          text: response,
        );
        _messages = [message, ..._messages];
        notifyListeners();
      },
      onDone: () {
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        _messages = [
          ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: 'Sorry, I encountered an error. Please try again.',
          ),
          ..._messages
        ];
        notifyListeners();
      },
    );
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}