import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_tracker/global_widgets/responsive.dart';
import 'package:movie_tracker/models/watch_list.dart';
import 'package:movie_tracker/network_connection/watchList_table.dart';
import 'package:movie_tracker/screens/home/profile/watch_list.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../global_widgets/appbar_widget.dart';
import '../../../global_widgets/text_widget.dart';
import '../../../models/theme.dart';
import '../../../network_connection/google_sign_in.dart';
import '../../../theme/data.dart';
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth(context) * 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // icon
                Icon(
                  Icons.account_circle,
                  size: screenWidth(context) * 7,
                  color: themeController.textColor,
                ),
                SizedBox(width: screenWidth(context) * 5),
                text(
                  title: 'Edit Profile',
                  fontSize: screenWidth(context) * 3.5,
                  fontWeight: FontWeight.w500,
                  color: themeController.textColor,
                ),
                const Spacer(),
                InkWell(
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
                    },
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: screenWidth(context) * 4,
                      color: themeController.textColor,
                    )),
              ],
            ),
          ),
          SizedBox(height: screenHeight(context) * 2),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth(context) * 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // dark or light mode
                Icon(
                  Icons.brightness_6,
                  size: screenWidth(context) * 7,
                  color: themeController.textColor,
                ),
                SizedBox(width: screenWidth(context) * 5),
                text(
                  title: 'Theme',
                  fontSize: screenWidth(context) * 3.5,
                  fontWeight: FontWeight.w500,
                  color: themeController.textColor,
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
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
                                      fontWeight: FontWeight.bold,color: themeController.textColor,),
                                  trailing: Icon(Icons.nightlight_round,color: themeController.textColor,),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: screenWidth(context) * 4,
                    color: themeController.textColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight(context) * 2),
          section(context, 'Watchlist', watchListModel, themeController),
          if (watchListModel.itemCount > 0)
            SizedBox(height: screenHeight(context) * 3),
          Container(
            width: double.infinity,
            height: screenHeight(context) * 5,
            margin: EdgeInsets.symmetric(horizontal: screenWidth(context) * 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black),
            ),
            child: ElevatedButton(
              onPressed: () async {
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
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: isLoading
                  ? Padding(
                      padding: EdgeInsets.all(
                        screenWidth(context) * 1,
                      ),
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 1,
                      ),
                    )
                  : text(
                      title: 'Logout',
                      color: Colors.white,
                      fontSize: screenWidth(context) * 3,
                    ),
            ),
          ),
          SizedBox(height: screenHeight(context) * 8),
        ],
      ),
    );
  }

  section(BuildContext context, String title, Watchlist watchListModel,
      themeController) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth(context) * 5),
          child: Row(
            children: [
              // icon
              Icon(Icons.favorite,
                  size: screenWidth(context) * 7,
                  color: themeController.textColor),
              SizedBox(width: screenWidth(context) * 5),
              text(
                title: title,
                fontSize: screenWidth(context) * 3.5,
                fontWeight: FontWeight.w500,
                color: themeController.textColor,
              ),
              const Spacer(),
              InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WatchListScreen(),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: screenWidth(context) * 4,
                    color: themeController.textColor,
                  )),
            ],
          ),
        ),
        SizedBox(height: screenHeight(context) * 2),
        if (watchListModel.itemCount > 0)
          Container(
            height: screenHeight(context) * 25,
            margin: EdgeInsets.symmetric(horizontal: screenWidth(context) * 5),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (var i = 0; i < watchListModel.itemCount; i++)
                  GestureDetector(
                    onTap: () {},
                    child: SizedBox(
                      width: screenWidth(context) * 30,
                      child: Padding(
                        padding:
                            EdgeInsets.only(right: screenWidth(context) * 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              "https://image.tmdb.org/t/p/w500${watchListModel.getWatchlist[i].posterPath}",
                              height: screenHeight(context) * 20,
                              // width: screenWidth(context) * 40,
                              fit: BoxFit.fitHeight,
                            ),
                            SizedBox(height: screenWidth(context) * 2),
                            text(
                              title: watchListModel.getWatchlist[i].movieTitle,
                              fontSize: screenWidth(context) * 3.5,
                              fontWeight: FontWeight.w500,
                              color: themeController.textColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
      ],
    );
  }
}
