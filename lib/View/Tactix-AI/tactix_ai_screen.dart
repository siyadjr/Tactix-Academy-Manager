import 'dart:developer';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';

class TactixAiScreen extends StatefulWidget {
  const TactixAiScreen({super.key});

  @override
  State<TactixAiScreen> createState() => _TactixAiScreenState();
}

class _TactixAiScreenState extends State<TactixAiScreen> {
  final Gemini tactixAi = Gemini.instance;
  List<ChatMessage> messages = [];
  bool isLoading = false;

  final ChatUser currentuser = ChatUser(
    id: '0',
    firstName: 'User',
  );

  final ChatUser geminiuser = ChatUser(
    id: '1',
    firstName: 'TactixAI',
    profileImage:
        'https://res.cloudinary.com/dplpu9uc5/image/upload/v1736923321/tactix-bot_h6j5as.jpg',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('Assets/tactix-bot.jpg'),
              opacity: 0.7,
              fit: BoxFit.cover),
          gradient: LinearGradient(
            colors: [backGroundColor, mainTextColour],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            _buildAppBar(),
            _buildWelcomeCard(),
            Expanded(
              child: _buildChat(),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: mainTextColour,
      elevation: 2,
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(geminiuser.profileImage!),
            radius: 20,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tactix AI',
                style: TextStyle(
                  color: secondTextColour,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                isLoading ? 'Typing...' : 'Online',
                style: TextStyle(
                  color: secondTextColour.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          color: secondTextColour,
          onPressed: () {
            setState(() {
              messages.clear();
            });
          },
        ),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    return messages.isEmpty
        ? Card(
            elevation: 2,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer,
                    Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.8),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.waving_hand_rounded,
                          size: 32,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Welcome to Tactix AI!',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'I\'m here to help you with any questions you might have. Feel free to ask anything!',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer
                                .withOpacity(0.8),
                            height: 1.5,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildChat() {
    return DashChat(
      currentUser: currentuser,
      onSend: sendMessage,
      messages: messages,
      messageOptions: const MessageOptions(
        showTime: true,
      ),
      inputOptions: InputOptions(
        inputDecoration: InputDecoration(
          hintText: 'Type your message here...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
        ),
        sendButtonBuilder: (onSend) => IconButton(
          icon: const Icon(
            Icons.send_rounded,
            color: secondTextColour,
          ),
          onPressed: onSend,
        ),
      ),
    );
  }

  void sendMessage(ChatMessage chatMessage) async {
    setState(() {
      messages = [chatMessage, ...messages];
      isLoading = true;
    });

    try {
      String question = chatMessage.text;
      tactixAi.streamGenerateContent(question).listen(
        (event) {
          ChatMessage? lastMessage = messages.firstOrNull;
          if (lastMessage != null && lastMessage.user == geminiuser) {
            lastMessage = messages.removeAt(0);
            final response = event.content?.parts?.fold(
                    '', (previous, current) => '$previous ${current.text}') ??
                '';
            lastMessage.text += response;
            setState(() {
              messages = [lastMessage!, ...messages];
            });
          } else {
            final response = event.content?.parts?.fold(
                    '', (previous, current) => '$previous ${current.text}') ??
                '';
            log(response.toString());

            // Process response text for gradient and bold formatting
            final processedText = response;

            ChatMessage message = ChatMessage(
              user: geminiuser,
              createdAt: DateTime.now(),
              text: processedText,
            );
            setState(() {
              messages = [message, ...messages];
            });
          }
        },
        onDone: () {
          setState(() {
            isLoading = false;
          });
        },
        onError: (error) {
          setState(() {
            isLoading = false;
            messages = [
              ChatMessage(
                user: geminiuser,
                createdAt: DateTime.now(),
                text: 'Sorry, I encountered an error. Please try again.',
              ),
              ...messages
            ];
          });
        },
      );
    } catch (e) {
      setState(() {
        isLoading = false;
        messages = [
          ChatMessage(
            user: geminiuser,
            createdAt: DateTime.now(),
            text: 'Sorry, something went wrong. Please try again.',
          ),
          ...messages
        ];
      });
    }
  }
}
