import 'package:flutter/material.dart';
import 'package:movie_tracker/global_widgets/responsive.dart';
import 'package:movie_tracker/global_widgets/text_widget.dart';

import '../theme/data.dart';

class AppBarWidget extends StatelessWidget {
  final String title;
  final bool centerTitle;
  final Color backgroundColor;
  final actions;
  final bool showBackButton;
  const AppBarWidget({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.backgroundColor = const Color(0xFFF5C418),
    this.actions, this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      backgroundColor: AppTheme.lightPrimaryColor,
      automaticallyImplyLeading: false,
      title: text(
        title: title,
        fontSize: screenWidth(context) * 4,
        fontWeight: FontWeight.bold,
      ),
      leading: showBackButton ? IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios,color: Colors.black,),
      ) : null,
      toolbarHeight: screenHeight(context) * 8,
      actions: actions,
    );
  }
}
