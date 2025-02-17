import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';


class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 20,
            color: secondTextColour.withOpacity(0.8),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: secondTextColour,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: secondTextColour),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'About Tactics Academy',
          style: TextStyle(
            color: secondTextColour,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: secondTextColour.withOpacity(0.1),
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      CupertinoIcons.sportscourt,
                      size: 64,
                      color: secondTextColour.withOpacity(0.9),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tactics Academy',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: secondTextColour,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Empowering Football Teams with Technology',
                      style: TextStyle(
                        fontSize: 16,
                        color: secondTextColour.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Our Mission',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: secondTextColour,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tactics Academy is a platform designed to help football coaches, managers, and players collaborate and manage teams efficiently.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: secondTextColour,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Key Features',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: secondTextColour,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem('Manage coaching licenses for managers'),
                    _buildFeatureItem('Create and manage teams effortlessly'),
                    _buildFeatureItem('Assign tasks and schedule events'),
                    _buildFeatureItem(
                        'Track player performance, fitness, and achievements'),
                    _buildFeatureItem(
                        'Integrated AI chatbot for instant assistance'),
                    _buildFeatureItem('Broadcast updates through channels'),
                    _buildFeatureItem(
                        'Secure payment integration for academy fees'),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: secondTextColour.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Join us and take your team to the next level!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: secondTextColour,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'For more information, feel free to reach out through our Contact Us page.',
                            style: TextStyle(
                              fontSize: 14,
                              color: secondTextColour.withOpacity(0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
