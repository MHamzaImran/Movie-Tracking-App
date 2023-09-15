import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_tracker/global_widgets/responsive.dart';
import 'package:movie_tracker/screens/authentication/forgot_password.dart';
import 'package:movie_tracker/screens/authentication/register.dart';

import '../../global_widgets/appbar_widget.dart';
import '../../global_widgets/text_widget.dart';
import '../../network_connection/google_sign_in.dart';
import '../../theme/data.dart';
import '../home/profile/profileData.dart';
import 'bottom_narbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool googleLoading = false;

  // userAlreadyLoggedIn() async {
  //   final user = await FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => BottomNavigation(
  //           initialIndex: 0,
  //           onIndexChanged: (int value) {},
  //         ),
  //       ),
  //     );
  //   }
  // }

  @override
  void initState() {
    // userAlreadyLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight(context) * 8),
          child: const AppBarWidget(
            title: 'Movie Tracker',
          )),
      body: ListView(
        children: [
          SizedBox(height: screenHeight(context) * 3),
          text(
            title: 'Sign In',
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
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight(context) * 2),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight(context) * 2),
                // remember me and forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: screenHeight(context) * 3,
                          width: screenWidth(context) * 5,
                          child: Checkbox(
                            value: false,
                            splashRadius: 0,
                            onChanged: (value) {},
                          ),
                        ),
                        SizedBox(width: screenWidth(context) * 2),
                        text(
                          title: 'Remember me',
                          fontSize: screenWidth(context) * 3,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: text(
                        title: 'Forgot Password?',
                        fontSize: screenWidth(context) * 3,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight(context) * 5),
                SizedBox(
                  height: screenHeight(context) * 5,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomNavigation(
                            initialIndex: 0,
                            onIndexChanged: (int value) {},
                          ),
                        ),
                      );
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
                    child: text(
                      title: 'Sign In',
                      fontSize: screenWidth(context) * 3.5,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight(context) * 2),
                // or
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 1,
                      width: screenWidth(context) * 40,
                      color: AppTheme.lightPrimaryColor,
                    ),
                    SizedBox(width: screenWidth(context) * 2),
                    text(
                      title: 'OR',
                      fontSize: screenWidth(context) * 3,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(width: screenWidth(context) * 2),
                    Container(
                      height: 1,
                      width: screenWidth(context) * 40,
                      color: AppTheme.lightPrimaryColor,
                    ),
                  ],
                ),
                SizedBox(height: screenHeight(context) * 2),

                // sign with google
                SizedBox(
                  height: screenHeight(context) * 5,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        setState(() {
                          googleLoading = true;
                        });
                        // await GoogleSignInProvider().logout();
                        final userCredential =
                            await GoogleSignInProvider().login();
                        if (userCredential != null) {
                          // Access the user's profile data
                          final profile =
                              userCredential.additionalUserInfo?.profile;
                          final pictureUrl = profile['picture'];
                          final email = userCredential.user.email;
                          final name = userCredential.user.displayName;
                          final profileCubit = context.read<ProfileCubit>();
                          profileCubit.setUserProfile(
                            UserProfile(
                              name: name,
                              email: email,
                              profileUrl: pictureUrl,
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BottomNavigation(
                                initialIndex: 0,
                                onIndexChanged: (int value) {},
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        print('Error in google sign in: $e');
                      } finally {
                        setState(() {
                          googleLoading = false;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      minimumSize: Size(
                        screenWidth(context) * 90,
                        screenHeight(context) * 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: googleLoading
                        ? Padding(
                            padding: EdgeInsets.all(screenWidth(context) * 2),
                            child: const CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/google_icon.png',
                                height: screenHeight(context) * 3,
                                width: screenWidth(context) * 5,
                              ),
                              SizedBox(width: screenWidth(context) * 2),
                              text(
                                title: 'Sign in with Google',
                                fontSize: screenWidth(context) * 3.5,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ],
                          ),
                  ),
                ),
                // SizedBox(height: screenHeight(context) * 5),
                // SizedBox(
                //   height: screenHeight(context) * 5,
                //   child: ElevatedButton(
                //     onPressed: () async {
                //       await GoogleSignInProvider().login();
                //       print('Logged out');
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.grey[300],
                //       minimumSize: Size(
                //         screenWidth(context) * 90,
                //         screenHeight(context) * 6,
                //       ),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         // Image.asset(
                //         //   'assets/images/google.png',
                //         //   height: screenHeight(context) * 3,
                //         //   width: screenWidth(context) * 5,
                //         // ),
                //         SizedBox(width: screenWidth(context) * 2),
                //         text(
                //           title: 'Logout',
                //           fontSize: screenWidth(context) * 3.5,
                //           fontWeight: FontWeight.w400,
                //           color: Colors.black,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
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
                      title: 'New to Movie Tracker?',
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
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
                      title: 'Create Account',
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
