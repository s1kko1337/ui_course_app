import 'package:flutter/material.dart';
import 'package:flutter_course_project/colors/root_colors.dart';

class CardText extends StatelessWidget {
  final String text;

  const CardText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = RootColors();
    return Text(
      text,
      style: TextStyle(
        color: colors.TextCol,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }
}
