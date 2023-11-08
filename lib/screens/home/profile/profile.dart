import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_tracker/global_widgets/responsive.dart';
import 'package:movie_tracker/global_widgets/toast_block.dart';
import 'package:movie_tracker/models/watch_list.dart';
import 'package:movie_tracker/network_connection/watchList_table.dart';
import 'package:movie_tracker/screens/home/profile/watch_list.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../global_widgets/appbar_widget.dart';
import '../../../global_widgets/text_widget.dart';
import '../../../models/theme.dart';
import '../../../network_connection/google_sign_in.dart';
import 'edit.dart';

List<MovieItem> watchList = [];

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userId = '';
  String name = '';
  String email = '';
  String profileUrl = '';
  bool isLoading = false;

  Future<void> retrieveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String tempId = prefs.getString('userId') ?? '';
    final collectionRef =
        FirebaseFirestore.instance.collection('users').doc(tempId);
    var profileInfo = await collectionRef.get();
    if (profileInfo.data() == null) {
      return;
    }
    setState(() {
      userId = tempId;
      name = profileInfo.data()!['displayName'] ?? 'Guest User';
      profileUrl = profileInfo.data()!['photoURL'] ?? '';
      email = profileInfo.data()!['email'] ?? '';
    });
  }

  @override
  void initState() {
    retrieveUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final watchListModel = Provider.of<Watchlist>(context);
    final themeController = Provider.of<ThemeController>(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight(context) * 8),
          child: const AppBarWidget(
            title: 'Profile',
            centerTitle: false,
          )),
      backgroundColor: themeController.backgroundColor,
      body: ListView(
        children: [
          SizedBox(
            height: screenHeight(context) * 27,
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight(context) * 2,
                ),
                SizedBox(
                  height: screenWidth(context) * 30,
                  width: screenWidth(context) * 30,
                  child: Card(
                    color: themeController.backgroundColor,
                    // color: AppTheme.lightPrimaryColor,
                    elevation: 0,
                    child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(1000), // Same radius as Card
                        child: profileUrl.isEmpty || profileUrl == 'null'
                            ? Image.asset(
                                'assets/profile.png',
                                fit: BoxFit.cover,
                              )
                            : profileUrl.contains('http')
                                ? Image.network(profileUrl)
                                : Image.memory(
                                    base64Decode(profileUrl),
                                    fit: BoxFit.cover,
                                  )),
                  ),
                ),
                SizedBox(
                  height: screenHeight(context) * 2,
                ),
                text(
                    title: name == '' ? 'Guest User' : name,
                    color: themeController.textColor,
                    fontSize: screenWidth(context) * 4,
                    fontWeight: FontWeight.bold),
                SizedBox(height: screenHeight(context) * 2),
                text(
                  title: email,
                  color: themeController.textColor,
                  fontSize: screenWidth(context) * 3.5,
                ),
                // SizedBox(height: screenHeight(context) * 5),
              ],
            ),
          ),
          Container(
            height: 1,
            width: screenWidth(context) * 100,
            color: Colors.grey.withOpacity(0.5),
          ),
          SizedBox(height: screenHeight(context) * 2),
          tile(context, themeController, icon: Icons.person, title: 'Profile',
              onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditProfile(
                          userId: userId,
                          name: name,
                          email: email,
                          profilePic: profileUrl,
                        ))).then((value) => retrieveUserData());
          }),
          tile(context, themeController,
              icon: Icons.brightness_6, title: 'Theme', onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: themeController.cardColor,
                    title: text(
                      title: 'Choose Theme',
                      fontSize: screenWidth(context) * 4,
                      fontWeight: FontWeight.bold,
                      color: themeController.textColor,
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          onTap: () async {
                            themeController.setLightTheme();
                            Navigator.pop(context);
                          },
                          title: text(
                            title: 'Light',
                            fontSize: screenWidth(context) * 4,
                            fontWeight: FontWeight.bold,
                            color: themeController.textColor,
                          ),
                          trailing: Icon(
                            Icons.wb_sunny,
                            color: themeController.textColor,
                          ),
                        ),
                        ListTile(
                          onTap: () async {
                            // final prefs =
                            //     await SharedPreferences.getInstance();
                            // prefs.setBool('isDark', true);
                            // Navigator.pop(context);
                            // setState(() {});
                            themeController.setDarkTheme();
                            Navigator.pop(context);
                          },
                          title: text(
                            title: 'Dark',
                            fontSize: screenWidth(context) * 4,
                            fontWeight: FontWeight.bold,
                            color: themeController.textColor,
                          ),
                          trailing: Icon(
                            Icons.nightlight_round,
                            color: themeController.textColor,
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }),
          tile(context, themeController,
              icon: Icons.favorite, title: 'Watchlist', onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WatchListScreen(),
              ),
            );
          }),
          tile(context, themeController,
              icon: Icons.delete_forever, title: 'Delete Account', onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: themeController.cardColor,
                    title: text(
                      title: 'Delete Account',
                      fontSize: screenWidth(context) * 4,
                      fontWeight: FontWeight.bold,
                      color: themeController.textColor,
                    ),
                    content: text(
                        title: 'Are you sure you want to delete your account?',
                        fontSize: screenWidth(context) * 4,
                        fontWeight: FontWeight.bold,
                        color: themeController.textColor,
                        maxLines: 3),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: text(
                          title: 'Cancel',
                          color: Colors.white,
                          fontSize: screenWidth(context) * 3,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await deleteAccount();
                            // clear shared preferences
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.clear();
                            watchListModel.removeAll();
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.of(context, rootNavigator: true).pop();
                          } catch (e) {
                            print(e);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: text(
                          title: 'Delete',
                          color: Colors.white,
                          fontSize: screenWidth(context) * 3,
                        ),
                      ),
                    ],
                  );
                });
          }),
          tile(context, themeController,
              icon: Icons.description,
              title: 'Terms & Conditions',
              onTap: () => showPolicyOrTermsDialog(
                  context, themeController, 'Terms of Use', termsOfUseText)),
          tile(context, themeController,
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              onTap: () => showPolicyOrTermsDialog(context, themeController,
                  'Privacy Policy', privacyPolicyText)),
          tile(context, themeController, icon: Icons.logout, title: 'Logout',
              onTap: () async {
            try {
              setState(() {
                isLoading = true;
              });
              await GoogleSignInProvider().logout();
              await FirebaseAuth.instance.signOut();
            } catch (e) {
              print(e);
            } finally {
              Navigator.of(context, rootNavigator: true).pop();
              // remove shared preferences data
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              watchListModel.removeAll();
              setState(() {
                isLoading = false;
              });
            }
          }),
          SizedBox(height: screenHeight(context) * 8),
        ],
      ),
    );
  }

  tile(BuildContext context, ThemeController themeController,
      {required IconData icon,
      required String title,
      required Function onTap}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth(context) * 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: themeController.isDarkMode
                    ? themeController.textColor
                    : themeController.primaryColor,
                radius: screenWidth(context) * 5,
                child: Icon(
                  icon,
                  size: screenWidth(context) * 5,
                  color: themeController.backgroundColor,
                ),
              ),
              SizedBox(width: screenWidth(context) * 3),
              text(
                title: title,
                fontSize: screenWidth(context) * 3.5,
                fontWeight: FontWeight.w500,
                color: themeController.textColor,
              ),
              const Spacer(),
              InkWell(
                  onTap: () => onTap(),
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: SizedBox(
                    height: screenHeight(context) * 5,
                    width: screenWidth(context) * 10,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: screenWidth(context) * 4,
                        color: themeController.textColor,
                      ),
                    ),
                  )),
            ],
          ),
        ),
        SizedBox(height: screenHeight(context) * 2),
      ],
    );
  }

  deleteAccount() async {
    try {
      // Delete user from Firebase Authentication
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
      }
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user?.uid);
      final userDocSnapshot = await userDoc.get();
      if (userDocSnapshot.exists) {
        await userDoc.delete();
        toastBlock('Account deleted successfully.');
      }
    } catch (e) {
      toastBlock('Please login again to delete your account.');
    }
  }

  void showPolicyOrTermsDialog(BuildContext context,
      ThemeController themeController, String title, String content) {
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
                text(
                    title: title,
                    fontSize: screenWidth(context) * 4,
                    fontWeight: FontWeight.bold,
                    color: themeController.textColor),
                SizedBox(height: screenHeight(context) * 2),
                Expanded(
                  child: SingleChildScrollView(
                    child: text(
                      // Your Privacy Policy text here
                      title: content,
                      fontSize: screenWidth(context) * 3.5,
                      textAlign: TextAlign.justify,
                      color: themeController.disabledColor,
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
                          color: themeController.textColor,
                        )),
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
