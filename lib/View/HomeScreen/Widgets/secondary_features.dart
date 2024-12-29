import 'package:flutter/material.dart';

class SecondaryFeatureHomeScreen extends StatelessWidget {
  MaterialColor color1;

  String text;
  Icon icon;
  SecondaryFeatureHomeScreen({
    super.key,
    required this.text,
    required this.icon,
    required this.color1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 50,
            width: 120,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [color1, Colors.black]),
                borderRadius: BorderRadius.circular(12)),
            child: Center(child: icon)),
        Text(text)
      ],
    );
  }
}
