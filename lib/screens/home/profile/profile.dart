import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_tracker/global_widgets/responsive.dart';
import 'package:movie_tracker/screens/home/profile/profileData.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../global_widgets/text_widget.dart';
import '../../../network_connection/google_sign_in.dart';
import '../../../theme/data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String email = '';
  String profileUrl = '';
  

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // final userProfile = state.userProfile!;
        if (state.userProfile != null) {
          final userProfile = state.userProfile!;

          // Now you can access user information
          name = userProfile.name;
          email = userProfile.email;
          profileUrl = userProfile.profileUrl;
          print(name);
          print(email);
          print(profileUrl);
        }
        ProfileState profileState = context.read<ProfileCubit>().state;
        print(profileState);
        return Scaffold(
          body: Column(
            children: [
              SizedBox(height: screenHeight(context) * 5),
              SizedBox(
                height: screenWidth(context) * 25,
                child: Row(
                  children: [
                    SizedBox(
                      width: screenWidth(context) * 5,
                    ),
                    SizedBox(
                      width: screenWidth(context) * 25,
                      child: Card(
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(10), // Same radius as Card
                          child: profileUrl == '' ? Image.asset(
                            'assets/profile.png',
                            fit: BoxFit.cover,
                          ): Image.network(
                            profileUrl,
                            fit: BoxFit.cover,
                          )
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth(context) * 3,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text(
                              title: name,
                              color: Colors.black,
                              fontSize: screenWidth(context) * 3.5,
                              fontWeight: FontWeight.bold),
                          text(
                            title: email,
                            color: Colors.black,
                            fontSize: screenWidth(context) * 3.5,
                          ),
                          // Button for edit details
                          Container(
                            width: screenWidth(context) * 25,
                            height: screenHeight(context) * 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black),
                            ),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: text(
                                title: 'Edit Details',
                                color: Colors.black,
                                fontSize: screenWidth(context) * 3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight(context) * 3),
              section(context, 'Watchlist'),
              SizedBox(height: screenHeight(context) * 3),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: screenWidth(context) * 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text(
                      title: 'Activities',
                      fontSize: screenWidth(context) * 3.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    Icon(Icons.arrow_forward_ios,
                        size: screenWidth(context) * 4),
                  ],
                ),
              ),
              SizedBox(height: screenHeight(context) * 2),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: screenWidth(context) * 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text(
                      title: 'Preferences',
                      fontSize: screenWidth(context) * 3.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    Icon(Icons.arrow_forward_ios,
                        size: screenWidth(context) * 4),
                  ],
                ),
              ),
              SizedBox(height: screenHeight(context) * 2),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: screenWidth(context) * 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text(
                      title: 'Settings',
                      fontSize: screenWidth(context) * 3.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    Icon(Icons.arrow_forward_ios,
                        size: screenWidth(context) * 4),
                  ],
                ),
              ),
              SizedBox(height: screenHeight(context) * 2),
              const Spacer(),
              // logout button
              Container(
                width: double.infinity,
                height: screenHeight(context) * 5,
                margin:
                    EdgeInsets.symmetric(horizontal: screenWidth(context) * 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                ),
                child: ElevatedButton(
                  onPressed: () async{
                    // await GoogleSignInProvider().logout();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: text(
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
      },
    );
  }

  section(BuildContext context, String title) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth(context) * 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              text(
                title: title,
                fontSize: screenWidth(context) * 3.5,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              Icon(Icons.arrow_forward_ios, size: screenWidth(context) * 4),
            ],
          ),
        ),
        SizedBox(height: screenHeight(context) * 2),
        Container(
          height: screenHeight(context) * 25,
          margin: EdgeInsets.symmetric(horizontal: screenWidth(context) * 5),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (var i = 0; i < 10; i++)
                Padding(
                  padding: EdgeInsets.only(right: screenWidth(context) * 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/top10card1.png',
                        height: screenHeight(context) * 20,
                        // width: screenWidth(context) * 40,
                        fit: BoxFit.fitHeight,
                      ),
                      SizedBox(height: screenWidth(context) * 2),
                      text(
                        title: 'hawkeye',
                        fontSize: screenWidth(context) * 3.5,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }
}
