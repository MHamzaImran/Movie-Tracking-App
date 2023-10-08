import 'package:flutter/material.dart';
import 'package:movie_tracker/screens/home/details.dart';
import 'package:provider/provider.dart';

import '../../../global_widgets/appbar_widget.dart';
import '../../../global_widgets/responsive.dart';
import '../../../global_widgets/text_widget.dart';
import '../../../models/watch_list.dart';
import '../../../theme/data.dart';

class WatchListScreen extends StatefulWidget {
  const WatchListScreen({Key? key}) : super(key: key);

  @override
  State<WatchListScreen> createState() => _WatchListScreenState();
}

class _WatchListScreenState extends State<WatchListScreen> {
  List deleteList = [];
  bool isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final watchListModel = Provider.of<Watchlist>(context);
    watchListModel.updateListFromApi();

    // print(widget.title);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight(context) * 8),
          child: AppBarWidget(
            title: isDeleting ? 'Selected ${deleteList.length}' : 'Watchlist',
            centerTitle: false,
            showBackButton: true,
            actions: [
              if (watchListModel.itemCount > 0)
                InkWell(
                  onTap: () {
                    if (isDeleting) {
                      if (deleteList.isNotEmpty) {
                        // show delete dialog
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: text(
                                  title: 'Delete',
                                  fontSize: screenWidth(context) * 4,
                                  fontWeight: FontWeight.bold,
                                ),
                                content: text(
                                  title:
                                      'Are you sure you want to delete these items from WatchList?',
                                  fontSize: screenWidth(context) * 4,
                                  fontWeight: FontWeight.w400,
                                  maxLines: 2,
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: text(
                                        title: 'Cancel',
                                        fontSize: screenWidth(context) * 4,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  TextButton(
                                      onPressed: () async {
                                        for (int i = 0;
                                            i < deleteList.length;
                                            i++) {
                                          watchListModel.removeFromWatchlist(
                                              deleteList[i]);
                                        }
                                        setState(() {
                                          isDeleting = false;
                                          deleteList = [];
                                        });
                                        setState(() {});
                                        if (!mounted) return;
                                        Navigator.pop(context);
                                      },
                                      child: text(
                                        title: 'Delete',
                                        fontSize: screenWidth(context) * 4,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ],
                              );
                            });
                      } else {
                        setState(() {
                          isDeleting = false;
                        });
                      }
                    } else {
                      setState(() {
                        isDeleting = true;
                      });
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: screenWidth(context) * 4),
                    child: Icon(
                      isDeleting ? Icons.check : Icons.delete,
                      color: Colors.black,
                      size: screenHeight(context) * 3,
                    ),
                  ),
                )
            ],
          )),
      body: Padding(
        padding: EdgeInsets.symmetric(
                horizontal: screenWidth(context) * 4,
                vertical: screenHeight(context) * 2)
            .copyWith(bottom: screenHeight(context) * 8),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (watchListModel.itemCount > 0)
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: screenWidth(context) * 50,
                      childAspectRatio: 9 / 15,
                      crossAxisSpacing: screenWidth(context) * 5,
                      mainAxisSpacing: screenWidth(context) * 0),
                  itemCount: watchListModel.itemCount,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (isDeleting) {
                          setState(() {
                            if (deleteList.contains(
                                watchListModel.getWatchlist[index].movieId)) {
                              deleteList.remove(
                                  watchListModel.getWatchlist[index].movieId);
                            } else {
                              deleteList.add(
                                  watchListModel.getWatchlist[index].movieId);
                            }
                          });
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                      id: watchListModel
                                          .getWatchlist[index].movieId,
                                      mediaType: watchListModel
                                          .getWatchlist[index].mediaType)));
                        }
                      },
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Opacity(
                                opacity: deleteList.contains(watchListModel
                                        .getWatchlist[index].movieId)
                                    ? 0.5
                                    : 1,
                                child: Image.network(
                                  "https://image.tmdb.org/t/p/w500/${watchListModel.getWatchlist[index].posterPath}",
                                  height: screenHeight(context) *
                                      30, // Increase the image size
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              if (deleteList.contains(
                                  watchListModel.getWatchlist[index].movieId))
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Icon(
                                    Icons.check_circle,
                                    color: AppTheme.lightPrimaryColor,
                                    size: screenHeight(context) * 4,
                                  ),
                                )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: text(
                                title: watchListModel
                                    .getWatchlist[index].movieTitle,
                                fontSize: screenWidth(context) * 3,
                              ))
                        ],
                      ),
                    );
                  },
                ),
              ),
            if (watchListModel.itemCount < 1)
              Expanded(
                  child: Center(
                      child: text(
                title: 'No items in Watchlist',
                fontSize: screenWidth(context) * 4,
                fontWeight: FontWeight.bold,
              )))
          ],
        ),
      ),
    );
  }
}
