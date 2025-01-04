import 'package:flutter/material.dart';

class BroadcastErrorMessage extends StatelessWidget {
  const BroadcastErrorMessage({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: Colors.red[300], fontSize: 16),
          ),
        ],
      ),
    );
  }
}


