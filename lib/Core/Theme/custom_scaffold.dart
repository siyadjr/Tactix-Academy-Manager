import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;

  const CustomScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
       
          Container(
            width: MediaQuery.of(context).size.width * 5,
            height: MediaQuery.of(context).size.height * 5,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('Assets/image.jpg'),
                fit: BoxFit.contain, // Adjust to your preference
                opacity: 0.21, // Optional transparency for the background
              ),
            ),
          ),
          // Foreground content
          body,
        ],
      ),
    );
  }
}
