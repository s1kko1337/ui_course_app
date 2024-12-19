import 'package:flutter/material.dart';
import 'package:flutter_course_project/app_data_loader.dart';
import 'package:flutter_course_project/components/gray_text.dart';
import 'package:flutter_course_project/components/orange_button_style.dart';
import 'package:flutter_course_project/components/custom_card.dart';
import 'package:flutter_course_project/colors/root_colors.dart';

class DbTestScreen extends StatelessWidget {
  const DbTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = RootColors();
    final AppDataManager appData = AppDataManager();

    return Center(
      child: CustomCard(
        height: 650,
        width: 450,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyles.elevatedButtonStyle(colors),
              onPressed: () async {
                appData.resetChats();
              },
              child: const GrayText(text: 'Сбросить список чатов'),
            ),
          ],
        ),
      ),
    );
  }
}
