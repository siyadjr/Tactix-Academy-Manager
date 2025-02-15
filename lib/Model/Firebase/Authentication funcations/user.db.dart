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
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> signUpWithEmailPassword(BuildContext context, String name,
      String email, String password, String teamId) async {
    try {
      // Check for existing manager
      final managerQuery = await _firestore
          .collection('Managers')
          .where('email', isEqualTo: email)
          .get();

      if (managerQuery.docs.isNotEmpty) {
        userId = managerQuery.docs.first.id;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (ctx) => const HomeScreen()));
        return;
      }

      // Create Firebase user
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) throw Exception('User creation failed');

      try {
        // Store user data in Firestore
        await _firestore.collection('Managers').doc(user.uid).set({
          'name': name.isNotEmpty ? name : 'Unknown',
          'email': email,
          'teamId': teamId.isNotEmpty ? teamId : 'Not Assigned',
          'licenseUrl': 'Not Assigned',
          'license status': 'Not Assigned',
          'userProfile':
              'https://res.cloudinary.com/dplpu9uc5/image/upload/v1734508378/Default_avatar_uznlbr.jpg'
        });

        userId = user.uid;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (ctx) => const CoachingLicenseScreen()));
      } catch (e) {
        // Rollback user creation if Firestore fails
        await user.delete();
        _handleError(context, e, 'Failed to create user profile');
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthError(context, e);
    } on FirebaseException catch (e) {
      _handleFirestoreError(context, e);
    } catch (e) {
      _handleGenericError(context, e);
    }
  }

  Future<void> signupWithGoogle(BuildContext context) async {
    try {
       await GoogleSignIn().signOut();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        showSnackBar(context, 'Google sign-in cancelled', Colors.orange);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) throw Exception('Google authentication failed');

      // Check existing users
      final managerDoc = await _firestore
          .collection('Managers')
          .where('email', isEqualTo: user.email)
          .get();

      if (managerDoc.docs.isNotEmpty) {
        userId = managerDoc.docs.first.id;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (ctx) => const HomeScreen()));
        return;
      }

      try {
        // Upload profile photo to Cloudinary
        final photo = await CloudineryClass()
            .uploadPhoto(user.photoURL ?? _defaultAvatarUrl);

        await _firestore.collection('Managers').doc(user.uid).set({
          'name': user.displayName ?? 'Google User',
          'email': user.email,
          'userProfile': photo,
          'teamId': 'Not Assigned',
          'licenseUrl': 'Not Assigned',
          'license status': 'Not Assigned'
        });

        SharedPrefFunctions().sharedPrefSignup();
        userId = user.uid;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (ctx) => const CoachingLicenseScreen()));
      } catch (e) {
        await _firebaseAuth.signOut();
        await GoogleSignIn().signOut();
        _handleError(context, e, 'Failed to complete Google sign-in');
      }
    } on FirebaseAuthException catch (e) {
      _handleAuthError(context, e);
    } on FirebaseException catch (e) {
      _handleFirestoreError(context, e);
    } catch (e) {
      _handleGenericError(context, e);
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

      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final snapshot = await _firestore
          .collection('Managers')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isEmpty) {
        showSnackBar(context, 'No user found for this email', Colors.red);
        return;
      }

      final userDoc = snapshot.docs.first;
      final userData = userDoc.data() as Map<String, dynamic>;

      if (userData['name'] != name) {
        showSnackBar(context, 'Incorrect name', Colors.red);
        return;
      }

      userId = userDoc.id;
      await SharedPrefFunctions().sharePrefTeamCreated();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      _handleAuthError(context, e);
    } on FirebaseException catch (e) {
      _handleFirestoreError(context, e);
    } catch (e) {
      _handleGenericError(context, e);
    }
  }

  Future<void> uploadLicense(String imagePath) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _firestore
          .collection('Managers')
          .doc(user.uid)
          .update({'licenseUrl': imagePath, 'license status': 'pending'});
    } on FirebaseException catch (e) {
      log('License upload failed: ${e.message}');
      rethrow;
    }
  }

  Future<void> uploadTeamId(String teamId) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _firestore.collection('Managers').doc(user.uid).update({
        'teamId': teamId,
      });
    } on FirebaseException catch (e) {
      log('Team ID update failed: ${e.message}');
      rethrow;
    }
  }

  Future<User?> reloadAndFetchUser() async {
    try {
      await _firebaseAuth.currentUser?.reload();
      return _firebaseAuth.currentUser;
    } on FirebaseAuthException catch (e) {
      log('User reload failed: ${e.message}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchUserData() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return null;

      final userDoc =
          await _firestore.collection('Managers').doc(user.uid).get();
      return userDoc.data();
    } on FirebaseException catch (e) {
      log('User data fetch failed: ${e.message}');
      return null;
    }
  }

  // Error handling helpers
  void _handleAuthError(BuildContext context, FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'user-not-found':
        message = 'No account found for this email';
        break;
      case 'wrong-password':
        message = 'Incorrect password';
        break;
      case 'invalid-email':
        message = 'Invalid email format';
        break;
      case 'user-disabled':
        message = 'This account has been disabled';
        break;
      case 'too-many-requests':
        message = 'Too many attempts. Try again later';
        break;
      case 'network-request-failed':
        message = 'Network error. Check your connection';
        break;
      default:
        message = 'Authentication failed Please try again';
    }
    showSnackBar(context, message, backGroundColor);
  }

  void _handleFirestoreError(BuildContext context, FirebaseException e) {
    showSnackBar(
      context,
      'Database error: ${e.message ?? 'Unknown error'}',
      Colors.orange,
    );
  }

  void _handleGenericError(BuildContext context, dynamic e) {
    log('Unexpected error: $e');
    showSnackBar(
      context,
      'An unexpected error occurred. Please try again',
      Colors.red,
    );
  }

  void _handleError(BuildContext context, dynamic e, String fallbackMessage) {
    if (e is FirebaseException) {
      _handleFirestoreError(context, e);
    } else {
      log('Error: $e');
      showSnackBar(context, fallbackMessage, Colors.red);
    }
  }

  // Universal snackbar display
  void showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static const _defaultAvatarUrl =
      'https://res.cloudinary.com/dplpu9uc5/image/upload/v1734508378/Default_avatar_uznlbr.jpg';
}
