import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Core/Theme/button_style.dart';
import 'package:tactix_academy_manager/Core/Theme/custom_scaffold.dart';
import 'package:tactix_academy_manager/Model/Firebase/Authentication%20funcations/user.db.dart';
import 'package:tactix_academy_manager/View/Authentications/Widgets/or_sign_with_google.dart';
import 'package:tactix_academy_manager/View/Authentications/Widgets/sign_in_widget.dart';
import 'package:tactix_academy_manager/View/Authentications/Widgets/to_signup_page.dart';
import 'package:tactix_academy_manager/View/HomeScreen/home_screen.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome Back !!',
                    style: TextStyle(
                      color: mainTextColour,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  SignInWidget(
                      nameController: nameController,
                      formKey: _formKey,
                      emailController: emailController,
                      passwordController: passwordController),
                  const SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: mainTextColour),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        await UserDatbase().signInWithEmailPassword(
                            context,
                            emailController,
                            passwordController,
                            nameController);
                      }
                    },
                    style: elevatedButtonStyle,
                    child: const Text(
                      'Sign in',
                      style: TextStyle(color: secondTextColour),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const OrSignWIthGoogle(),
                  const SizedBox(height: 10.0),
                  IconButton(
                    onPressed: () {
                      UserDatbase().signWithGoogle(context);
                    },
                    icon: Brand(Brands.google),
                    iconSize: 40.0,
                  ),
                  const SizedBox(height: 20.0),
                  const ToSignUpPage(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
