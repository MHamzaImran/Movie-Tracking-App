import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  // Create a variable to track user login status
  bool isLoggedIn = false;

  // Store user data (you can customize this structure)
  User? userData;

  // Constructor to initialize the authentication state
  AuthServices() {
    // Check if a user is already signed in
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        isLoggedIn = true;
        userData = user;
      } else {
        isLoggedIn = false;
        userData = null;
      }
    });
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print('googleUser: $googleUser');

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      print('googleAuth: $googleAuth');

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Sign in with Firebase
      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      // User is logged in, update the authentication state and user data
      isLoggedIn = true;
      userData = userCredential.user;

      return userCredential;
    } catch (error) {
      // Handle any errors that occur during the sign-in process
      print("Error signing in with Google: $error");
      return null; // Return null on error
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      // Sign out from Firebase Authentication
      await FirebaseAuth.instance.signOut();

      // Sign out from Google Sign-In
      await GoogleSignIn().signOut();

      // User is signed out, update the authentication state and clear user data
      isLoggedIn = false;
      userData = null;

      print('User signed out successfully.');
    } catch (error) {
      print('Error signing out: $error');
    }
  }
}
