import 'package:flutter/material.dart';
import 'package:movie_tracker/global_widgets/responsive.dart';

import '../../global_widgets/text_widget.dart';
import '../../theme/data.dart';

class BrowserScreen extends StatelessWidget {
  const BrowserScreen({Key? key}) : super(key: key);

  // final List<String> items = List.generate(20, (index) => 'Item $index');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // search bar
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
                  decoration: InputDecoration(
                    hintText: 'Search',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: EdgeInsets.zero,
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppTheme.lightPrimaryColor,
                      size: screenWidth(context) * 6,
                    ),
                  ),
                ),
              ),
            ),
            // filter button
            IconButton(
              onPressed: () {
                // open model bottom sheet
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      height: screenHeight(context) * 50,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth(context) * 5,
                        vertical: screenHeight(context) * 3,
                      ),
                      child: Column(
                        children: [
                          // header
                          Row(
                            children: [
                              Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black,
                                size: screenWidth(context) * 4,
                              ),
                              SizedBox(width: screenWidth(context) * 2),
                              text(
                                title: 'Filter',
                                fontSize: screenWidth(context) * 4,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight(context) * 2),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: text(
                              title: 'Sort by',
                              fontSize: screenWidth(context) * 4,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: screenHeight(context) * 2),
                          // circular check box
                          Row(
                            children: [
                              Container(
                                height: screenWidth(context) * 5,
                                width: screenWidth(context) * 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppTheme.lightPrimaryColor,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Container(
                                    height: screenWidth(context) * 2,
                                    width: screenWidth(context) * 2,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppTheme.lightPrimaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: screenWidth(context) * 2),
                              text(
                                title: 'Name',
                                fontSize: screenWidth(context) * 4,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight(context) * 2),
                          Row(
                            children: [
                              Container(
                                height: screenWidth(context) * 5,
                                width: screenWidth(context) * 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppTheme.lightPrimaryColor,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Container(
                                    height: screenWidth(context) * 2,
                                    width: screenWidth(context) * 2,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppTheme.lightPrimaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: screenWidth(context) * 2),
                              text(
                                title: 'Year',
                                fontSize: screenWidth(context) * 4,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight(context) * 2),
                          Row(
                            children: [
                              Container(
                                height: screenWidth(context) * 5,
                                width: screenWidth(context) * 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppTheme.lightPrimaryColor,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Container(
                                    height: screenWidth(context) * 2,
                                    width: screenWidth(context) * 2,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppTheme.lightPrimaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: screenWidth(context) * 2),
                              text(
                                title: 'Rate',
                                fontSize: screenWidth(context) * 4,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight(context) * 2),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight(context) * 5,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                // padding: EdgeInsets.symmetric(
                                //   horizontal: screenWidth(context) * 5,
                                //   vertical: screenHeight(context) * 2,
                                // ),
                              ),
                              child: text(
                                title: 'Apply',
                                fontSize: screenWidth(context) * 3.5,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight(context) * 5),
                        ],
                      ),
                    );
                  },
                );
              },
              icon: Icon(
                Icons.filter_list,
                color: Colors.black,
                size: screenWidth(context) * 6,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
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
                  SizedBox(
                    width: screenWidth(context) * 25,
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth(context) * 2,
                        ),
                        height: screenHeight(context) * 3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppTheme.lightPrimaryColor,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: text(
                            title: 'ALl Shows',
                            fontSize: screenWidth(context) * 3,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: screenWidth(context) * 25,
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
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
                          color: Colors.white,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: text(
                            title: 'Movies',
                            fontSize: screenWidth(context) * 3,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.lightPrimaryColor,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: screenWidth(context) * 25,
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
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
                          color: Colors.white,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: text(
                            title: 'TV Shows',
                            fontSize: screenWidth(context) * 3,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.lightPrimaryColor,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: screenWidth(context) * 25,
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
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
                          color: Colors.white,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: text(
                            title: 'Streaming',
                            fontSize: screenWidth(context) * 3,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.lightPrimaryColor,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: screenWidth(context) * 25,
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
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
                          color: Colors.white,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: text(
                            title: 'News',
                            fontSize: screenWidth(context) * 3,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.lightPrimaryColor,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // GridView.builder(
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2,
          //     childAspectRatio: 0.7, // Adjust aspect ratio as needed
          //   ),
          //   itemCount: 4,
          //   itemBuilder: (context, index) {
          //     return Column(
          //       children: [
          //         Image.asset(
          //           'assets/top10card1.png', // Replace with your image path
          //           width: 100,
          //           height: 100,
          //           fit: BoxFit.cover,
          //         ),
          //         Text(
          //           index.toString(),
          //           style: TextStyle(fontSize: 16),
          //         ),
          //       ],
          //     );
          //   },
          // ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                      horizontal: screenWidth(context) * 5,
                      vertical: screenHeight(context) * 2)
                  .copyWith(bottom: screenHeight(context) * 5),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: screenWidth(context) * 50,
                    childAspectRatio: 9 / 16,
                    crossAxisSpacing: screenWidth(context) * 2,
                    mainAxisSpacing: 0 // Reduce the spacing
                    ),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Image.asset(
                        'assets/top10card1.png',
                        height: screenHeight(context) *
                            30, // Increase the image size
                        fit: BoxFit.fitWidth,
                      ),
                      SizedBox(
                        height: screenHeight(context) * 1,
                      ),
                      Text(
                        'The Witcher',
                        style: TextStyle(
                            fontSize: screenWidth(context) * 3,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
