import 'package:flutter/material.dart';
import 'package:movie_tracker/screens/home/browser/browser.dart';
import 'package:movie_tracker/screens/home/discover.dart';
import 'package:movie_tracker/screens/home/home_screen.dart';
import 'package:movie_tracker/screens/home/profile/profile.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../global_widgets/responsive.dart';
import '../../theme/data.dart';

GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey<NavigatorState>();

int bottomNavigationIndex = 0;

class BottomNavigation extends StatefulWidget {
  final int initialIndex;
  final ValueChanged<int> onIndexChanged;

  const BottomNavigation({
    Key? key,
    required this.initialIndex,
    required this.onIndexChanged,
  }) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  final List<Widget> children = [
    const HomeScreen(),
    const BrowserScreen(),
    const DiscoverScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      onItemSelected: (value) {
    setState(() {});
      },
      popAllScreensOnTapAnyTabs: true,
      screens: children,
      items: [
    PersistentBottomNavBarItem(
      icon: Icon(
        Icons.home_outlined,
        size: screenWidth(context) * 9,
      ),
      title: "Home",
      activeColorPrimary: AppTheme.lightPrimaryColor,
      inactiveColorPrimary: Colors.white,
      textStyle: TextStyle(
        fontSize: screenWidth(context) * 3,
        fontWeight: FontWeight.w600,
        color: AppTheme.lightPrimaryColor,
      ),
    ),
    PersistentBottomNavBarItem(
      icon: Icon(
        Icons.search_outlined,
        size: screenWidth(context) * 9,
      ),
      title: "Browser",
      activeColorPrimary: AppTheme.lightPrimaryColor,
      inactiveColorPrimary: Colors.white,
      textStyle: TextStyle(
        fontSize: screenWidth(context) * 3,
        fontWeight: FontWeight.w600,
        color: AppTheme.lightPrimaryColor,
      ),
    ),
    PersistentBottomNavBarItem(
      icon: Icon(
        Icons.trending_up_outlined,
        size: screenWidth(context) * 9,
      ),
      title: "Discover",
      activeColorPrimary: AppTheme.lightPrimaryColor,
      inactiveColorPrimary: Colors.white,
      textStyle: TextStyle(
        fontSize: screenWidth(context) * 3,
        fontWeight: FontWeight.w600,
        color: AppTheme.lightPrimaryColor,
      ),
    ),
    PersistentBottomNavBarItem(
      icon: Icon(
        Icons.person_outline,
        size: screenWidth(context) * 9,
      ),
      title: "Profile",
      activeColorPrimary: AppTheme.lightPrimaryColor,
      inactiveColorPrimary: Colors.white,
      textStyle: TextStyle(
        fontSize: screenWidth(context) * 3,
        fontWeight: FontWeight.w600,
        color: AppTheme.lightPrimaryColor,
      ),
    ),
      ],
      confineInSafeArea: true,
      backgroundColor: Colors.black,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      margin: EdgeInsets.zero,
      padding: NavBarPadding.all(screenWidth(context) * 2),
      bottomScreenMargin: screenWidth(context) * 2,
      navBarStyle: NavBarStyle.style8,
      navBarHeight: screenWidth(context) * 16,
    );
  }
}
