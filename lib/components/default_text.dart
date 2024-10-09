import 'package:flutter/material.dart';
import 'package:flutter_course_project/colors/root_colors.dart';

class DefaultText extends StatelessWidget {
  final String text;

  const DefaultText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = RootColors();
    return Text(
      text,
      style: TextStyle(
        color: colors.TextCol,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }
}
