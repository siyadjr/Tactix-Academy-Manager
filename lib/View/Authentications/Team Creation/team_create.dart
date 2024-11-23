import 'package:flutter/material.dart';

class TeamCreate extends StatelessWidget {
  const TeamCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C2B), // Dark background
      appBar: AppBar(
        title: const Text('Welcome User'),
        backgroundColor: const Color(0xFF1C1C2B),
        elevation: 0,
        actions: const [],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title with color
              const Text(
                'Lets Create Your ELITE SQUAD',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8A4BFF), // Purple color
                ),
              ),
              const SizedBox(height: 20),

              // Team logo
              GestureDetector(
                onTap: () {
                  // Handle logo upload
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.upload,
                      color: Colors.black,
                      size: 50,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Team Name input
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Team Name',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Color(0xFF2A2A3D),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Location input
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Location',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Color(0xFF2A2A3D),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Enter button
              ElevatedButton(
                onPressed: () {
                  // Handle team creation logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A4BFF), // Purple color
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Enter',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Footer text
              const Text(
                'After creating a team, you’ll receive a unique Team ID. Share this ID with your players, so they can use it to join your Elite Squad.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
