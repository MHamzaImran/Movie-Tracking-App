import 'package:flutter/material.dart';
import '../../global_widgets/responsive.dart';
import '../../global_widgets/text_widget.dart';
import '../../network_connection/network.dart';
import '../../theme/data.dart';

class DetailScreen extends StatefulWidget {
  final int id;
  final String mediaType;
  const DetailScreen({Key? key, required this.id, this.mediaType = 'movie'})
      : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  var movieData = {};
  var movieReviews = {};
  var movieCredits = {};
  var similarMovies = {};
  bool showLoading = false;
  String selectedButton = 'Details';

  getMovieData() async {
    var response = {};
    if (widget.mediaType == 'movie') {
      response = await Network().get('/3/movie/${widget.id}');
    } else if (widget.mediaType == 'tv') {
      response = await Network().get('/3/tv/${widget.id}');
      print(response);
    } else {
      response = await Network().get('/3/movie/${widget.id}');
      setState(() {
        movieData = response;
      });
    }
    setState(() {
      movieData = response;
      // print(sliderMovies);
    });
  }

  getReviewsData() async {
    var response = {};
    if (widget.mediaType == 'movie') {
      response = await Network().get('/3/movie/${widget.id}/reviews');
    } else if (widget.mediaType == 'tv') {
      response = await Network().get('/3/tv/${widget.id}/reviews');
    } else {
      response = await Network().get('/3/movie/${widget.id}/reviews');
    }
    setState(() {
      movieReviews = response;
      // print(sliderMovies);
    });
  }

  getCreditsData() async {
    var response = {};
    if (widget.mediaType == 'movie') {
      response = await Network().get('/3/movie/${widget.id}/credits');
    } else if (widget.mediaType == 'tv') {
      response = await Network().get('/3/tv/${widget.id}/credits');
    } else {
      response = await Network().get('/3/movie/${widget.id}/credits');
    }
    setState(() {
      movieCredits = response;
      // print(sliderMovies);
    });
  }

  getSimilarMovies() async {
    var response = {};
    if (widget.mediaType == 'movie') {
      response = await Network()
          .get('/3/movie/${widget.id}/similar?language=en-US&page=1');
    } else if (widget.mediaType == 'tv') {
      print('Getting TV Data');
      response = await Network()
          .get('/3/tv/${widget.id}/similar?language=en-US&page=1');
    } else {
      response = await Network()
          .get('/3/movie/${widget.id}/similar?language=en-US&page=1');
    }
    // print(response);
    setState(() {
      similarMovies = response;
      // print(sliderMovies);
    });
  }

