import 'package:flutter/material.dart';
import 'package:movie_tracker/global_widgets/responsive.dart';
import 'package:movie_tracker/screens/authentication/forgot_password.dart';
import 'package:movie_tracker/screens/authentication/register.dart';

import '../../global_widgets/appbar_widget.dart';
import '../../global_widgets/text_widget.dart';
import '../../theme/data.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                    onPressed: () {},
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
