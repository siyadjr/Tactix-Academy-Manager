import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/session_details_provider.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Model/Models/session_model.dart';
import 'package:tactix_academy_manager/View/Sessions/Widgets/session_details_content.dart';
import 'package:tactix_academy_manager/View/Sessions/Widgets/session_details_quick_infobar.dart';

class SessionsDetails extends StatelessWidget {
  final SessionModel session;

  const SessionsDetails({super.key, required this.session});

  DateTime? _parseDate(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

 @override
Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sessionDetailsProvider = Provider.of<SessionDetailsProvider>(context, listen: false);

    // Only use addPostFrameCallback for the conditional fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (sessionDetailsProvider.session?.id != session.id) {
        sessionDetailsProvider.fetchSession(session.id);
      }
    });
    return Scaffold(
      backgroundColor: blackColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: FadeInLeft(
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: blackColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios,
                  color: primaryColor, size: 20),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: FadeInDown(
          child: const Text(
            'Session Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: primaryColor,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Consumer<SessionDetailsProvider>(
          builder: (context, sessionDetailsProvider, child) {
            log('Triggered!');

            if (sessionDetailsProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final sessionData = sessionDetailsProvider.session;
            if (sessionData == null) {
              return const Center(
                child: Text(
                  'Session not found.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'session-${sessionData.name}',
                  child: Stack(
                    children: [
                      FadeInUp(
                        child: SizedBox(
                          height: size.height * 0.45,
                          width: double.infinity,
                          child: FadeInImage.assetNetwork(
                            placeholder: 'Assets/Sessions.png',
                            image: sessionData.imagePath,
                            fit: BoxFit.cover,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: size.height * 0.45,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              blackColor.withOpacity(0.8),
                              Colors.transparent,
                              blackColor.withOpacity(0.8),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        left: 16,
                        right: 16,
                        child: FadeInLeft(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sessionData.name,
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  shadows: [
                                    Shadow(
                                      color: blackColor.withOpacity(0.8),
                                      blurRadius: 15,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              SessionQuickInfoBar(
                                session: sessionData,
                                sessionDate: _parseDate(sessionData.date),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                FadeInUp(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: backGroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: blackColor.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SessionDetailsContents(
                      session: sessionData,
                      sessionDate: _parseDate(sessionData.date),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
