import 'package:flutter/material.dart';
import 'package:movie_tracker/screens/home/details.dart';

import '../../global_widgets/appbar_widget.dart';
import '../../global_widgets/responsive.dart';
import '../../global_widgets/text_widget.dart';
import '../../network_connection/network.dart';

class ListScreen extends StatefulWidget {
  final String title;
  final String mediaType;
  const ListScreen({Key? key, required this.title, required this.mediaType}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  String category = '';
  int currentPage = 1;
  int totalPage = 1;
  bool isLoading = false;
  List movies = [];

  getCategory() async {
    if (widget.title == 'Popular Movies') {
      category = 'popular';
    } else if (widget.title == 'Top Rated') {
      category = 'top_rated';
    } else if (widget.title == 'Upcoming') {
      category = 'upcoming';
    } else if (widget.title == 'Now Playing') {
      category = 'now_playing';
    } else if (widget.title == 'Popular Shows') {
      category = 'popular';
    } else if (widget.title == 'Top Rated Shows') {
      category = 'top_rated';
    } else if (widget.title == 'On The Air') {
      category = 'on_the_air';
    } else if (widget.title == 'Shows Airing Today') {
      category = 'airing_today';
    }
    print(category);
  }

  getMovies() async {
    try {
      setState(() {
        isLoading = true;
      });
      await getCategory();
      var response = await Network()
          .get('/3/${widget.mediaType}/$category?language=en-US&page=$currentPage');
      print(response);
      setState(() {
        movies = response['results'];
        // remove movies with null poster
        movies.removeWhere((element) => element['poster_path'] == null);
        totalPage = response['total_pages'];
      });
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
    getMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.title);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight(context) * 8),
          child: AppBarWidget(
            title: widget.title,
            centerTitle: false,
            showBackButton: true,
          )),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.black),
            )
          : Padding(
              padding: EdgeInsets.symmetric(
                      horizontal: screenWidth(context) * 4,
                      vertical: screenHeight(context) * 2)
                  .copyWith(bottom: screenHeight(context) * 8),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: screenWidth(context) * 50,
                          childAspectRatio: 9 / 15,
                          crossAxisSpacing: screenWidth(context) * 5,
                          mainAxisSpacing: screenWidth(context) * 0),
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                          id: movies[index]['id'],
                                      mediaType: widget.mediaType,
                                        )));
                          },
                          child: Column(
                            children: [
                              Image.network(
                                "https://image.tmdb.org/t/p/w500/${movies[index]['poster_path']}",
                                height: screenHeight(context) *
                                    30, // Increase the image size
                                fit: BoxFit.fitWidth,
                              ),
                              const SizedBox(height: 10),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: text(
                                    title: movies[index]['original_title'] ??
                                        movies[index]['original_name'],
                                    fontSize: screenWidth(context) * 3,
                                  ))
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (currentPage > 1) {
                            setState(() {
                              currentPage--;
                            });
                            getMovies();
                          }
                        },
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                      text(
                        title: '$currentPage of $totalPage',
                        fontSize: screenWidth(context) * 3,
                      ),
                      IconButton(
                        onPressed: () {
                          if (currentPage < totalPage) {
                            setState(() {
                              currentPage++;
                            });
                            getMovies();
                          }
                        },
                        icon: const Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
