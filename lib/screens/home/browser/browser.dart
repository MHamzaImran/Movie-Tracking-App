import 'package:flutter/material.dart';
import 'package:movie_tracker/global_widgets/responsive.dart';
import 'package:movie_tracker/screens/home/details.dart';

import '../../../global_widgets/text_widget.dart';
import '../../../network_connection/network.dart';
import '../../../theme/data.dart';

class BrowserScreen extends StatefulWidget {
  const BrowserScreen({Key? key}) : super(key: key);

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  int currentPage = 1;
  int totalPage = 1;
  bool isLoading = false;
  String category = 'All Shows';
  List movies = [];
  List popularMovies = [];
  List searchedMovies = [];
  // text controller for search
  TextEditingController searchController = TextEditingController();

  getPopular() async {
    String cat = '';
    if (category == 'All Shows') {
      cat = 'all';
    } else if (category == 'Movies') {
      cat = 'movie';
    } else if (category == 'TV Shows') {
      cat = 'tv';
    } else {
      cat = 'all';
    }
    setState(() {
      isLoading = true;
    });
    var response =
        await Network().get('/3/trending/$cat/day?language=en-US&page=1');
    setState(() {
      movies = response['results'];
      movies.removeWhere((element) => element['poster_path'] == null);
      isLoading = false;
    });
  }

  searchMovies(String query) async {
    setState(() {
      category = '';
      isLoading = true;
    });
    var response = await Network()
        .get('/3/search/multi?language=en-US&query=$query&page=1');
    print(response);

    // remove with null poster
    setState(() {
      movies = response['results'];
      movies.removeWhere((element) => element['poster_path'] == null);
      isLoading = false;
    });
  }

  @override
  initState() {
    getPopular();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // getPopular();
    print(movies);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: screenWidth(context) * 15,
        title: Row(
          children: [
            SizedBox(width: screenWidth(context) * 2),
            Expanded(
              child: SizedBox(
                height: screenWidth(context) * 10,
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    searchMovies(value);
                  },
                  onSubmitted: (value) {
                    // unfocus
                    FocusScope.of(context).unfocus();
                  },
                  decoration: InputDecoration(
                    hintText: 'Search',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: EdgeInsets.zero,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppTheme.lightPrimaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        // physics: const NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth(context) * 5,
            ),
            child: SizedBox(
              height: screenHeight(context) * 5,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  filterButton(context, 'All Shows', () {
                    if (category != 'All Shows') {
                      setState(() {
                        category = 'All Shows';
                      });
                      getPopular();
                    }
                  }),
                  filterButton(context, 'Movies', () {
                    if (category != 'Movies') {
                      setState(() {
                        category = 'Movies';
                      });
                      getPopular();
                    }
                  }),
                  filterButton(context, 'TV Shows', () {
                    if (category != 'TV Shows') {
                      setState(() {
                        category = 'TV Shows';
                      });
                      getPopular();
                    }
                  }),
                ],
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(
                            horizontal: screenWidth(context) * 5,
                            vertical: screenHeight(context) * 2)
                        .copyWith(bottom: screenHeight(context) * 5),
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
                            print(movies[index]['id']);
                            print(movies[index]['media_type']);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                  id: movies[index]['id'],
                                  mediaType: movies[index]['media_type'],
                                ),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Adjust the radius as needed
                                child: Image.network(
                                  "https://image.tmdb.org/t/p/w500/${movies[index]['poster_path']}",
                                  width: screenWidth(context) * 40,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                              SizedBox(
                                height: screenHeight(context) * 1,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth(context) * 0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: text(
                                    title: movies[index]['original_title'] ??
                                        movies[index]['original_name'] ??
                                        'Unknown',
                                    fontSize: screenWidth(context) * 3,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
          if (movies.isEmpty && !isLoading)
            Center(
              child: text(
                title: 'No results found',
                fontSize: screenWidth(context) * 5,
              ),
            ),
        ],
      ),
    );
  }

  filterButton(BuildContext context, String title, Function onTap) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        searchController.clear();
        onTap();
      },
      child: SizedBox(
        width: screenWidth(context) * 30,
        child: Card(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth(context) * 2,
            ),
            height: screenHeight(context) * 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppTheme.lightPrimaryColor,
              ),
              color:
                  category == title ? AppTheme.lightPrimaryColor : Colors.white,
            ),
            child: Align(
              alignment: Alignment.center,
              child: text(
                title: title,
                fontSize: screenWidth(context) * 3,
                fontWeight: FontWeight.w500,
                color: category == title
                    ? Colors.white
                    : AppTheme.lightPrimaryColor,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
