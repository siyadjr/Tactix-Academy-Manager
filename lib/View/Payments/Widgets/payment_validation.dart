import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';

class PaymentValidationMessage extends StatelessWidget {final String message;
  const PaymentValidationMessage({super.key,required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: FadeIn(
        child:  Text(
         message,
          style: TextStyle(
            color: mainTextColour2,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
