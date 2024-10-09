import 'package:flutter/material.dart';
import 'package:flutter_course_project/components/custom_card.dart';
import 'package:flutter_course_project/components/default_text.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CustomCard(
        height: 313,
        width: 369,
        child: DefaultText(text: 'Здесь будет форма для обратной связи'),
      ),
    );
  }
}
