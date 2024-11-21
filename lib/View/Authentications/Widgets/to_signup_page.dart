import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/View/Authentications/sign_up.dart';

class ToSignUpPage extends StatelessWidget {
  const ToSignUpPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Don\'t have an account?',
          style: TextStyle(color: secondTextColour),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (ctx)=>SignUp()));
          },
          child: const Text(
            'Sign Up',
            style: TextStyle(color: mainTextColour),
          ),
        ),
      ],
    );
  }
}
