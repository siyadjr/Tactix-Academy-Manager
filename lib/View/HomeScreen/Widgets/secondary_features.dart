import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tactix_academy_manager/View/Tactix-AI/tactix_ai_screen.dart';

class SecondaryFeatureHomeScreen extends StatelessWidget {
  MaterialColor color1;
  Widget nextPage;
  String? image;
  String text;
  Icon icon;
  SecondaryFeatureHomeScreen({
    super.key,
    required this.text,
    required this.icon,
    this.image,
    required this.nextPage,
    required this.color1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (ctx) => nextPage));
          },
          child: Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [color1, Colors.black]),
                  borderRadius: BorderRadius.circular(12)),
              child: Center(
                  child: image == null
                      ? icon
                      : Image.asset(
                          image!,
                          fit: BoxFit.fill,
                        ))),
        ),
        Text(text)
      ],
    );
  }
}
