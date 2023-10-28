import 'package:flutter/material.dart';
import 'package:movie_tracker/screens/home/details.dart';
import 'package:provider/provider.dart';

import '../../global_widgets/appbar_widget.dart';
import '../../global_widgets/responsive.dart';
import '../../global_widgets/text_widget.dart';
import '../../models/theme.dart';
import '../../network_connection/network.dart';
import '../../theme/data.dart';
import 'list.dart';

List airingTodayTV = [];
List popularShows = [];
List onTheAirTV = [];
List topRatedShows = [];

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String selectedFilter = '';
  bool isLoading = false;

  getAiringTodayTV() async {
    var response =
        await Network().get('/3/tv/airing_today?language=en-US&page=1');
    setState(() {
      airingTodayTV = response['results'];
    });
  }

  getPopularShows() async {
    var response = await Network().get('/3/tv/popular?language=en-US&page=2');
    setState(() {
      popularShows = response['results'];
    });
  }

  getOnTheAirTV() async {
    var response =
        await Network().get('/3/tv/on_the_air?language=en-US&page=3');
    setState(() {
      onTheAirTV = response['results'];
    });
  }

  getTopRatedShows() async {
    var response = await Network().get('/3/tv/top_rated?language=en-US&page=1');
    setState(() {
      topRatedShows = response['results'];
    });
  }

  getAllData() async {
    try {
      setState(() {
        isLoading = true;
      });
      await getAiringTodayTV();
      await getPopularShows();
      await getOnTheAirTV();
      await getTopRatedShows();
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getAllData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight(context) * 8),
          child: const AppBarWidget(
            title: 'Discover',
            centerTitle: false,
          )),
      backgroundColor: themeController.backgroundColor,
      body: Column(
        children: [
          SizedBox(height: screenHeight(context) * 2),
          // Padding(
          //   padding: EdgeInsets.symmetric(
          //     horizontal: screenWidth(context) * 5,
          //     vertical: screenHeight(context) * 2,
          //   ),
          //   child: SizedBox(
          //     height: screenHeight(context) * 5,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         filterButton(context, 'Videos'),
          //         filterButton(context, 'TV Shows'),
          //         filterButton(context, 'Streaming'),
          //         filterButton(context, 'News'),
          //       ],
          //     ),
          //   ),
          // ),
          isLoading
              ? Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: themeController.textColor,
                    ),
                  ),
                )
              : Expanded(
                  child: ListView(
                    children: [
                      section(context, themeController, 'Shows Airing Today',
                          airingTodayTV),
                      section(context, themeController, 'Popular Shows',
                          popularShows),
                      section(
                          context, themeController, 'On The Air', onTheAirTV),
                      section(context, themeController, 'Top Rated Shows',
                          topRatedShows),
                      // section(context, 'Most Watched Interviews'),
                      // section(context, 'Most Watched Tv Shows'),
                      SizedBox(
                        height: screenHeight(context) * 10,
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  section(BuildContext context, themeController, String title, List list) {
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
                color: themeController.textColor,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListScreen(
                        title: title,
                        mediaType: 'tv',
                      ),
                    ),
                  );
                },
                child: text(
                  title: 'See More',
                  fontSize: screenWidth(context) * 3.5,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: screenHeight(context) * 2),
        Container(
          height: screenHeight(context) * 30,
          margin: EdgeInsets.symmetric(horizontal: screenWidth(context) * 5),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (var i = 0; i < list.length; i++)
                GestureDetector(
                  onTap: () {
                    print(list[i]['id']);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailScreen(id: list[i]['id'], mediaType: 'tv'),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: screenWidth(context) * 40,
                    child: Padding(
                      padding: EdgeInsets.only(right: screenWidth(context) * 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            'https://image.tmdb.org/t/p/w500${list[i]['poster_path']}',
                            height: screenHeight(context) * 25,
                            // width: screenWidth(context) * 40,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: screenWidth(context) * 2),
                          text(
                            title: list[i]['original_name'],
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
