import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_tracker/global_widgets/appbar_widget.dart';
import 'package:movie_tracker/global_widgets/responsive.dart';
import 'package:movie_tracker/screens/home/test.dart';
import 'package:movie_tracker/theme/data.dart';

import '../../global_widgets/text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> images = [
    'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
    'https://images.unsplash.com/photo-1586871608370-4adee64d1794?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2862&q=80',
    'https://images.unsplash.com/photo-1586901533048-0e856dff2c0d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
    'https://images.unsplash.com/photo-1586902279476-3244d8d18285?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
    'https://images.unsplash.com/photo-1586943101559-4cdcf86a6f87?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1556&q=80',
    'https://images.unsplash.com/photo-1586951144438-26d4e072b891?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
    'https://images.unsplash.com/photo-1586953983027-d7508a64f4bb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var imageUrl in images) {
        precacheImage(NetworkImage(imageUrl), context);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight(context) * 8),
          child: const AppBarWidget(
            title: 'Movie Tracker',
            centerTitle: false,
          )),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          CarouselSlider.builder(
            itemCount: images.length,
            options: CarouselOptions(
              autoPlay: false,
              aspectRatio: 1.5,
              viewportFraction: 1,
              // enlargeCenterPage: true,
            ),
            itemBuilder: (context, index, realIdx) {
              return Stack(
                children: [
                  const Expanded(
                    child: Image(
                      image: AssetImage('assets/home_cover.png'),
                      width: double.infinity,
                      fit: BoxFit.fitWidth, // Adjust the fit property as needed
                    ),
                  ),
                  // movie title
                  Positioned(
                    bottom: screenHeight(context) * 0,
                    left: screenWidth(context) * 5,
                    child: SizedBox(
                      width: screenWidth(context) * 90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text(
                            title: 'House of the Dragon',
                            fontSize: screenWidth(context) * 4,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.lightPrimaryColor,
                          ),
                          SizedBox(height: screenHeight(context) * 1),
                          text(
                            title:
                                'House of the Dragon is an upcoming American fantasy drama television series created by George R. R. Martin and Ryan Condal for HBO. It is a prequel to Game of Thrones, created as an adaptation of Martin\'s Fire & Blood, a history of House Targaryen, set 300 years before the events of Game of Thrones.',
                            fontSize: screenWidth(context) * 3,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            maxLines: 3,
                          ),
                          SizedBox(height: screenHeight(context) * 1),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CarouselDemo(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.lightPrimaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: text(
                              title: 'See More',
                              fontSize: screenWidth(context) * 3,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          // top 10 movies and see more
          SizedBox(height: screenHeight(context) * 3),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth(context) * 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image(
                  image: const AssetImage(
                    'assets/home_image1.png',
                  ),
                  height: screenHeight(context) * 22,
                  fit: BoxFit.fitHeight,
                ),
                Expanded(
                  child: Container(
                    height: screenHeight(context) * 22,
                    // color: Colors.blue,
                    margin: EdgeInsets.only(left: screenWidth(context) * 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(
                          title: 'Wednesday',
                          fontSize: screenWidth(context) * 3.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        text(
                          title:
                              'Wednesday is an upcoming American dark fantasy comedy streaming television series created by Al Gough and Miles Millar for Netflix based on the Addams Family characters created by Charles Addams.',
                          fontSize: screenWidth(context) * 3,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          maxLines: 3,
                        ),
                        Row(
                          children: [
                            Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth(context) * 2,
                                ),
                                height: screenHeight(context) * 3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppTheme.lightDisabledColor,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: text(
                                    title: 'Adventure',
                                    fontSize: screenWidth(context) * 2.5,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth(context) * 2,
                                ),
                                height: screenHeight(context) * 3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppTheme.lightDisabledColor,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: text(
                                    title: 'Action',
                                    fontSize: screenWidth(context) * 2.5,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth(context) * 2,
                                ),
                                height: screenHeight(context) * 3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppTheme.lightDisabledColor,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: text(
                                    title: 'Drama',
                                    fontSize: screenWidth(context) * 2.5,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            height: screenHeight(context) * 4,
                            width: screenWidth(context) * 15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppTheme.lightPrimaryColor,
                            ),
                            child: Center(
                              child: text(
                                title: 'View',
                                fontSize: screenWidth(context) * 3,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: screenHeight(context) * 3),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth(context) * 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text(
                  title: 'Top 10 Movies',
                  fontSize: screenWidth(context) * 3.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                text(
                  title: 'See More',
                  fontSize: screenWidth(context) * 3.5,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightPrimaryColor,
                ),
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
          SizedBox(height: screenHeight(context) * 3),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth(context) * 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text(
                  title: 'Upcoming Movies',
                  fontSize: screenWidth(context) * 3.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                text(
                  title: 'See More',
                  fontSize: screenWidth(context) * 3.5,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightPrimaryColor,
                ),
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
          buildSection(title: 'You might also like', seeMore: () {
            print('You might also like');
          }),
          SizedBox(height: screenHeight(context) * 15),
        ],
      ),
    );
  }

  buildSection({required String title, Function? seeMore}) {
    return Column(
      children: [
        SizedBox(height: screenHeight(context) * 3),
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
              InkWell(
                onTap: () {
                  if(seeMore != null) seeMore();
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
