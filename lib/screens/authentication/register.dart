import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:movie_tracker/global_widgets/responsive.dart';
import 'package:movie_tracker/global_widgets/toast_block.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../global_widgets/appbar_widget.dart';
import '../../global_widgets/text_widget.dart';
import '../../models/theme.dart';
import '../../models/watch_list.dart';
import '../../network_connection/auth_services.dart';
import '../../theme/data.dart';
import 'bottom_navbar.dart';

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
    final themeController = Provider.of<ThemeController>(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight(context) * 8),
          child: const AppBarWidget(
            title: 'Movie Tracker',
            showBackButton: false,
          )),
      backgroundColor: themeController.backgroundColor,
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
                  style: TextStyle(color: themeController.textColor),
                  decoration: InputDecoration(
                    hintText: 'Name',
                    hintStyle: TextStyle(color: themeController.disabledColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: themeController.textColor,
                        width: 0.5,
                      ),
                      
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: themeController.textColor,
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: themeController.textColor,
                        width: 0.5,
                      ),
                    ),
                    
                  ),
                  cursorColor: themeController.textColor,
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
                  style: TextStyle(color: themeController.textColor),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: themeController.disabledColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: themeController.textColor,
                        width: 0.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: themeController.textColor,
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: themeController.textColor,
                        width: 0.5,
                      ),
                    ),
                  ),
                  cursorColor: themeController.textColor,
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
                  style: TextStyle(color: themeController.textColor),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: themeController.disabledColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: themeController.textColor,
                        width: 0.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: themeController.textColor,
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: themeController.textColor,
                        width: 0.5,
                      ),
                    ),
                  ),
                  cursorColor: themeController.textColor,
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
                  style: TextStyle(color: themeController.textColor),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    hintStyle: TextStyle(color: themeController.disabledColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: themeController.textColor,
                        width: 0.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: themeController.textColor,
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: themeController.textColor,
                        width: 0.5,
                      ),
                    ),
                  ),
                  cursorColor: themeController.textColor,
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
                      color: themeController.textColor,
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
                
                SizedBox(height: screenHeight(context) * 5),
                
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: themeController.backgroundColor,
        height: screenHeight(context) * 7,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth(context) * 5),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'By continuing you agree to our ',
                style: TextStyle(
                  fontSize: screenWidth(context) * 4,
                  color: themeController.textColor,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Privacy Policy',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        showPolicyOrTermsDialog(context, themeController, 'Privacy Policy', privacyPolicyText);
                      },
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Terms of Use',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        showPolicyOrTermsDialog(context, themeController, 'Terms of Use', termsOfUseText);
                      },
                  ),
                ],
              ),
            )),
      ),

    );
  }
  void showPolicyOrTermsDialog(BuildContext context, ThemeController themeController, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: themeController.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                text(title: title, fontSize: screenWidth(context) * 4, fontWeight: FontWeight.bold, color: themeController.textColor),
                SizedBox(height: screenHeight(context) * 2),
                Expanded(
                  child: SingleChildScrollView(
                    child: text(
                      // Your Privacy Policy text here
                      title: content,
                      fontSize: screenWidth(context) * 3.5,
                      textAlign: TextAlign.justify,
                      color: themeController.textColor,
                      maxLines: 1000,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: text(
                          title: 'Close',
                          fontSize: screenWidth(context) * 3.5,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        )
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String privacyPolicyText = '''
Muhammad Hamza Imran built the Movie Tracker app as a Free app. This SERVICE is provided by Muhammad Hamza Imran at no cost and is intended for use as is.

This page is used to inform visitors regarding my policies regarding the collection, use, and disclosure of Personal Information if anyone decides to use my Service.

If you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy.

The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, accessible at Movie Tracker unless otherwise defined in this Privacy Policy.

Information Collection and Use

For a better experience, while using our Service, I may require you to provide us with certain personally identifiable information. The information that I request will be retained on your device and is not collected by me in any way.

The app does use third-party services that may collect information used to identify you.

Link to the privacy policy of third-party service providers used by the app

Google Play Services
Google Analytics for Firebase
Firebase Crashlytics

Log Data

When you use my Service, in the case of an error in the app I collect data and information (through third-party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing my Service, the time and date of your use of the Service, and other statistics.

Cookies

Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device's internal memory.

This Service does not use these “cookies” explicitly. However, the app may use third-party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.

Service Providers

I may employ third-party companies and individuals due to the following reasons:

To facilitate our Service;
To provide the Service on our behalf;
To perform Service-related services; or
To assist us in analyzing how our Service is used.

I want to inform users of this Service that these third parties have access to their Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.

Security

I value your trust in providing us with your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security.

Links to Other Sites

This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that I do not operate these external sites. Therefore, I strongly advise you to review the Privacy Policy of these websites. I have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.

Children’s Privacy

These Services do not address anyone under the age of 13. I do not knowingly collect personally identifiable information from children under 13 years of age. In the case I discover that a child under 13 has provided me with personal information, I immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact me so that I will be able to take the necessary actions.

Changes to This Privacy Policy

I may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page.

This policy is effective as of 2023-11-08

Contact Us

If you have any questions or suggestions about my Privacy Policy, do not hesitate to contact me at hamzaimran.124.8@gmail.com.


''';

  String termsOfUseText = '''
By downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app. You’re not allowed to copy or modify the app, any part of the app, or our trademarks in any way. You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages or make derivative versions. The app itself, and all the trademarks, copyright, database rights, and other intellectual property rights related to it, still belong to Muhammad Hamza Imran.

Muhammad Hamza Imran is committed to ensuring that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for the app or its services without making it very clear to you exactly what you’re paying for.

The Movie Tracker app stores and processes personal data that you have provided to us, to provide my Service. It’s your responsibility to keep your phone and access to the app secure. We therefore recommend that you do not jailbreak or root your phone, which is the process of removing software restrictions and limitations imposed by the official operating system of your device. It could make your phone vulnerable to malware/viruses/malicious programs, compromise your phone’s security features and it could mean that the Movie Tracker app won’t work properly or at all.

The app does use third-party services that declare their Terms and Conditions.

Link to Terms and Conditions of third-party service providers used by the app

Google Play Services
Google Analytics for Firebase
Firebase Crashlytics

You should be aware that there are certain things that Muhammad Hamza Imran will not take responsibility for. Certain functions of the app will require the app to have an active internet connection. The connection can be Wi-Fi or provided by your mobile network provider, but Muhammad Hamza Imran cannot take responsibility for the app not working at full functionality if you don’t have access to Wi-Fi, and you don’t have any of your data allowance left.

If you’re using the app outside of an area with Wi-Fi, you should remember that the terms of the agreement with your mobile network provider will still apply. As a result, you may be charged by your mobile provider for the cost of data for the duration of the connection while accessing the app, or other third-party charges. In using the app, you’re accepting responsibility for any such charges, including roaming data charges if you use the app outside of your home territory (i.e. region or country) without turning off data roaming. If you are not the bill payer for the device on which you’re using the app, please be aware that we assume that you have received permission from the bill payer for using the app.

Along the same lines, Muhammad Hamza Imran cannot always take responsibility for the way you use the app i.e. You need to make sure that your device stays charged – if it runs out of battery and you can’t turn it on to avail the Service, Muhammad Hamza Imran cannot accept responsibility.

With respect to Muhammad Hamza Imran’s responsibility for your use of the app, when you’re using the app, it’s important to bear in mind that although we endeavor to ensure that it is updated and correct at all times, we do rely on third parties to provide information to us so that we can make it available to you. Muhammad Hamza Imran accepts no liability for any loss, direct or indirect, you experience as a result of relying wholly on this functionality of the app.

At some point, we may wish to update the app. The app is currently available on Android – the requirements for the system(and for any additional systems we decide to extend the availability of the app to) may change, and you’ll need to download the updates if you want to keep using the app. Muhammad Hamza Imran does not promise that it will always update the app so that it is relevant to you and/or works with the Android version that you have installed on your device. However, you promise to always accept updates to the application when offered to you, We may also wish to stop providing the app, and may terminate use of it at any time without giving notice of termination to you. Unless we tell you otherwise, upon any termination, (a) the rights and licenses granted to you in these terms will end; (b) you must stop using the app, and (if needed) delete it from your device.

Changes to This Terms and Conditions

I may update our Terms and Conditions from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Terms and Conditions on this page.

These terms and conditions are effective as of 2023-11-08

Contact Us

If you have any questions or suggestions about my Terms and Conditions, do not hesitate to contact me at hamzaimran.124.8@gmail.com.


  ''';
}
