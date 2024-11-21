import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text(
        'HomeSCreen',
        style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
      ),
    ));
  }
}
