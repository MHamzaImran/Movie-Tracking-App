import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_tracker/global_widgets/appbar_widget.dart';
import 'package:movie_tracker/global_widgets/responsive.dart';
import 'package:movie_tracker/screens/home/details.dart';
import 'package:movie_tracker/theme/data.dart';

import '../../global_widgets/text_widget.dart';
import '../../network_connection/network.dart';
import 'list.dart';

List popularMovies = [];
List nowPlayingMovies = [];
List topRatedMovies = [];
List upcomingMovies = [];
List sliderMovies = [];

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showLoading = false;

  getPopularMovies() async {
    var response =
        await Network().get('/3/movie/popular?language=en-US&page=2');
    setState(() {
      popularMovies = response['results'];
    });
  }

  getNowPlayingMovies() async {
    var response =
        await Network().get('/3/movie/now_playing?language=en-US&page=2');
    setState(() {
      nowPlayingMovies = response['results'];
      // print(nowPlayingMovies);
    });
  }

  getTopRatedMovies() async {
    var response =
        await Network().get('/3/movie/top_rated?language=en-US&page=1');
    setState(() {
      topRatedMovies = response['results'];
      // print(nowPlayingMovies);
    });
  }

  getUpcomingMovies() async {
    var response =
        await Network().get('/3/movie/upcoming?language=en-US&page=2');
    setState(() {
      upcomingMovies = response['results'];
      // print(nowPlayingMovies);
    });
  }

  getSliderImages() async {
    var response =
        await Network().get('/3/movie/now_playing?language=en-US&page=1');
    setState(() {
      sliderMovies = response['results'];
      // print(sliderMovies);
    });
  }

  getAllData() async {
    try {
      setState(() {
        showLoading = true;
      });
      if (popularMovies.isEmpty) await getPopularMovies();
      if (nowPlayingMovies.isEmpty) await getNowPlayingMovies();
      if (topRatedMovies.isEmpty) await getTopRatedMovies();
      if (upcomingMovies.isEmpty) await getUpcomingMovies();
      if (sliderMovies.isEmpty) await getSliderImages();
    } catch (e) {
      print('Error in Home Screen: $e');
    } finally {
      setState(() {
        showLoading = false;
      });
    }
  }

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   for (var imageUrl in images) {
    //     precacheImage(NetworkImage(imageUrl), context);
    //   }
    // });
    getAllData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // getNowPlayingMovies();
    // print(popularMovies);
    // print(nowPlayingMovies);
    // getTopRatedMovies();
    // getSliderImages();
    // print(sliderMovies);
    // print(sliderMovies[2]['known_for'].length);
    // print(sliderMovies[2]['known_for']);
    // print(sliderMovies[2]['known_for'][1]['original_title']);
    // print("Slider Movies: $sliderMovies");
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight(context) * 8),
          child: const AppBarWidget(
            title: 'Movie Tracker',
            centerTitle: false,
          )),
      backgroundColor: Colors.white,
      body: showLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            )
          : ListView(
              children: [
                CarouselSlider.builder(
                  itemCount: 10,
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 1.5,
                    viewportFraction: 1,
                    // enlargeCenterPage: true,
                  ),
                  itemBuilder: (context, index, realIdx) {
                    return SizedBox(
                      width: screenWidth(context) * 100,
                      height: screenHeight(context) * 40,
                      child: Stack(
                        children: [
                          Opacity(
                            opacity: 0.9,
                            child: Image(
                              image: NetworkImage(
                                "https://image.tmdb.org/t/p/w500/${sliderMovies[index]['backdrop_path']}",
                              ),
                              // width: screenWidth(context) * 100,
                              height: screenHeight(context) * 100,
                              fit: BoxFit.fitHeight,
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
                                    title: sliderMovies[index]
                                        ['original_title'],
                                    fontSize: screenWidth(context) * 4,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.lightPrimaryColor,
                                  ),
                                  SizedBox(height: screenHeight(context) * 1),
                                  text(
                                    title: sliderMovies[index]['overview'],
                                    fontSize: screenWidth(context) * 3,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    maxLines: 3,
                                  ),
                                  SizedBox(height: screenHeight(context) * 1),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => const CarouselDemo(),
                                      //   ),
                                      // );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailScreen(
                                            id: sliderMovies[index]['id'],
                                          ),
                                        ),
                                      );
                                      // print(
                                      //     sliderMovies[index]['id']);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppTheme.lightPrimaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
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
                      ),
                    );
                  },
                ),
                SizedBox(height: screenHeight(context) * 3),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth(context) * 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: screenWidth(context) * 50,
                        child: Image(
                          image: NetworkImage(
                            "https://image.tmdb.org/t/p/w500/${sliderMovies[11]['backdrop_path']}",
                          ),
                          height: screenHeight(context) * 22,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: screenHeight(context) * 22,
                          // color: Colors.blue,
                          margin:
                              EdgeInsets.only(left: screenWidth(context) * 2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text(
                                title: sliderMovies[11]['original_title'] ?? '',
                                fontSize: screenWidth(context) * 3.5,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                              text(
                                title: sliderMovies[11]['overview'] ?? '',
                                fontSize: screenWidth(context) * 3,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                maxLines: 5,
                              ),
                              // vote average
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: screenWidth(context) * 5,
                                  ),
                                  SizedBox(width: screenWidth(context) * 1),
                                  text(
                                    title:
                                        "${sliderMovies[11]['vote_average'] ?? ''} (${sliderMovies[11]['vote_count'] ?? ''})",
                                    fontSize: screenWidth(context) * 3,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                        id: sliderMovies[11]['id'],
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 0,
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
                moviesList(context,
                    title: 'Now Playing', movieList: nowPlayingMovies),
                SizedBox(height: screenHeight(context) * 3),
                moviesList(context,
                    title: 'Popular Movies', movieList: popularMovies),
                SizedBox(height: screenHeight(context) * 3),
                moviesList(context,
                    title: 'Top Rated', movieList: topRatedMovies),
                SizedBox(height: screenHeight(context) * 3),
                moviesList(context,
                    title: 'Upcoming', movieList: upcomingMovies),
                SizedBox(height: screenHeight(context) * 10),
              ],
            ),
    );
  }

  moviesList(BuildContext context,
      {required String title, required List movieList}) {
    return Column(
      children: [
        header(context, title),
        SizedBox(height: screenHeight(context) * 2),
        Container(
          height: screenHeight(context) * 32,
          margin: EdgeInsets.symmetric(horizontal: screenWidth(context) * 5),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movieList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // print(movieList[index]['id']);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        id: movieList[index]['id'],
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(right: screenWidth(context) * 5),
                  child: SizedBox(
                    width: screenWidth(context) * 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the radius as needed
                          child: Image.network(
                            "https://image.tmdb.org/t/p/w500/${movieList[index]['poster_path']}",
                            width: screenWidth(context) * 40,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        SizedBox(height: screenWidth(context) * 2),
                        text(
                          title: movieList[index]['original_title'],
                          fontSize: screenWidth(context) * 3.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  header(BuildContext context, String title) {
    return Padding(
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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListScreen(
                    title: title,
                    mediaType: 'movie',
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
                  if (seeMore != null) seeMore();
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
