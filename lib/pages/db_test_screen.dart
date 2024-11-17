import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_course_project/app_data_loader.dart';
import 'package:flutter_course_project/components/default_text.dart';
import 'package:flutter_course_project/components/gray_text.dart';
import 'package:flutter_course_project/components/orange_button_style.dart';
import 'package:provider/provider.dart';
import 'package:flutter_course_project/db/db_provider.dart';
import 'package:flutter_course_project/models/portfolios.dart';
import 'package:flutter_course_project/components/custom_card.dart';
import 'package:flutter_course_project/colors/root_colors.dart';

class DbTestScreen extends StatelessWidget {
  const DbTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = RootColors();
    final dbProvider = Provider.of<DbProvider>(context);
    final AppDataManager appData = AppDataManager();

    return Center(
      child: CustomCard(
        height: 650,
        width: 450,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DefaultText(text: dbProvider.statusMessage),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyles.elevatedButtonStyle(colors),
              onPressed: () async {
                await dbProvider.connect();
              },
              child: const GrayText(text: 'Подключиться к базе'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyles.elevatedButtonStyle(colors),
              onPressed: () async {
                await dbProvider.getWorks();
              },
              child: const GrayText(text: 'Тестовый запрос к базе'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyles.elevatedButtonStyle(colors),
              onPressed: () async {
                appData.resetModels();
              },
              child: const GrayText(text: 'Тестовый запрос к базе'),
            ),
          ],
        ),
      ),
    );
  }
}
