import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';

class ChatListSearch extends StatelessWidget {
  final Function(String) onChanged;
  final String hintText;

  const ChatListSearch(
      {super.key,
      required this.onChanged,
      this.hintText = 'Search players...'});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: backGroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [],
        ),
        child: TextField(
          decoration: InputDecoration(
            filled: false,
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            
            hintText: hintText,
            labelStyle: const TextStyle(color: secondTextColour),
            hintStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
          onChanged: onChanged,
          style: const TextStyle(color: secondTextColour),
        ),
      ),
    );
  }
}
