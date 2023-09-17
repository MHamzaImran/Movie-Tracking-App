import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../global_widgets/toast_block.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
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

      // Store user data in Firestore
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': userCredential.user!.email,
        // Add other user data as needed
      });
      
      await createWatchListCollectionIfNotExists(userCredential.user!.uid);

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

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      // User is logged in, update the authentication state and user data
      isLoggedIn = true;
      userData = userCredential.user;

      // Store user data in Firestore
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': userCredential.user!.email,
        // Add other user data as needed
      });

      await createWatchListCollectionIfNotExists(userCredential.user!.uid);

      return userCredential;
    } catch (error) {
      // Handle errors
      print("Error signing in with email/password: $error");
      toastBlock('Invalid email or password');
      return null;
    }
  }

  // Register a new user with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // If registration is successful, userCredential will contain user information.
      final User? user = userCredential.user;
      if (user != null) {
        // User registered successfully.
        print('User registered: ${user.uid}');
      } else {}
    } catch (e) {
      // Use a regular expression to extract the message inside square brackets
      RegExp regExp = RegExp(r'\[.*\] (.*)');
      Match? match = regExp.firstMatch(e.toString());

      if (match != null && match.groupCount >= 1) {
        String extractedMessage = match.group(1)!;
        toastBlock(extractedMessage);
      } else {
        toastBlock('User registration failed.');
      }
    }
  }

  // Store user data in Firestore
  Future<void> storeUserDataInFirestore(
      String uid, String displayName, String email, String photoURL) async {
    try {
      // Reference to Firestore collection
      final userCollection = FirebaseFirestore.instance.collection('users');

      // Create a document for the user using their UID
      await userCollection.doc(uid).set({
        'displayName': displayName,
        'email': email,
        'photoURL': photoURL,
        // Add more user data as needed
      });

      print('User data stored in Firestore.');
    } catch (error) {
      print('Error storing user data in Firestore: $error');
    }
  }

  Future<void> createWatchListCollectionIfNotExists(String userId) async {
    final collectionRef = FirebaseFirestore.instance.collection('watchList');

    final docSnapshot = await collectionRef.doc(userId).get();

    if (!docSnapshot.exists) {
      // Collection doesn't exist, create it
      await collectionRef.doc(userId).set({});
    }
  }
  
}
