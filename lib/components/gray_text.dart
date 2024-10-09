import 'package:flutter/material.dart';
import 'package:flutter_course_project/colors/root_colors.dart';

class GrayText extends StatelessWidget {
  final String text;

  const GrayText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = RootColors();
    return Text(
      text,
      style: TextStyle(
        color: colors.CardBaldCol,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }
}
