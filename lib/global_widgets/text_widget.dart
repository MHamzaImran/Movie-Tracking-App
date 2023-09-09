import 'package:flutter/material.dart';

Text text({
  // all parameters are optional
  required String title,
  double fontSize = 16,
  FontWeight fontWeight = FontWeight.normal,
  Color color = Colors.black,
  TextAlign textAlign = TextAlign.start,
  TextOverflow overflow = TextOverflow.ellipsis,
  int maxLines = 1,
  double letterSpacing = 0,
  double height = 1,
  bool softWrap = true,
  
  
  
}) {
  return Text(
    title,
    textAlign: textAlign,
    overflow: overflow,
    maxLines: maxLines,
    softWrap: softWrap,
    style: TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    ),
  );
}
