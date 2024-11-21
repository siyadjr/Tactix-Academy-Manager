import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/View/Authentications/sign_in.dart';

class ToSignInpage extends StatelessWidget {
  const ToSignInpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account?',
          style: TextStyle(color: secondTextColour),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (ctx) => SignIn()),
              (route) => true,
            );
          },
          child: const Text(
            'Sign In',
            style: TextStyle(color: mainTextColour),
          ),
        ),
      ],
    );
  }
}
