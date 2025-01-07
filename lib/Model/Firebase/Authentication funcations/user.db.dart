import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tactix_academy_manager/Controller/Api/cloudinery_class.dart';
import 'package:tactix_academy_manager/Core/SharedPrefernce/shared_pref_functions.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Core/important_data.dart';

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
        await FirebaseFirestore.instance
            .collection('Managers')
            .doc(user.uid)
            .set({
          'name': name.isNotEmpty ? name : 'Unknown',
          'email': email,
          'teamId': teamId.isNotEmpty ? teamId : 'Not Assigned',
          'licenseUrl': 'Not Assigned',
          'license status': 'Not Assigned',
          'userProfile':
              'https://res.cloudinary.com/dplpu9uc5/image/upload/v1734508378/Default_avatar_uznlbr.jpg'
        });

        log("User data stored successfully in Firestore");

        userId = user.uid;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (ctx) => const CoachingLicenseScreen()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        log("Email already in use.");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Email already in use."),
          backgroundColor: Colors.red,
        ));
      } else {
        log("FirebaseAuthException: $e");
        showSnackBar(context, " Please try again");
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
        final photo = await CloudineryClass().uploadPhoto(user.photoURL!);
        await FirebaseFirestore.instance
            .collection('Managers')
            .doc(user.uid)
            .set({
          'name': user.displayName ?? 'Google User',
          'email': user.email,
          'password': user.photoURL,
          'userProfile': photo,
          'teamId': 'Not Assigned',
          'licenseUrl': 'Not Assigned',
          'license status': 'Not Assigned'
        });
        SharedPrefFunctions().sharedPrefSignup();
        userId = user.uid;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (ctx) => const CoachingLicenseScreen()));

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

      // Firebase Authentication: Sign in with email and password
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Fetch user data from Firestore to match the name (optional, if required)
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

      // Check if the name matches (optional, if required)
      if (userData['name'] == name) {
        log("Sign-in successful. Navigating to HomeScreen.");
        SharedPrefFunctions().sharedPrefSignup();
        // Navigate to HomeScreen
        userId = userDoc.id;
        await SharedPrefFunctions().sharePrefTeamCreated();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        log("Invalid name.");
        showSnackBar(context, "Incorrect name.");
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Authentication errors
      if (e.code == 'user-not-found') {
        log("No user found for the given email.");
        showSnackBar(context, "No user found for this email.");
      } else if (e.code == 'wrong-password') {
        log("Incorrect password.");
        showSnackBar(context, "Incorrect password.");
      } else {
        log("Error during sign-in: $e");
        showSnackBar(context, "Some issue is there. Please try again.");
      }
    } catch (e) {
      // Catch any other errors
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
        await SharedPrefFunctions().sharePrefTeamCreated();
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
          .update({'licenseUrl': imagePath, 'license status': 'pending'});

      log("License uploaded successfully.");
    } catch (e) {
      log("Error uploading license: $e");
    }
  }

  Future<String?> getUserDocId() async {
    try {
      // Get the current user from FirebaseAuth
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Fetch the document reference using the user's uid (user.uid)
        final userDoc = await FirebaseFirestore.instance
            .collection(
                'Managers') // Or use 'users' or whichever collection you store user data in
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          // If the document exists, return the document ID
          log('gottttttttttttttt');
          return userDoc.id;
        } else {
          print("User document not found");
          return null;
        }
      } else {
        print("No user logged in");
        return null;
      }
    } catch (e) {
      print("Error fetching user document ID: $e");
      return null;
    }
  }
//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>upload team id

  Future<void> uploadTeamId(String teamId) async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('Managers')
        .doc(user!.uid)
        .update({
      'teamId': teamId, // Update the teamId field with the passed parameter
    });
  }

  Future<User?> reloadAndFetchUser() async {
    await FirebaseAuth.instance.currentUser?.reload(); // Reload the user data
    return FirebaseAuth.instance.currentUser; // Get the updated user
  }

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Fetching User Data>>>>>>>>>>>>>>>>>>>>>>>>>

  Future<Map<String, dynamic>?> fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      // Check if user is null (not authenticated)
      if (user == null) {
        log('No authenticated user found.');
        return null;
      }

      // Fetch the user document from Firestore using the UID
      final userDoc = await FirebaseFirestore.instance
          .collection(
              'users') // Replace 'users' with your Firestore collection name
          .doc(user.uid)
          .get();

      // Check if the user document exists
      if (!userDoc.exists) {
        log('User document does not exist in Firestore.');
        return null;
      }

      // Get the user data as a map
      final userData = userDoc.data();
      log('Fetched user data: $userData');

      // Return the user data
      return userData;
    } catch (e) {
      log('Error fetching user data: $e');
      return null;
    }
  }
}
