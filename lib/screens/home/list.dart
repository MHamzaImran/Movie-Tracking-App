import 'package:flutter/material.dart';

import '../../global_widgets/appbar_widget.dart';
import '../../global_widgets/responsive.dart';
import '../../global_widgets/text_widget.dart';

class ListScreen extends StatelessWidget {
  final String title;
  const ListScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight(context) * 8),
          child: AppBarWidget(
            title: title,
            centerTitle: false,
            showBackButton: true,
          )),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal:screenWidth(context) * 4, vertical: screenHeight(context) * 2).copyWith(bottom: screenHeight(context) * 8),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: screenWidth(context) * 50,
              childAspectRatio: 9 / 15,
              crossAxisSpacing: screenWidth(context) * 5,
              mainAxisSpacing: screenWidth(context) * 0),
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
                Align(
                    alignment: Alignment.centerLeft,
                    child: text(title: 'The Witcher', fontSize: screenWidth(context) * 3,))
              ],
            );
          },
        ),
      ),
    );
  }
}
