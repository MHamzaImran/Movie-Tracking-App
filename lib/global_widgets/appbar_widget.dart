import 'package:flutter/material.dart';
import 'package:movie_tracker/global_widgets/responsive.dart';
import 'package:movie_tracker/global_widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../models/theme.dart';
import '../theme/data.dart';

class AppBarWidget extends StatelessWidget {
  final String title;
  final bool centerTitle;
  final Color backgroundColor;
  final List<Widget> actions;
  final bool showBackButton;
  const AppBarWidget({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.backgroundColor = const Color(0xFFF5C418),
    this.actions = const[], this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    return AppBar(
      centerTitle: centerTitle,
      backgroundColor: themeController.primaryColor,
      automaticallyImplyLeading: false,
      title: text(
        title: title,
        fontSize: screenWidth(context) * 4,
        fontWeight: FontWeight.bold,
        color: themeController.textColor,
      ),
      leading: showBackButton ? IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_ios,color: themeController.textColor,),
      ) : null,
      toolbarHeight: screenHeight(context) * 8,
      actions: actions == [] ? null : actions,
    );
  }
}
