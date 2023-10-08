import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_tracker/global_widgets/responsive.dart';
import 'package:movie_tracker/global_widgets/toast_block.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../global_widgets/appbar_widget.dart';
import '../../global_widgets/text_widget.dart';
import '../../models/watch_list.dart';
import '../../network_connection/auth_services.dart';
import '../../theme/data.dart';
import 'bottom_narbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  String nameErrorMessage = '';
  TextEditingController emailController = TextEditingController();
  String emailErrorMessage = '';
  TextEditingController passwordController = TextEditingController();
  String passwordErrorMessage = '';
  TextEditingController confirmPasswordController = TextEditingController();
  String confirmPasswordErrorMessage = '';
  bool nameIsValid = false;
  bool emailIsValid = false;
  bool passwordIsValid = false;
  bool confirmPasswordIsValid = false;

  bool isLoading = false;

  nameValidation() {
    if (nameController.text.isEmpty) {
      setState(() {
        nameErrorMessage = 'Name is required';
        nameIsValid = false;
      });
    }else{
      setState(() {
        nameErrorMessage = '';
        nameIsValid = true;
      });
    }
  }

  emailValidation() {
    if (emailController.text.isEmpty) {
      setState(() {
        emailErrorMessage = 'Email is required';
        emailIsValid = false;
      });
    } else if (!emailController.text.contains('@')) {
      setState(() {
        emailErrorMessage = 'Email is invalid';
        emailIsValid = false;
      });
    } else if (emailController.text.contains(' ')) {
      setState(() {
        emailErrorMessage = 'Email is invalid';
        emailIsValid = false;
      });
    } else {
      setState(() {
        emailErrorMessage = '';
        emailIsValid = true;
      });
    }
  }

  passwordValidation() {
    if (passwordController.text.isEmpty) {
      setState(() {
        passwordErrorMessage = 'Password is required';
        passwordIsValid = false;
      });
    } else if (passwordController.text.length < 6) {
      setState(() {
        passwordErrorMessage = 'Password must be at least 6 characters';
        passwordIsValid = false;
      });
    } else {
      setState(() {
        passwordErrorMessage = '';
        passwordIsValid = true;
      });
    }
  }

  confirmPasswordValidation() {
    if (confirmPasswordController.text.isEmpty) {
      setState(() {
        confirmPasswordErrorMessage = 'Confirm Password is required';
        confirmPasswordIsValid = false;
      });
    } else if (confirmPasswordController.text != passwordController.text) {
      setState(() {
        confirmPasswordErrorMessage =
            'Confirm Password must be same as Password';
        confirmPasswordIsValid = false;
      });
    } else {
      setState(() {
        confirmPasswordErrorMessage = '';
        confirmPasswordIsValid = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final watchListModel = Provider.of<Watchlist>(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight(context) * 8),
          child: const AppBarWidget(
            title: 'Movie Tracker',
            showBackButton: false,
          )),
      body: ListView(
        children: [
          SizedBox(height: screenHeight(context) * 3),
          text(
            title: 'Sign Up',
            fontSize: screenWidth(context) * 4,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight(context) * 3),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth(context) * 5),
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    nameValidation();
                  },
                ),
                if (nameErrorMessage.isNotEmpty)
                  Column(
                    children: [
                      SizedBox(height: screenHeight(context) * 1),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: text(
                          title: nameErrorMessage,
                          fontSize: screenWidth(context) * 3,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: screenHeight(context) * 2),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    emailValidation();
                  },
                ),
                if (emailErrorMessage.isNotEmpty)
                  Column(
                    children: [
                      SizedBox(height: screenHeight(context) * 1),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: text(
                          title: emailErrorMessage,
                          fontSize: screenWidth(context) * 3,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: screenHeight(context) * 2),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    passwordValidation();
                  },
                ),
                if (passwordErrorMessage.isNotEmpty)
                  Column(
                    children: [
                      SizedBox(height: screenHeight(context) * 1),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: text(
                          title: passwordErrorMessage,
                          fontSize: screenWidth(context) * 3,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: screenHeight(context) * 2),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    confirmPasswordValidation();
                  },
                ),
                if (confirmPasswordErrorMessage.isNotEmpty)
                  Column(
                    children: [
                      SizedBox(height: screenHeight(context) * 1),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: text(
                          title: confirmPasswordErrorMessage,
                          fontSize: screenWidth(context) * 3,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: screenHeight(context) * 5),
                SizedBox(
                  height: screenHeight(context) * 5,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (nameIsValid &&
                          emailIsValid &&
                          passwordIsValid &&
                          confirmPasswordIsValid) {
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          FocusScope.of(context).unfocus();
                          final AuthServices authService = AuthServices();
                          // Sign in with email and password
                          final UserCredential? userCredential =
                              await authService.registerWithEmailAndPassword(
                                nameController.text,
                            emailController.text,
                            passwordController.text,
                          );
                          if (userCredential != null) {
                            // Authentication successful
                            // Redirect or perform actions after successful login
                            toastBlock('User registered successfully');
                            watchListModel.updateListFromApi();
                            if (!mounted) return;
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BottomNavigation(
                                  initialIndex: 0,
                                  onIndexChanged: (int value) {},
                                ),
                              ),
                            );

                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString(
                                'userId', userCredential.user!.uid);
                            await prefs.setString('name',
                                userCredential.user!.displayName.toString());
                            await prefs.setString('profileUrl',
                                userCredential.user!.photoURL.toString());
                            await prefs.setString(
                                'email', userCredential.user!.email.toString());
                          }
                        } catch (e) {
                          print(e);
                        } finally {
                          setState(() {
                            isLoading = false;
                            emailIsValid = false;
                            passwordIsValid = false;
                            confirmPasswordIsValid = false;
                          });
                          emailController.clear();
                          passwordController.clear();
                          confirmPasswordController.clear();
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightPrimaryColor,
                      minimumSize: Size(
                        screenWidth(context) * 90,
                        screenHeight(context) * 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading
                        ? Padding(
                            padding: EdgeInsets.all(screenWidth(context) * 1),
                            child: const CircularProgressIndicator(
                              strokeWidth: 1,
                              color: Colors.black,
                            ),
                          )
                        : text(
                            title: 'Create Account',
                            fontSize: screenWidth(context) * 3.5,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                  ),
                ),
                SizedBox(height: screenHeight(context) * 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // horizontal line
                    Container(
                      height: screenHeight(context) * 0.2,
                      width: screenWidth(context) * 22,
                      color: AppTheme.lightPrimaryColor,
                    ),
                    text(
                      title: 'Already have an Account?',
                      fontSize: screenWidth(context) * 3,
                      fontWeight: FontWeight.w400,
                    ),
                    // horizontal line
                    Container(
                      height: screenHeight(context) * 0.2,
                      width: screenWidth(context) * 22,
                      color: AppTheme.lightPrimaryColor,
                    ),
                  ],
                ),
                SizedBox(height: screenHeight(context) * 5),
                SizedBox(
                  height: screenHeight(context) * 5,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: Size(
                        screenWidth(context) * 90,
                        screenHeight(context) * 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: text(
                      title: 'Login',
                      fontSize: screenWidth(context) * 3.5,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
