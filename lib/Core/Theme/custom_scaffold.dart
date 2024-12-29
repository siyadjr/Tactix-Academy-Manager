import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  const CustomScaffold({super.key, required this.body,this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
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
