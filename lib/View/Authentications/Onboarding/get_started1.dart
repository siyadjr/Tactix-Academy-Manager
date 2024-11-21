import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/View/Authentications/sign_in.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    const pageDecoration = PageDecoration(
      pageColor: backGroundColor,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.white70,
        height: 1.5, // Line height for better readability
      ),
      titlePadding: EdgeInsets.only(top: 20.0), // Top spacing for the title
      bodyPadding: EdgeInsets.symmetric(
          horizontal: 24.0), // Horizontal padding for the body text
      contentMargin:
          EdgeInsets.symmetric(horizontal: 16.0), // Overall content margin
      imagePadding: EdgeInsets.only(
          top: 40.0, bottom: 20.0), // Space between image and text
    );

    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome to Tactix Academy",
          body: "Learn, train, and master football tactics.",
          image: Center(
            child: SizedBox(
              height: 250, // Responsive height for the image
              child: Image.asset('Assets/onboarding1.png', fit: BoxFit.contain),
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Create and Manage Teams",
          body: "Easily create and organize your football teams.",
          image: Center(
            child: SizedBox(
              height: 250,
              child: Image.asset('Assets/onboarding2.png', fit: BoxFit.contain),
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Track Player Achievements",
          body: "Monitor progress, fitness, and milestones.",
          image: Center(
            child: SizedBox(
              height: 250,
              child: Image.asset(
                'Assets/fitness traking.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          decoration: pageDecoration,
        ),
      ],
      onDone: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (ctx) => SignIn()));
      },
      onSkip: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (ctx) => SignIn()));
      },
      showSkipButton: true,
      skip: const Text(
        "Skip",
        style: TextStyle(color: Colors.white),
      ),
      next: const Icon(
        Icons.arrow_right,
        color: Colors.white,
      ),
      done: const Text(
        "Get Started",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: Colors.grey.withOpacity(0.5),
        activeSize: const Size(22.0, 10.0),
        activeColor: Colors.white,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      globalBackgroundColor: backGroundColor,
    );
  }
}
