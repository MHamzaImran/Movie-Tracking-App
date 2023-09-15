import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  bool _isSigningIn = false;

  GoogleSignInProvider() {
    _isSigningIn = false;
  }

  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  Future<User?> checkIfLoggedIn() async {
    return FirebaseAuth.instance.currentUser;
  }

  // Store user data in SharedPreferences
  Future<void> storeUserData(User? user) async {
    final prefs = await SharedPreferences.getInstance();
    if (user != null) {
      final userData = {
        'name': user.displayName,
        'email': user.email,
        'profileUrl': user.photoURL,
      };
      await prefs.setString('userData', jsonEncode(userData));
    } else {
      await prefs.remove('userData');
    }
  }

  // Retrieve user data from SharedPreferences
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');
    if (userDataString != null) {
      return jsonDecode(userDataString);
    }
    return null;
  }

  Future login() async {
    isSigningIn = true;

    final user = await googleSignIn.signIn();
    if (user == null) {
      isSigningIn = false;
      return;
    } else {
      final googleAuth = await user.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      return await FirebaseAuth.instance.signInWithCredential(credential);

      isSigningIn = false;
    }
  }

  logout() async {
    await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();

    // Remove user data from SharedPreferences
    await storeUserData(null);
  }
}