  getAllData() async {
    try {
      setState(() {
        showLoading = true;
      });
      await getMovieData();
      await getReviewsData();
      await getCreditsData();
      await getSimilarMovies();
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        showLoading = false;
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
    print(widget.id);
    print(widget.mediaType);
    // print(similarMovies['results'][0]['original_title']);
    // getSimilarMovies();
    // print(similarMovies);
    return Scaffold(
        body: showLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : ListView(
                children: [
                  Stack(
                    children: [
                      Expanded(
                        child: Opacity(
                          opacity: 0.8, // Adjust the opacity value (0.0 to 1.0)
                          child: Image(
                            image: NetworkImage(
                                "https://image.tmdb.org/t/p/w500/${movieData['backdrop_path']}"),
                            width: double.infinity,
                            fit: BoxFit
                                .fitWidth, // Adjust the fit property as needed
                          ),
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
                                title: movieData['original_title'] ?? '',
                                fontSize: screenWidth(context) * 4,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.lightPrimaryColor,
                              ),
                              SizedBox(height: screenHeight(context) * 1),
                              // rating and duration
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: AppTheme.lightPrimaryColor,
                                    size: screenWidth(context) * 4,
                                  ),
                                  SizedBox(width: screenWidth(context) * 1),

                                  text(
                                    title:
                                        '${movieData['vote_average'] ?? ''} (IMDB)',
                                    fontSize: screenWidth(context) * 3,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.lightPrimaryColor,
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight(context) * 2),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth(context) * 5,
                      vertical: screenHeight(context) * 2,
                    ),
                    child: SizedBox(
                      height: screenHeight(context) * 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          detailButton(context, 'Details'),
                          detailButton(context, 'Reviews'),
                          detailButton(context, 'Credits'),
                        ],
                      ),
                    ),
                  ),
                  if (selectedButton == 'Details') detailsSection(context),
                  if (selectedButton == 'Reviews') reviewSection(context),
                  if (selectedButton == 'Credits') creditSection(context),
                  SizedBox(height: screenHeight(context) * 10),
                ],
              ));
  }

  details(BuildContext context, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth(context) * 5,
      ),
      child: (value.isEmpty)?const SizedBox():Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text(
            title: title,
            fontSize: screenWidth(context) * 3.5,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          SizedBox(height: screenHeight(context) * 1),
          text(
              title: value,
              fontSize: screenWidth(context) * 3.5,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              maxLines: 3),
        ],
      ),
    );
  }

  detailButton(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedButton = title;
        });
        // print(selectedButton);
        // print(title);
      },
      child: SizedBox(
        width: screenWidth(context) * 30,
        child: Card(
          elevation: 0,
          color: selectedButton == title
              ? AppTheme.lightPrimaryColor
              : Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: Colors.black12,
              width: 1,
            ),
          ),
          child: Align(
            alignment: Alignment.center,
            child: text(
              title: title,
              fontSize: screenWidth(context) * 3,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  detailsSection(BuildContext context) {
    return movieData != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth(context) * 5,
                ),
                child: text(
                  title: 'Overview',
                  fontSize: screenWidth(context) * 3.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight(context) * 1),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth(context) * 5,
                ),
                child: text(
                  title: movieData['overview'] ?? '',
                  fontSize: screenWidth(context) * 3.5,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  maxLines: 15,
                ),
              ),
              SizedBox(height: screenHeight(context) * 2),
              // release date
              details(
                  context,
                  widget.mediaType == 'movie'
                      ? 'Release Date'
                      : 'First Air Date',
                  widget.mediaType == 'movie'
                      ? movieData['release_date']
                      : movieData['first_air_date'] ?? ''),
              SizedBox(height: screenHeight(context) * 2),
              details(context, 'Status', movieData['status'] ?? ''),
              SizedBox(height: screenHeight(context) * 2),
              details(context, 'Tagline', movieData['tagline'] ?? ''),
              SizedBox(height: screenHeight(context) * 2),
              if (widget.mediaType == 'tv')
                Column(
                  children: [
                    details(context, 'Total Season',
                        movieData['number_of_seasons'].toString() ?? ''),
                    SizedBox(height: screenHeight(context) * 2),
                    details(context, 'Total Episode',
                        movieData['number_of_episodes'].toString() ?? ''),
                    SizedBox(height: screenHeight(context) * 2),
                  ],
                ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth(context) * 5,
                ),
                child: text(
                  title: 'Genre',
                  fontSize: screenWidth(context) * 3.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight(context) * 1),
              Container(
                  height: screenHeight(context) * 5,
                  margin: EdgeInsets.symmetric(
                    horizontal: screenWidth(context) * 5,
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movieData['genres'].length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Padding(
                          padding:
                              EdgeInsets.only(right: screenWidth(context) * 2),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth(context) * 5,
                              vertical: screenHeight(context) * 1,
                            ),
                            decoration: BoxDecoration(
                              // color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(
                                screenWidth(context) * 2,
                              ),
                              border: Border.all(
                                color: AppTheme.lightPrimaryColor,
                              ),
                            ),
                            child: text(
                              title: movieData['genres'][index]['name'],
                              fontSize: screenWidth(context) * 3,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  )),
              SizedBox(height: screenHeight(context) * 2),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth(context) * 5,
                ),
                child: SizedBox(
                  height: screenHeight(context) * 6,
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.lightPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                screenWidth(context) * 2,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.black,
                                size: screenWidth(context) * 4,
                              ),
                              SizedBox(width: screenWidth(context) * 2),
                              text(
                                title: 'Add to Watchlist',
                                fontSize: screenWidth(context) * 3,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight(context) * 2),
              movieData['production_companies'].length == 0
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth(context) * 5,
                      ),
                      child: text(
                        title: 'Production Companies',
                        fontSize: screenWidth(context) * 3.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
              SizedBox(height: screenHeight(context) * 1),
              Container(
                height: screenHeight(context) * 10,
                margin: EdgeInsets.symmetric(
                  horizontal: screenWidth(context) * 5,
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movieData['production_companies'].length,
                  itemBuilder: (context, index) {
                    final productionCompany =
                        movieData['production_companies'][index];
                    if (productionCompany['logo_path'] != null) {
                      return Padding(
                        padding:
                            EdgeInsets.only(right: screenWidth(context) * 5),
                        child: SizedBox(
                          width: screenWidth(context) * 25,
                          child: Image.network(
                            "https://image.tmdb.org/t/p/w500/${productionCompany['logo_path']}",
                            width: screenWidth(context) * 25,
                            height: screenHeight(context) * 10,
                          ),
                        ),
                      );
                    } else {
                      return Container(); // Skip items with null logo_path
                    }
                  },
                ),
              ),
              SizedBox(height: screenHeight(context) * 2),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth(context) * 5,
                ),
                child: text(
                  title: widget.mediaType == 'movie'
                      ? 'Similar Movies'
                      : 'Similar TV Shows',
                  fontSize: screenWidth(context) * 3.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight(context) * 2),
              // Container(
              //   height: screenHeight(context) * 10,
              //   margin: EdgeInsets.symmetric(
              //     horizontal: screenWidth(context) * 5,
              //   ),
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     itemCount: similarMovies['results'].length,
              //     itemBuilder: (context, index) {
              //       print(similarMovies['results'][index]['poster_path']);
              //       final movie =
              //       similarMovies['result'][index];
              //       if (movie['logo_path'] != null) {
              //         return Padding(
              //           padding: EdgeInsets.only(right: screenWidth(context) * 5),
              //           child: SizedBox(
              //             width: screenWidth(context) * 25,
              //             child: Image.network(
              //               "https://image.tmdb.org/t/p/w500/${similarMovies['result'][index]['poster_path']}",
              //               width: screenWidth(context) * 25,
              //               height: screenHeight(context) * 10,
              //             ),
              //           ),
              //         );
              //       } else {
              //         return Container(); // Skip items with null logo_path
              //       }
              //     },
              //   ),
              // ),
              Container(
                  height: screenHeight(context) * 20,
                  margin: EdgeInsets.symmetric(
                    horizontal: screenWidth(context) * 5,
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: similarMovies['results'].length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                id: similarMovies['results'][index]['id'],
                                mediaType: widget.mediaType,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.only(right: screenWidth(context) * 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                10.0), // Adjust the radius as needed
                            child: Image.network(
                              "https://image.tmdb.org/t/p/w500/${similarMovies['results'][index]['poster_path']}",
                              height: screenHeight(context) * 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  )),
            ],
          )
        : Container();
  }

  reviewSection(BuildContext context) {
    return movieReviews['results'] != null && movieReviews['results'].length > 0
        ? Column(
            children: [
              SizedBox(height: screenHeight(context) * 2),
              for (var i = 0; i < movieReviews['results'].length; i++)
                Container(
                  width: screenWidth(context) * 90,
                  margin: EdgeInsets.only(
                    bottom: screenHeight(context) * 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth(context) * 5,
                      vertical: screenHeight(context) * 2,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(
                          title: movieReviews['results'][0]['author'],
                          fontSize: screenWidth(context) * 3.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        SizedBox(height: screenHeight(context) * 1),
                        text(
                          title: movieReviews['results'][0]['content'],
                          fontSize: screenWidth(context) * 3.5,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          maxLines: 50,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          )
        : Center(
            child: text(
              title: 'No Reviews',
              fontSize: screenWidth(context) * 3.5,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          );
  }

  creditSection(BuildContext context) {
    return movieCredits['cast'] != null
        ? Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth(context) * 3,
              vertical: screenHeight(context) * 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text(
                  title: 'Cast',
                  fontSize: screenWidth(context) * 4,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                SizedBox(height: screenHeight(context) * 2),
                Wrap(
                  spacing: 2, // Spacing between items horizontally
                  runSpacing: 5.0, // Spacing between items vertically
                  children: List.generate(
                    movieCredits['cast'].length,
                    (index) {
                      final profilePath =
                          movieCredits['cast'][index]['profile_path'];
                      // Check if profilePath is not null
                      if (profilePath != null) {
                        return SizedBox(
                          width: screenWidth(context) * 30,
                          child: Column(
                            children: [
                              ClipOval(
                                child: SizedBox(
                                  width: screenWidth(context) * 30,
                                  height: screenWidth(context) * 30,
                                  child: Image.network(
                                    "https://image.tmdb.org/t/p/w500/$profilePath",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight(context) * 1),
                              SizedBox(
                                width: screenWidth(context) * 30,
                                child: text(
                                  title: movieCredits['cast'][index]['name'],
                                  fontSize: screenWidth(context) * 3,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Return a Column with a grey circle and cast name
                        return Column(
                          children: [
                            ClipOval(
                              child: Container(
                                color: Colors.grey[200],
                                width: screenWidth(context) * 30,
                                height: screenWidth(context) * 30,
                                child: Image.asset(
                                  "assets/cast.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight(context) * 1),
                            text(
                              title: movieCredits['cast'][index]['name'],
                              fontSize: screenWidth(context) * 2.5,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      }
                    },
                  ).where((widget) => widget != null).toList(),
                ),
                SizedBox(height: screenHeight(context) * 5),
                text(
                  title: 'Crew',
                  fontSize: screenWidth(context) * 4,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                SizedBox(height: screenHeight(context) * 2),
                Wrap(
                  spacing: 2, // Spacing between items horizontally
                  runSpacing: 5.0, // Spacing between items vertically
                  children: List.generate(
                    movieCredits['crew'].length,
                    (index) {
                      final profilePath =
                          movieCredits['crew'][index]['profile_path'];
                      // Check if profilePath is not null
                      if (profilePath != null) {
                        return SizedBox(
                          width: screenWidth(context) * 30,
                          child: Column(
                            children: [
                              ClipOval(
                                child: SizedBox(
                                  width: screenWidth(context) * 30,
                                  height: screenWidth(context) * 30,
                                  child: Image.network(
                                    "https://image.tmdb.org/t/p/w500/$profilePath",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight(context) * 1),
                              SizedBox(
                                width: screenWidth(context) * 30,
                                child: text(
                                  title: movieCredits['crew'][index]['name'],
                                  fontSize: screenWidth(context) * 3,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Return a Column with a grey circle and cast name
                        return Column(
                          children: [
                            ClipOval(
                              child: Container(
                                color: Colors.grey[200],
                                width: screenWidth(context) * 30,
                                height: screenWidth(context) * 30,
                                child: Image.asset(
                                  "assets/cast.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight(context) * 1),
                            text(
                              title: movieCredits['crew'][index]['name'],
                              fontSize: screenWidth(context) * 2.5,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      }
                    },
                  ).where((widget) => widget != null).toList(),
                ),
              ],
            ),
          )
        : Container();
  }
}
