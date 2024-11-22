import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/View/Authentications/lisence_request.dart';
import 'package:tactix_academy_manager/View/HomeScreen/home_screen.dart';

class UserDatbase {
  Future<void> signUpWithEmailPassword(BuildContext context, String name,
      String email, String password, String teamId) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;

      if (user != null) {
        // Storing user details in Firestore
        await FirebaseFirestore.instance
            .collection('Managers')
            .doc(user.uid)
            .set({
          'name': name.isNotEmpty ? name : 'Unknown',
          'email': email,
          'password': password,
          'teamId': teamId.isNotEmpty ? teamId : 'Not Assigned',
        });
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (ctx) => CoachingLicenseScreen()));

        log("User data stored successfully in Firestore");
      } else {
        log("Error: User creation failed, user object is null.");
      }
    } catch (e) {
      log("Error during sign-up: $e");
    }
  }

  Future<void> signupWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        log("Google sign-in canceled by user.");
        return;
      }

      log("Google User Info: ${googleUser.displayName}, ${googleUser.email}");

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('Managers')
            .doc(user.uid)
            .set({
          'name': user.displayName ?? 'Google User',
          'email': user.email,
          'password': user.photoURL,
          'teamId': 'Not Assigned',
        });
        Navigator.push(context,
            MaterialPageRoute(builder: (ctx) => CoachingLicenseScreen()));

        log("Google sign-in successful, data stored in Firestore.");
      } else {
        log("No Firebase user found after Google sign-in.");
      }
    } catch (e) {
      log("Error during Google Sign-In: $e");
    }
  }

  Future<void> signInWithEmailPassword(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController,
      TextEditingController nameController) async {
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final name = nameController.text.trim();

      // Fetch user data from Firestore
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Managers')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isEmpty) {
        // No user found with the given email
        log("No user found for the given email.");
        showSnackBar(context, "No user found for this email.");
        return;
      }

      final userDoc = snapshot.docs.first;
      final userData = userDoc.data() as Map<String, dynamic>;

      // Validate password and name
      if (userData['password'] == password && userData['name'] == name) {
        log("Sign-in successful. Navigating to HomeScreen.");

        // Navigate to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // Invalid credentials
        if (userData['password'] != password) {
          log("Invalid password.");
          showSnackBar(context, "Incorrect password.");
        } else {
          log("Invalid name.");
          showSnackBar(context, "Incorrect name.");
        }
      }
    } catch (e) {
      log("Error during sign-in: $e");
      showSnackBar(context, "An error occurred. Please try again.");
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backGroundColor,
      ),
    );
  }

  signWithGoogle(BuildContext context) async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        log("Google sign-in canceled by user.");
        return;
      }
      log("Google User Info: ${googleUser.displayName}, ${googleUser.email}");

      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        log("Firebase User: ${userCredential.user?.displayName}, ${userCredential.user?.email}");
        // Navigate to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        log("No Firebase user found.");
      }
    } catch (e) {
      log("Error during Google Sign-In: $e");
    }
  }

  Future<void> uploadLicense(String imagePath) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("No authenticated user found.");
      }

      await FirebaseFirestore.instance
          .collection('Managers')
          .doc(user.uid)
          .update({'licenseUrl': imagePath});

      log("License uploaded successfully.");
    } catch (e) {
      log("Error uploading license: $e");
    }
  }
}
