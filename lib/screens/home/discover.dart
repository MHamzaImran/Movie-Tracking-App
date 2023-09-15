import 'package:flutter/material.dart';

import '../../global_widgets/appbar_widget.dart';
import '../../global_widgets/responsive.dart';
import '../../global_widgets/text_widget.dart';
import '../../theme/data.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String selectedFilter = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight(context) * 8),
          child: const AppBarWidget(
            title: 'Discover',
            centerTitle: false,
          )),
      body: Column(
        children: [
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
                  filterButton(context, 'Videos'),
                  filterButton(context, 'TV Shows'),
                  filterButton(context, 'Streaming'),
                  filterButton(context, 'News'),
                ],
              ),
            ),
          ),
          Expanded( 
            child: ListView(
              children: [
                section(context,'Most Watched Trailers'),
                section(context,'Most Watched Interviews'),
                section(context,'Most Watched Tv Shows'),
                SizedBox(height: screenHeight(context) * 10,),
                
              ],
            ),
          ),
        ],
      ),
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
          ],
        );
  }

  filterButton(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if(selectedFilter == title) {
            selectedFilter = '';
          } else {
            selectedFilter = title;
          }
        });
      },
      child: SizedBox(
        width: screenWidth(context) * 22,
        child: Card(
          elevation: 0,
          color: selectedFilter == title? AppTheme.lightPrimaryColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: AppTheme.lightPrimaryColor,
              width: 2,
            ),
          ),
          child: Align(
            alignment: Alignment.center,
            child: text(
              title: title,
              fontSize: screenWidth(context) * 3,
              fontWeight: FontWeight.w500,
              color: selectedFilter == title? Colors.white: Colors.black,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
