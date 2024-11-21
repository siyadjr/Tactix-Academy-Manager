import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/View/Authentications/Widgets/custom_textFormField.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final TextEditingController emailController;

  final TextEditingController passwordController;
  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextFormField(
            controller: nameController,
            labelText: 'Name',
            hintText: 'Enter your name',
            keyboardType: TextInputType.emailAddress,
            validator: (name) {
              if (name == null || name.isEmpty) {
                return 'Please enter an name';
              }

              return null;
            },
          ),
          const SizedBox(height: 10),
          CustomTextFormField(
            controller: emailController,
            labelText: 'Email',
            hintText: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            validator: (email) {
              if (email == null || email.isEmpty) {
                return 'Please enter an email';
              }
              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(email)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 10.0),
          CustomTextFormField(
            controller: passwordController,
            labelText: 'Password',
            hintText: 'Enter your password',
            obscureText: true,
            validator: (password) {
              if (password == null || password.isEmpty) {
                return 'Please enter a password';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
