import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/tactix_ai_provider.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';

class TactixAiScreen extends StatelessWidget {
  const TactixAiScreen({super.key});

                    @override
                    Widget build(BuildContext context) {
                      return ChangeNotifierProvider(
                        create: (_) => TactixAiProvider(),
                        child: Consumer<TactixAiProvider>(
                          builder: (context, provider, child) {
                            return Scaffold(
                              body: Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('Assets/tactix-bot.jpg'),
                                    opacity: 0.7,
                                    fit: BoxFit.cover,
                                  ),
                                  gradient: LinearGradient(
                                    colors: [backGroundColor, mainTextColour],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    buildAppBar(context, provider),
                                    if (provider.messages.isEmpty) buildWelcomeCard(context),
                                    Expanded(child: buildChat(provider)),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }

                    PreferredSizeWidget buildAppBar(
                        BuildContext context, TactixAiProvider provider) {
                      return AppBar(
                        backgroundColor: mainTextColour,
                        elevation: 2,
                        title: Row(
                          children: [
                            CircleAvatar(
                                backgroundColor: mainTextColour,
                                radius: 20,
                                child: Image.asset('Assets/tactix-bot-animation.gif')),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Tactix AI',
                                    style: TextStyle(
                                        color: secondTextColour, fontWeight: FontWeight.bold)),
                                Text(
                                  provider.isLoading ? 'Typing...' : 'Online',
                                  style: TextStyle(
                                      color: secondTextColour.withOpacity(0.7), fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        actions: [
                          IconButton(
                            icon: const Icon(Icons.refresh, color: secondTextColour),
                            onPressed: provider.clearMessages,
                          ),
                        ],
                      );
                    }

                    Widget buildWelcomeCard(BuildContext context) {
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.waving_hand_rounded,
                                      size: 32, color: Theme.of(context).colorScheme.primary),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Welcome to Tactix AI!',
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).colorScheme.onPrimaryContainer,
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
                      );
                    }

                    Widget buildChat(TactixAiProvider provider) {
                      return DashChat(
                        currentUser: provider.currentUser,
                        onSend: provider.sendMessage,
                        messages: provider.messages,
                        messageOptions:
                            MessageOptions(showTime: true, timeFormat: DateFormat('hh: mm a')),
                        inputOptions: InputOptions(
                          inputDecoration: InputDecoration(
                            hintText: 'Type your message here...',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: const BorderSide(color: Colors.grey)),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          sendButtonBuilder: (onSend) => IconButton(
                            icon: const Icon(Icons.send_rounded, color: secondTextColour),
                            onPressed: onSend,
                          ),
                        ),
                      );
                    }
}
