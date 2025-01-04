import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';

class OrSignWIthGoogle extends StatelessWidget {
  const OrSignWIthGoogle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            color: secondTextColour,
            thickness: 0.5,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Or sign In with',
            style: TextStyle(color: secondTextColour),
          ),
        ),
        Expanded(
          child: Divider(
            color: secondTextColour,
            thickness: 0.5,
          ),
        ),
      ],
    );
  }
}
