import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Core/Theme/button_style.dart';
import 'package:tactix_academy_manager/Core/Theme/custom_scaffold.dart';
import 'package:tactix_academy_manager/Model/Firebase/Authentication%20funcations/user.db.dart';
import 'package:tactix_academy_manager/View/Authentications/Widgets/or_sign_with_google.dart';
import 'package:tactix_academy_manager/View/Authentications/Widgets/sign_in_widget.dart';
import 'package:tactix_academy_manager/View/Authentications/Widgets/to_sign_inpage.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController nameController = TextEditingController();

    final _formKey = GlobalKey<FormState>();

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
                    'Get Started !!',
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
                    passwordController: passwordController,
                  ),
                  const SizedBox(height: 20.0),
                  ValueListenableBuilder<bool>(
                    valueListenable: isLoading,
                     builder: (context, loading, child) {
                      return loading
                          ? GestureDetector(
                              onTap: () {
                                isLoading.value = false;
                              },
                              child: const CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  isLoading.value = true;
                                  await UserDatbase().signUpWithEmailPassword(
                                    context,
                                    nameController.text.trim(),
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                    '',
                                  );
                                  isLoading.value = false;
                                }
                              },
                              style: elevatedButtonStyle,
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(color: secondTextColour),
                              ),
                            );
                    },
                  ),
                  const SizedBox(height: 20.0),
                  const OrSignWIthGoogle(),
                  const SizedBox(height: 10.0),
                  IconButton(
                    onPressed: () async {
                      isLoading.value = true;
                      await UserDatbase().signupWithGoogle(context);
                      isLoading.value = false;
                    },
                    icon: Brand(Brands.google),
                    iconSize: 40.0,
                  ),
                  const SizedBox(height: 20.0),
                  const ToSignInpage(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
