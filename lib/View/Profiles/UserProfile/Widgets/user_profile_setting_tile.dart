 import 'package:flutter/material.dart';

Widget buildSettingsTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
    bool showBorder = true,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.5),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showBorder)
          Divider(
            color: Colors.white.withOpacity(0.1),
            height: 1,
          ),
      ],
    );
  }