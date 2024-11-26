import 'package:flutter/material.dart';
import 'package:flutter_course_project/colors/root_colors.dart';

class CustomCard extends StatelessWidget {
  final Widget? child;
  final double height;
  final double width;

  const CustomCard({
    super.key,
    required this.child,
    this.height = 150,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    final colors = RootColors();
    return Container(
      decoration: BoxDecoration(
        color: colors.CardCol,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(192, 110, 33, 0.07),
            blurRadius: 2,
            spreadRadius: 0,
            offset: Offset(
              0,
              1,
            ),
          ),
          BoxShadow(
            color: Color.fromRGBO(192, 110, 33, 0.07),
            blurRadius: 4,
            spreadRadius: 0,
            offset: Offset(
              0,
              2,
            ),
          ),
          BoxShadow(
            color: Color.fromRGBO(192, 110, 33, 0.07),
            blurRadius: 8,
            spreadRadius: 0,
            offset: Offset(
              0,
              4,
            ),
          ),
          BoxShadow(
            color: Color.fromRGBO(192, 110, 33, 0.07),
            blurRadius: 16,
            spreadRadius: 0,
            offset: Offset(
              0,
              8,
            ),
          ),
          BoxShadow(
            color: Color.fromRGBO(192, 110, 33, 0.07),
            blurRadius: 32,
            spreadRadius: 0,
            offset: Offset(
              0,
              16,
            ),
          ),
          BoxShadow(
            color: Color.fromRGBO(192, 110, 33, 0.07),
            blurRadius: 64,
            spreadRadius: 0,
            offset: Offset(
              0,
              32,
            ),
          ),
        ],
      ),
      height: height,
      width: width,
      child: Center(
        child: child,
      ),
    );
  }
}
