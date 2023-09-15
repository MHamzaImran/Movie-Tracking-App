import 'package:flutter/material.dart';

import '../../global_widgets/appbar_widget.dart';
import '../../global_widgets/responsive.dart';
import '../../global_widgets/text_widget.dart';
import '../../network_connection/network.dart';
import '../../theme/data.dart';

class DetailScreen extends StatefulWidget {
  final int id;
  const DetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  var movieData = {};
  bool showLoading = false;
  
  getMovieData() async {
    setState(() {
      showLoading = true;
    });
    var response = await Network().get('/3/movie/${widget.id}');
    print(response);
    setState(() {
      movieData = response;
      // print(sliderMovies);
    });
    setState(() {
      showLoading = false;
    });
  }

  @override
  void initState() {
    getMovieData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.id);
    print(movieData);
    print(movieData.runtimeType);
    print(movieData['original_title']);

    return Scaffold(
        body: showLoading? Center(
          child: CircularProgressIndicator(
            color: Colors.black,
          ),
        ):ListView(
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
                  fit: BoxFit.fitWidth, // Adjust the fit property as needed
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
                      title: movieData['original_title'],
                      fontSize: screenWidth(context) * 4,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.lightPrimaryColor,
                    ),
                    SizedBox(height: screenHeight(context) * 1),
                    // rating and duration
                    Row(
                      children: [
                        // duration icon
                        Icon(
                          Icons.person,
                          color: AppTheme.lightPrimaryColor,
                          size: screenWidth(context) * 4,
                        ),
                        SizedBox(width: screenWidth(context) * 1),

                        text(
                          title: movieData['vote_count'].toString(),
                          fontSize: screenWidth(context) * 3,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.lightPrimaryColor,
                        ),
                        SizedBox(width: screenWidth(context) * 3),
                        // rating icon
                        Icon(
                          Icons.star,
                          color: AppTheme.lightPrimaryColor,
                          size: screenWidth(context) * 4,
                        ),
                        SizedBox(width: screenWidth(context) * 1),

                        text(
                          title: '${movieData['vote_average']} (IMDB)',
                          fontSize: screenWidth(context) * 3,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.lightPrimaryColor,
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight(context) * 1),
                    text(
                      title: movieData['tagline'],
                      fontSize: screenWidth(context) * 3,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      maxLines: 3,
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
                detailButton(context, 'Rating'),
                detailButton(context, 'Guide'),
                detailButton(context, 'Award'),
                detailButton(context, 'Cast'),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  detailButton(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        // setState(() {
        //   if(selectedFilter == title) {
        //     selectedFilter = '';
        //   } else {
        //     selectedFilter = title;
        //   }
        // });
      },
      child: SizedBox(
        width: screenWidth(context) * 22,
        child: Card(
          elevation: 0,
          color: Colors.grey[200],
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
}
